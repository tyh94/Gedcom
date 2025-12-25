//
//  SpouseAge.swift
//  FamilyBook
//
//  Created by Татьяна Макеева on 15.12.2025.
//


import Foundation

public class SpouseAge: RecordProtocol {
    var kind: String
    public var age: Age
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "AGE": \SpouseAge.age,
    ]
    init(kind: String, age: String, phrase: String? = nil)
    {
        self.kind = kind
        self.age = Age(age: age, phrase: phrase)
    }
    required init(record: Record) throws {
        kind = record.line.tag
        age = Age()
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: kind)
        
        record.children += [age.export()]
        
        return record
    }
}
