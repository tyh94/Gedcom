//
//  AssoiciationStructure.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class AssoiciationStructure: RecordProtocol {
    public var xref: String
    public var phrase: String?
    public var role: Role?
    public var notes: [NoteStructure] = []
    public var citations: [SourceCitation] = []
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "PHRASE": \AssoiciationStructure.phrase,
        "ROLE": \AssoiciationStructure.role,
        "NOTE": \AssoiciationStructure.notes,
        "SNOTE": \AssoiciationStructure.notes,
        "SOUR": \AssoiciationStructure.citations,
    ]
    
    public init(
        xref: String,
        phrase: String? = nil,
        role: Role? = nil,
        notes: [NoteStructure] = [],
        citations: [SourceCitation] = []
    ) {
        self.xref = xref
        self.phrase = phrase
        self.role = role
        self.notes = notes
        self.citations = citations
    }
    
    required init(record: Record) throws {
        self.xref = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "ASSO", value: xref)
        
        if let phrase {
            record.children += [Record(level: 1, tag: "PHRASE", value: phrase)]
        }
        
        if let role {
            record.children += [role.export()]
            
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
