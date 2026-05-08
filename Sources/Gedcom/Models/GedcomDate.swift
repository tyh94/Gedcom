//
//  GedcomDate.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public enum GedcomDateCalendar: String, Codable {
    case gregorian = "GREG"
    case julian = "JULI"
    case hebrew = "HEBR"
    case french = "FRENCH" // @#DFRENCH R@
    case roman = "ROMAN"   // User extension example? Standards vary.
    case unknown = "UNKNOWN"
    
    var toCalendar: Calendar {
        switch self {
        case .gregorian:
            return Calendar(identifier: .gregorian)
        case .julian:
            return Calendar(identifier: .gregorian)
        case .hebrew:
            return Calendar(identifier: .hebrew)
        case .french:
            return Calendar(identifier: .gregorian)
        case .roman:
            return Calendar(identifier: .gregorian)
        case .unknown:
            return Calendar(identifier: .gregorian)
        }
    }
}

public enum Epoch: Codable, Equatable, RawRepresentable {
    case bc
    case ad
    
    public init?(rawValue string: String) {
        let upper = string.uppercased()
        if upper == "BC" || upper == "BCE" || upper == "B.C." {
            self = .bc
        } else if upper == "AD" || upper == "CE" {
            self = .ad
        } else {
            return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case .bc: return "BC"
        case .ad: return "AD"
        }
    }
}

public struct GedcomSimpleDate: Codable, Equatable {
    public let calendar: GedcomDateCalendar
    public let year: Int?
    public let month: String?
    public let day: Int?
    public let epoch: Epoch?
    
    public init(
        calendar: GedcomDateCalendar = .gregorian,
        year: Int? = nil,
        month: String? = nil,
        day: Int? = nil,
        epoch: Epoch? = nil
    ) {
        self.calendar = calendar
        self.year = year
        self.month = month
        self.day = day
        self.epoch = epoch
    }
}

public enum GedcomDate: Codable, Equatable {
    case exact(GedcomSimpleDate)
    case approx(kind: ApproxKind, date: GedcomSimpleDate)
    case between(start: GedcomSimpleDate, end: GedcomSimpleDate)
    case range(start: GedcomSimpleDate?, end: GedcomSimpleDate?) // FROM.. or TO.. or FROM..TO..
    case phrase(String)
    
    public enum ApproxKind: String, Codable {
        case about = "ABT"
        case calculated = "CAL"
        case estimated = "EST"
    }
}

public enum GedcomDateParser {
    public static func parse(_ raw: String) -> GedcomDate? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return nil }
        if trimmed.hasPrefix("(") && trimmed.hasSuffix(")") {
            return .phrase(String(trimmed.dropFirst().dropLast()))
        }
        
        let upper = trimmed.uppercased()
        let parts = upper.components(separatedBy: .whitespaces) // Simple tokenization
        
        // Check Range Keywords
        if parts.first == "BET" {
            // Expect BET <Date> AND <Date>
            if let andIndex = parts.firstIndex(of: "AND") {
                let startStr = parts[1..<andIndex].joined(separator: " ")
                let endStr = parts[parts.index(after: andIndex)...].joined(separator: " ")
                if let s = parseSimple(startStr), let e = parseSimple(endStr) {
                    return .between(start: s, end: e)
                }
            }
        }
        
        if parts.first == "FROM" {
            // FROM <Date> [TO <Date>]
            if let toIndex = parts.firstIndex(of: "TO") {
                let startStr = parts[1..<toIndex].joined(separator: " ")
                let endStr = parts[parts.index(after: toIndex)...].joined(separator: " ")
                let s = parseSimple(startStr)
                let e = parseSimple(endStr)
                if s != nil || e != nil {
                    // FROM X TO Y
                    // If one is missing, it's still a range? strict G7 says "FROM <Date> TO <Date>" is RangePeriod.
                    // But "FROM <Date>" is also valid.
                    return .range(start: s, end: e)
                }
            } else {
                // FROM <Date>
                let startStr = parts.dropFirst().joined(separator: " ")
                if let s = parseSimple(startStr) {
                    return .range(start: s, end: nil)
                }
            }
        }
        
        if parts.first == "TO" {
            let endStr = parts.dropFirst().joined(separator: " ")
            if let e = parseSimple(endStr) {
                return .range(start: nil, end: e)
            }
        }
        
        // Approx
        if let k = GedcomDate.ApproxKind(rawValue: parts.first ?? "") {
            let dateStr = parts.dropFirst().joined(separator: " ")
            if let d = parseSimple(dateStr) {
                return .approx(kind: k, date: d)
            }
        }
        
        // Exact
        if let d = parseSimple(upper) {
            return .exact(d)
        }
        
        // INT handling? INT <Date> (<Phrase>)
        if parts.first == "INT" {
            // Fallback to phrase or simple parsing?
            // INT 1800 (Eighteen Hundred)
            // Parsing the date part might work.
            let dateStr = parts.dropFirst().joined(separator: " ")
            // This is tricky without lookahead for parens.
            // For now, treat exact date as fallback
        }
        
        return nil
    }
    
    // Parses: [Escape] [Day] Month Year [Epoch]
    private static func parseSimple(_ raw: String) -> GedcomSimpleDate? {
        var tokens = raw.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        if tokens.isEmpty { return nil }
        
        var calendar: GedcomDateCalendar = .gregorian
        
        // Check calendar escape
        if let first = tokens.first, first.hasPrefix("@#"), first.hasSuffix("@") {
            // @#DHEBREW@
            if first.contains("HEBR") { calendar = .hebrew }
            else if first.contains("FRENCH") { calendar = .french }
            else if first.contains("JULI") { calendar = .julian } // Sometimes GREG/JULI are explicitly set? G7 uses @#DHEBREW@ etc. Standard Gregorian is default.
            else { calendar = .unknown } // or roman
            tokens.removeFirst()
        }
        
        // Epoch at end?
        var epoch: Epoch? = nil
        if let last = tokens.last, let epochRaw = Epoch(rawValue: last) {
            epoch = epochRaw
            tokens.removeLast()
        }
        
        // Format: Day Month Year or Month Year or Year
        // Day is digits. Month is String (or digits in some loose impls, but G7 struct is text).
        // Year is digits (or double dating 1600/01).
        
        var day: Int? = nil
        var month: String? = nil
        var year: Int? = nil
        
        if tokens.isEmpty { return nil }
        
        // Try parsing first token as Day (digits)
        if let d = Int(tokens[0]) {
            day = d
            tokens.removeFirst()
        }
        
        if tokens.isEmpty {
            // Just a Day? Invalid. "Year" is mandatory in simple date?
            // "Date := [Day] Month Year" or just "Year"?
            // GEDCOM allow: "MAY 1990" or "1990".
            // If tokens[0] was 1990, we assigned it to `day`. Oops.
            if let d = day, d > 31 {
                // Likely a year
                year = d
                day = nil
            }
        }
        
        // Next token: Month?
        if !tokens.isEmpty {
            let t = tokens[0]
            // If it's alphanumeric and not digits
            if Int(t) == nil {
                month = t
                tokens.removeFirst()
            }
        }
        
        // Next token: Year?
        if !tokens.isEmpty {
            let t = tokens[0]
            if let y = Int(t) {
                year = y
                tokens.removeFirst()
            } else if t.contains("/") {
                // Dual date: 1699/00
                // Store raw? or parse base year?
                // SimpleDate struct stores int.
                // Ignoring dual date nuance for `year: Int` simplification.
                // Could verify if slash part exists.
                if let slash = t.firstIndex(of: "/") {
                    year = Int(String(t[..<slash]))
                }
            }
        }
        
        // Re-evaluate logic if Year was missing but we parsed a Day that looks like Year
        if year == nil && day != nil && day! > 1000 && month == nil {
            year = day
            day = nil
        }
        
        // Minimal valid date must have Year or Month+Year?
        // Actually, just Year is valid.
        if year != nil || (month != nil) {
            return GedcomSimpleDate(calendar: calendar, year: year, month: month, day: day, epoch: epoch)
        }
        
        return nil
    }
}

extension GedcomDate {
    public func toDate() -> Date? {
        switch self {
        case .exact(let simpleDate):
            return simpleDate.toDate()
            
        case .approx(_, let simpleDate):
            return simpleDate.toDate()
            
        case .between(let start, let end):
            guard let startDate = start.toDate(),
                  let endDate = end.toDate() else { return nil }
            let midInterval = (startDate.timeIntervalSince1970 + endDate.timeIntervalSince1970) / 2
            return Date(timeIntervalSince1970: midInterval)
            
        case .range(let start, let end):
            return start?.toDate() ?? end?.toDate()
            
        case .phrase(let phrase):
            return parsePhraseToDate(phrase)
        }
    }
    
    private func parsePhraseToDate(_ phrase: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let formats = ["yyyy", "MMM yyyy", "d MMM yyyy", "MMMM yyyy"]
        
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: phrase) {
                return date
            }
        }
        return nil
    }
}

extension GedcomSimpleDate {
    public func toDate() -> Date? {
        var components = DateComponents()
        
        let calendar = calendar.toCalendar
        
        components.year = self.year
        components.day = self.day
        components.month = parseMonth(monthString: self.month)
        
        // Обработка эпохи BC/BCE
        if let epoch = self.epoch, epoch == .bc {
            if let year = components.year {
                components.year = -year + 1
            }
        }
        
        // Заполняем пропущенные компоненты
        if components.month == nil && components.year != nil {
            components.month = 1
        }
        if components.day == nil && components.month != nil {
            components.day = 1
        }
        
        // Для случая только года
        if components.year != nil && components.month == nil {
            components.month = 1
            components.day = 1
        }
        
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return calendar.date(from: components)
    }
}

extension GedcomDate {
    public var gedcomString: String {
        switch self {
        case .exact(let date):
            return simpleDateString(date)
        case .approx(let kind, let date):
            return "\(kind.rawValue) \(simpleDateString(date))"
        case .between(let start, let end):
            return "BET \(simpleDateString(start)) AND \(simpleDateString(end))"
        case .range(let start, let end):
            if let s = start, let e = end {
                return "FROM \(simpleDateString(s)) TO \(simpleDateString(e))"
            } else if let s = start {
                return "FROM \(simpleDateString(s))"
            } else if let e = end {
                return "TO \(simpleDateString(e))"
            } else {
                return ""
            }
        case .phrase(let text):
            return text
        }
    }
    
    private func simpleDateString(_ date: GedcomSimpleDate) -> String {
        var parts: [String] = []
        if date.calendar != .gregorian {
            switch date.calendar {
            case .julian: parts.append("@#DJULIAN@")
            case .hebrew: parts.append("@#DHEBREW@")
            case .french: parts.append("@#DFRENCH R@")
            default: break
            }
        }
        if let day = date.day { parts.append("\(day)") }
        if let month = date.month { parts.append(month) }
        if let year = date.year { parts.append("\(year)") }
        if let epoch = date.epoch { parts.append(epoch.rawValue) }
        return parts.joined(separator: " ")
    }
}
