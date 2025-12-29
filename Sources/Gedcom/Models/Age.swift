//
//  Age.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class Age: RecordProtocol {
    public var age: String
    public var phrase: String?
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "PHRASE": \Age.phrase,
    ]
    
    init() {
        age = ""
    }
    
    public  init(age: String, phrase: String? = nil) {
        self.age = age
        self.phrase = phrase
    }
    
    required init(record: Record) throws {
        age = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "AGE", value: age)
        
        if let phrase = phrase {
            record.children += [Record(level: 1, tag: "PHRASE", value: phrase)]
        }
        
        return record
    }
}
