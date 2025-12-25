//
//  NameType.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class NameType: RecordProtocol {
    public var kind: NameTypeKind
    public var phrase: String?
    
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "PHRASE" : \NameType.phrase,
    ]
    
    init(kind: NameTypeKind, phrase: String? = nil) {
        self.kind = kind
        self.phrase = phrase
    }
    
    required init(record: Record) throws {
        self.kind = NameTypeKind(rawValue: record.line.value ?? "OTHER") ?? .other
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "TYPE", value: kind.rawValue)
        
        if let phrase {
            record.children += [Record(level: 1, tag: "PHRASE", value: phrase)]
        }
        
        return record
    }
}
