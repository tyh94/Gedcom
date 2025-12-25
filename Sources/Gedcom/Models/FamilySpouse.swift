//
//  FamilySpouse.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//


import Foundation

public class FamilySpouse: RecordProtocol {
    public var xref: String
    public var notes: [NoteStructure] = []
    
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "NOTE" : \FamilySpouse.notes,
        "SNOTE" : \FamilySpouse.notes,
    ]
    
    public init(xref: String, notes: [NoteStructure] = [])
    {
        self.xref = xref
        self.notes = notes
    }
    required init(record: Record) throws {
        self.xref = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "FAMS", value: xref)
        for note in notes  {
            record.children += [note.export()]
        }
        return record
    }
}
