//
//  Role.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class Role: RecordProtocol {
    public var kind: RoleKind
    public var phrase: String?
    
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "PHRASE" : \Role.phrase,
    ]
    
    public init(kind: RoleKind, phrase: String? = nil) {
        self.kind = kind
        self.phrase = phrase
    }
    
    required init(record: Record) throws {
        self.kind = RoleKind(rawValue: record.line.value ?? "OTHER") ?? .OTHER
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "ROLE", value: kind.rawValue)
        if let phrase = phrase {
            record.children += [Record(level: 1, tag: "PHRASE", value: phrase)]
        }
        return record
    }
}
