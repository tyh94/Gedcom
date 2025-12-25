//
//  NonFamilyEventStructure.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 15.12.2025.
//

import Foundation

public class NonFamilyEventStructure: RecordProtocol {
    public var kind: FamilyEventKind
    public var date: DatePeriod?
    public var notes: [NoteStructure] = []
    public var citations: [SourceCitation] = []
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "DATE": \NonFamilyEventStructure.date,
        "NOTE": \NonFamilyEventStructure.notes,
        "SNOTE": \NonFamilyEventStructure.notes,
        "SOUR": \NonFamilyEventStructure.citations,
    ]
    
    init(kind: FamilyEventKind,
         date: DatePeriod? = nil,
         notes: [NoteStructure] = [],
         citations: [SourceCitation] = []) {
        self.kind = kind
        self.date = date
        self.notes = notes
        self.citations = citations
    }
    
    required init(record: Record) throws {
        guard let kind = FamilyEventKind(rawValue: record.line.value ?? "") else
        {
            throw GedcomError.badRecord
        }
        self.kind = kind
        
        if kind == .even {
            throw GedcomError.badRecord
        }
        
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "NO", value: kind.rawValue)
        
        if let date {
            record.children += [date.export()]
        }
        
        for note in notes {
            record.children += [note.export()]
        }
        
        for citation in citations {
            record.children += [citation.export()]
        }
        
        return record
    }
}
