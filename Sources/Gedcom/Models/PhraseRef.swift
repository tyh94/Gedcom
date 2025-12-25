//
//  PhraseRef.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class PhraseRef: RecordProtocol {
    public var tag: String
    public var xref: String
    public var phrase: String?
    
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "PHRASE" : \PhraseRef.phrase,
    ]
    
    public init(tag: String, xref: String, phrase: String? = nil) {
        self.tag = tag
        self.xref = xref
        self.phrase = phrase
    }
    required init(record: Record) throws {
        self.tag = record.line.tag
        self.xref = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: tag, value: xref)
        
        if let phrase {
            record.children += [Record(level: 1, tag: "PHRASE", value: phrase)]
        }
        
        return record
    }
}
