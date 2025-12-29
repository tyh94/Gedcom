//
//  FamilyChildAdoption.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class FamilyChildAdoption: RecordProtocol {
    public var xref: String
    public var adoption: FamilyChildAdoptionKind?
    
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "ADOP" : \FamilyChildAdoption.adoption,
    ]
    
    public init(xref: String, adoption: FamilyChildAdoptionKind? = nil) {
        self.xref = xref
        self.adoption = adoption
    }
    
    required init(record: Record) throws {
        self.xref = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "FAMC", value: xref)
        if let adoption {
            record.children += [adoption.export()]
        }
        return record
    }
}
