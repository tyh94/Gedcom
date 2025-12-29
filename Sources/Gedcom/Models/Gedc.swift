//
//  Gedc.swift
//  FamilyBook
//
//  Created by Татьяна Макеева on 16.12.2025.
//


import Foundation

public class Gedc: RecordProtocol {
    public var vers: String = "7.0"
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "VERS": \Gedc.vers,
    ]
    
    public init() { }
    
    required init(record: Record) throws {
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "GEDC")
        record.children.append(Record(level: 1, tag: "VERS", value: vers))
        return record
    }
}
