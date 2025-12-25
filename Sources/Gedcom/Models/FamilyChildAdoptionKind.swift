//
//  FamilyChildAdoptionKind.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class FamilyChildAdoptionKind: RecordProtocol {
    public var kind: AdoptionKind
    public var phrase: String?
    
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "PHRASE" : \FamilyChildAdoptionKind.phrase,
    ]
    
    init(kind: AdoptionKind, phrase: String? = nil) {
        self.kind = kind
        self.phrase = phrase
    }
    required init(record: Record) throws {
        self.kind = AdoptionKind(rawValue: record.line.value ?? "") ?? .BOTH
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "ADOP", value: kind.rawValue)
        if let phrase {
            record.children += [Record(level: 1, tag: "PHRASE", value: phrase)]
        }
        return record
    }
}
