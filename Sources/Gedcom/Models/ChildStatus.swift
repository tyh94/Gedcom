//
//  ChildStatus.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class ChildStatus: RecordProtocol {
    public var kind: ChildStatusKind
    public var phrase: String?
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "PHRASE": \ChildStatus.phrase,
    ]
    
    init(kind: ChildStatusKind, phrase: String? = nil) {
        self.kind = kind
        self.phrase = phrase
    }
    
    required init(record: Record) throws {
        self.kind = ChildStatusKind(rawValue: record.line.value ?? "") ?? .CHALLENGED
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "STAT", value: kind.rawValue)
        if let phrase {
            record.children += [Record(level: 1, tag: "PHRASE", value: phrase)]
        }
        return record
    }
}
