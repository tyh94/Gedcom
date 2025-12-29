//
//  IdentifierStructure.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class REFN: RecordProtocol {
    public var refn: String = ""
    public var type: String?
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "TYPE": \REFN.type,
    ]
    
    public init(ident: String, type: String? = nil) {
        self.refn = ident
        self.type = type
    }
    
    required init(record: Record) throws {
        self.refn = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "REFN", value: refn)
        if let type {
            record.children.append(Record(level: 1, tag: "TYPE", value: type))
        }
        return record
    }
}

public class UID: RecordProtocol {
    public var uid: UUID
    
    public init(ident: String) {
        self.uid = UUID(uuidString: ident) ?? UUID()
    }
    
    required init(record: Record) throws {
        self.uid = UUID(uuidString: record.line.value ?? "") ?? UUID()
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "UID", value: uid.uuidString.lowercased())
        return record
    }
}

public class EXID: RecordProtocol {
    public var exid: String = ""
    public var type: String?
    
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "TYPE" : \EXID.type,
    ]
    
    public init(ident: String, type: String? = nil) {
        self.exid = ident
        self.type = type
    }
    
    required init(record: Record) throws {
        self.exid = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    
    func export() -> Record {
        let record = Record(level: 0, tag: "EXID", value: exid)
        if let type {
            record.children.append(Record(level: 1, tag: "TYPE", value: type))
        }
        return record
    }
}


public enum IdentifierStructure {
    case Refn(REFN)
    case Uuid(UID)
    case Exid(EXID)
}

extension IdentifierStructure: RecordProtocol {
    init(record: Record) throws {
        switch record.line.tag {
        case "REFN":
            self = .Refn(try REFN(record: record))
        case "UID":
            self = .Uuid(try UID(record: record))
        case "EXID":
            self = .Exid(try EXID(record: record))
        default:
            throw GedcomError.badRecord
        }
    }
    
    func export() -> Record {
        switch self {
        case .Exid(let ident):
            return ident.export()
        case .Refn(let ident):
            return ident.export()
        case .Uuid(let ident):
            return ident.export()
        }
    }
}

