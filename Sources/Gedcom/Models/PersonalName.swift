//
//  PersonalName.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class PersonalName: RecordProtocol {
    public var name: String
    public var parsedName: GedcomPersonalName?
    
    public var type: NameType?
    public var namePieces: [PersonalNamePiece] = []
    public var translations: [PersonalNameTranslation] = []
    public var notes: [NoteStructure] = []
    public var citations: [SourceCitation] = []
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "TYPE": \PersonalName.type,
        "NPFX": \PersonalName.namePieces,
        "GIVN": \PersonalName.namePieces,
        "NICK": \PersonalName.namePieces,
        "SPFX": \PersonalName.namePieces,
        "SURN": \PersonalName.namePieces,
        "NSFX": \PersonalName.namePieces,
        "TRAN": \PersonalName.translations,
        "NOTE": \PersonalName.notes,
        "SNOTE": \PersonalName.notes,
        "SOUR": \PersonalName.citations,
    ]
    
    public init(
        name: String,
        type: NameType? = nil,
        namePieces : [PersonalNamePiece] = [],
        translations : [PersonalNameTranslation] = [],
        notes: [NoteStructure] = [],
        citations: [SourceCitation] = []
    ) {
        self.name = name
        self.parsedName = GedcomPersonalNameParser.parse(name)
        self.type = type
        self.namePieces = namePieces
        self.translations = translations
        self.notes = notes
        self.citations = citations
    }
    
    required init(record: Record) throws {
        self.name = record.line.value ?? ""
        self.parsedName = GedcomPersonalNameParser.parse(self.name)
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "NAME", value: name)
        
        if let type {
            record.children += [type.export()]
        }
        
        for namePiece in namePieces {
            record.children += [namePiece.export()]
        }
        
        for translation in translations {
            record.children += [translation.export()]
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
