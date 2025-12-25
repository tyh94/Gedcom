//
//  GedcomParser.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 17.12.2025.
//

import Foundation

public final class GedcomParser: Sendable {
    enum Error: Swift.Error {
        case noData
        case badLine(Int)
    }
    
    public init() {}
    
    public func parse(
        withFile path: URL,
        encoding: String.Encoding = .utf8
    ) throws -> GedcomFile {
        let data = try Data(contentsOf: path)
        return try parse(withData: data, encoding: encoding)
    }
    
    public func parse(
        withData data: Data,
        encoding: String.Encoding = .utf8
    ) throws -> GedcomFile {
        var data = data
        if data.starts(with: [0xef, 0xbb, 0xbf]) {
            // File starts with a BOM, drop it
            data.removeFirst(3)
        }
        guard let gedcomString = String(data: data, encoding: encoding) else {
            throw Error.noData
        }
        
        let records = try parse(string: gedcomString)
        let record = Record(level: 0, tag: "")
        record.children = records
        let gedcom = try GedcomFile(record: record)
        return gedcom
    }
    
    func parse(string gedcom: String) throws -> [Record] {
        var recordStack: [Record] = []
        var recordLines: [Record] = []
        
        var errorOnLine: Int?
        var lineNumber = 1
        gedcom.enumerateLines() { (line, stop) in
            do {
                guard let gedLine = Line(line) else {
                    throw GedcomError.badLine(lineNumber)
                }
                
                let record = Record(line: gedLine)
                
                if gedLine.level == 0 {
                    recordLines.append(record)
                    recordStack = [record]
                } else {
                    if recordStack.last!.line.level == gedLine.level - 1 && gedLine.tag == "CONT" {
                        //
                        if recordStack[recordStack.count - 1].line.value == nil {
                            recordStack[recordStack.count - 1].line.value = ""
                        }
                        recordStack[recordStack.count - 1].line.value!.append("\n\(gedLine.value!)")
                        
                    } else if recordStack.last!.line.level < gedLine.level {
                        recordStack.last!.children.append(record)
                        recordStack.append(record)
                    } else {
                        while recordStack.last!.line.level >= gedLine.level {
                            recordStack.removeLast()
                        }
                        recordStack.last!.children.append(record)
                        recordStack.append(record)
                    }
                }
            } catch {
                stop = true
                errorOnLine = lineNumber
                return
            }
            lineNumber += 1
        }
        
        if let errorOnLine {
            throw Error.badLine(errorOnLine)
        }
        return recordLines
    }
}
