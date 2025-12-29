//
//  FamilyChild.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class FamilyChild: RecordProtocol {
    public var xref: String
    public var pedigree: Pedigree?
    public var status: ChildStatus?
    public var notes: [NoteStructure] = []
    
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "PEDI" : \FamilyChild.pedigree,
        "STAT" : \FamilyChild.status,
        
        "NOTE" : \FamilyChild.notes,
        "SNOTE" : \FamilyChild.notes,
    ]
    
    public init(
        xref: String,
        pedigree: Pedigree? = nil,
        status: ChildStatus? = nil,
        notes: [NoteStructure] = []
    ) {
        self.xref = xref
        self.pedigree = pedigree
        self.status = status
        self.notes = notes
    }
    
    required init(record: Record) throws {
        self.xref = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "FAMC", value: xref)
        
        if let pedigree {
            record.children += [pedigree.export()]
        }
        if let status {
            record.children += [status.export()]
        }
        
        for note in notes  {
            record.children += [note.export()]
        }
        return record
    }
}
