//
//  Family.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class Family: RecordProtocol {
    public var xref: String
    public var restrictions: [Restriction] = []
    
    public var attributes: [FamilyAttribute] = []
    public var events: [FamilyEvent] = []
    public var nonEvents: [NonFamilyEventStructure] = []
    
    public var ldsSpouseSealings: [LdsSpouseSealing] = []
    
    public var husband: PhraseRef?
    public var wife: PhraseRef?
    public var children: [PhraseRef] = []
    
    public var associations: [AssoiciationStructure] = []
    public var submitters: [String] = []
    public var identifiers: [IdentifierStructure] = []
    public var notes: [NoteStructure] = []
    public var citations: [SourceCitation] = []
    public var multimediaLinks: [MultimediaLink] = []
    public var changeDate: ChangeDate?
    public var creationDate: CreationDate?
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "RESN": \Family.restrictions,
        
        "NCHI": \Family.attributes,
        "RESI": \Family.attributes,
        "FACT": \Family.attributes,
        
        "ANUL": \Family.events,
        "CENS": \Family.events,
        "DIV": \Family.events,
        "DIVF": \Family.events,
        "ENGA": \Family.events,
        "MARB": \Family.events,
        "MARC": \Family.events,
        "MARL": \Family.events,
        "MARR": \Family.events,
        "MARS": \Family.events,
        "EVEN": \Family.events,
        
        "NO": \Family.nonEvents,
        
        "SLGS": \Family.ldsSpouseSealings,
        
        "HUSB": \Family.husband,
        "WIFE": \Family.wife,
        "CHIL": \Family.children,
        
        "ASSO": \Family.associations,
        "SUBM": \Family.submitters,
        
        "REFN": \Family.identifiers,
        "UID": \Family.identifiers,
        "EXID": \Family.identifiers,
        
        "NOTE": \Family.notes,
        "SNOTE": \Family.notes,
        
        "SOUR": \Family.citations,
        "OBJE": \Family.multimediaLinks,
        
        "CHAN": \Family.changeDate,
        "CREA": \Family.creationDate
    ]
    
    
    public init(xref: String) {
        self.xref = xref
    }
    
    required init(record: Record) throws {
        self.xref = record.line.xref ?? ""
        
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, xref: xref, tag: "FAM")
        
        if restrictions.count > 0 {
            record.children += [Record(level: 1, tag: "RESN",
                                       value: restrictions.map({$0.rawValue}).joined(separator: ", "))]
            
        }
        
        for attribute in attributes {
            record.children += [attribute.export()]
        }
        for event in events {
            record.children += [event.export()]
        }
        for nonEvent in nonEvents {
            record.children += [nonEvent.export()]
        }
        
        if let husband {
            record.children += [husband.export()]
        }
        
        if let wife {
            record.children += [wife.export()]
        }
        
        for child in children {
            record.children += [child.export()]
        }
        
        for association in associations {
            record.children += [association.export()]
        }
        
        for submitter in submitters {
            record.children += [Record(level: 1, tag: "SUBM", value: submitter)]
        }
        
        for ldsSpouseSealing in ldsSpouseSealings {
            record.children += [ldsSpouseSealing.export()]
        }
        
        for identifier in identifiers {
            record.children += [identifier.export()]
        }
        
        for note in notes {
            record.children += [note.export()]
        }
        for citation in citations {
            record.children += [citation.export()]
        }
        for multimediaLink in multimediaLinks {
            record.children += [multimediaLink.export()]
        }
        
        if let changeDate {
            record.children += [changeDate.export()]
        }
        if let creationDate {
            record.children += [creationDate.export()]
        }
        
        record.setLevel(0)
        return record
    }
}
