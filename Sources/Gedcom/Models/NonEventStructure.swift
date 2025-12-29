//
//  NonEventStructure.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class NonEventStructure: RecordProtocol {
    public var kind: IndividualEventKind
    public var date: DatePeriod?
    public var notes: [NoteStructure] = []
    public var citations: [SourceCitation] = []
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "DATE": \NonEventStructure.date,
        "NOTE": \NonEventStructure.notes,
        "SNOTE": \NonEventStructure.notes,
        "SOUR": \NonEventStructure.citations,
    ]
    
    public init(
        kind: IndividualEventKind,
         date: DatePeriod? = nil,
         notes: [NoteStructure] = [],
         citations: [SourceCitation] = []
    ) {
        self.kind = kind
        self.date = date
        self.notes = notes
        self.citations = citations
    }
    
    required init(record: Record) throws {
        self.kind = IndividualEventKind(rawValue: record.line.value ?? "") ?? .even
        
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
