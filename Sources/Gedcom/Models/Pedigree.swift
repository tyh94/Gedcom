//
//  Pedigree.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class Pedigree: RecordProtocol {
    public var kind: PedigreeKind
    public var phrase: String?
    
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "PHRASE" : \Pedigree.phrase,
    ]
    
    public init(
        kind: PedigreeKind,
        phrase: String? = nil
    ) {
        self.kind = kind
        self.phrase = phrase
    }
    
    required init(record: Record) throws {
        self.kind = PedigreeKind(rawValue: record.line.value ?? "OTHER") ?? .OTHER
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "PEDI", value: kind.rawValue)
        if let phrase {
            record.children += [Record(level: 1, tag: "PHRASE", value: phrase)]
        }
        return record
    }
}
