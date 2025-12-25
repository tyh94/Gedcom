//
//  Individual.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class Individual: RecordProtocol {
    public var xref: String
    
    public var restrictions: [Restriction] = []
    public var names: [PersonalName] = []
    public var sex: Sex?
    
    public var attributes: [IndividualAttributeStructure] = []
    public var events: [IndividualEvent] = []
    public var nonEvents: [NonEventStructure] = []
    public var ldsDetails: [LdsIndividualOrdinance] = []
    
    public var childOfFamilies: [FamilyChild] = []
    public var spouseFamilies: [FamilySpouse] = []
    
    public var submitters: [String] = []
    public var associations: [AssoiciationStructure] = []
    public var aliases: [PhraseRef] = []
    public var ancestorInterest: [String] = []
    public var decendantInterest: [String] = []
    
    public var identifiers: [IdentifierStructure] = []
    public var notes: [NoteStructure] = []
    public var citations: [SourceCitation] = []
    public var multimediaLinks: [MultimediaLink] = []
    public var changeDate: ChangeDate?
    public var creationDate: CreationDate?
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "RESN": \Individual.restrictions,
        "NAME": \Individual.names,
        "SEX": \Individual.sex,
        
        "CAST": \Individual.attributes,
        "DSCR": \Individual.attributes,
        "EDUC": \Individual.attributes,
        "IDNO": \Individual.attributes,
        "NATI": \Individual.attributes,
        "NCHI": \Individual.attributes,
        "NMR": \Individual.attributes,
        "OCCU": \Individual.attributes,
        "PROP": \Individual.attributes,
        "RELI": \Individual.attributes,
        "RESI": \Individual.attributes,
        "SSN": \Individual.attributes,
        "TITL": \Individual.attributes,
        "FACT": \Individual.attributes,
        
        "ADOP": \Individual.events,
        "BAPM": \Individual.events,
        "BARM": \Individual.events,
        "BASM": \Individual.events,
        "BIRT": \Individual.events,
        "BLES": \Individual.events,
        "BURI": \Individual.events,
        "CENS": \Individual.events,
        "CHR": \Individual.events,
        "CHRA": \Individual.events,
        "CONF": \Individual.events,
        "CREM": \Individual.events,
        "DEAT": \Individual.events,
        "EMIG": \Individual.events,
        "FCOM": \Individual.events,
        "GRAD": \Individual.events,
        "IMMI": \Individual.events,
        "NATU": \Individual.events,
        "ORDN": \Individual.events,
        "PROB": \Individual.events,
        "RETI": \Individual.events,
        "WILL": \Individual.events,
        "EVEN": \Individual.events,
        
        "NO": \Individual.nonEvents,
        
        "BAPL": \Individual.ldsDetails,
        "CONL": \Individual.ldsDetails,
        "ENDL": \Individual.ldsDetails,
        "INIL": \Individual.ldsDetails,
        "SLGC": \Individual.ldsDetails,
        
        "FAMC": \Individual.childOfFamilies,
        "FAMS": \Individual.spouseFamilies,
        
        "SUBM": \Individual.submitters,
        "ASSO": \Individual.associations,
        
        "ALIA": \Individual.aliases,
        "ANCI": \Individual.ancestorInterest,
        "DESI": \Individual.decendantInterest,
        
        "REFN": \Individual.identifiers,
        "UID": \Individual.identifiers,
        "EXID": \Individual.identifiers,
        
        "NOTE": \Individual.notes,
        "SNOTE": \Individual.notes,
        
        "SOUR": \Individual.citations,
        "OBJE": \Individual.multimediaLinks,
        
        "CHAN": \Individual.changeDate,
        "CREA": \Individual.creationDate
        
    ]
    
    public init(xref: String) {
        self.xref = xref
    }
    required init(record: Record) throws {
        self.xref = record.line.xref ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    
    func export() -> Record {
        let record = Record(level: 0, xref: xref, tag: "INDI")
        
        
        if restrictions.count > 0 {
            record.children += [Record(level: 1, tag: "RESN",
                                       value: restrictions.map({$0.rawValue}).joined(separator: ", "))]
            
        }
        
        for name in names {
            record.children += [name.export()]
        }
        
        if let sex {
            record.children += [Record(level: 0, tag: "SEX", value: sex.rawValue)]
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
        
        for ldsDetail in ldsDetails {
            record.children += [ldsDetail.export()]
        }
        
        for childOfFamily in childOfFamilies {
            record.children += [childOfFamily.export()]
        }
        
        for spouseOfFamily in spouseFamilies {
            record.children += [spouseOfFamily.export()]
        }
        
        for submitter in submitters {
            record.children += [Record(level: 0, tag: "SUBM", value: submitter)]
        }
        
        for association in associations {
            record.children += [association.export()]
        }
        
        for alias in aliases {
            record.children += [alias.export()]
        }
        
        for ancestorInterest in ancestorInterest {
            record.children += [Record(level: 0, tag: "ANCI", value: ancestorInterest)]
        }
        
        for decendantInterest in decendantInterest {
            record.children += [Record(level: 0, tag: "DESI", value: decendantInterest)]
        }
        
        for identifier in identifiers {
            record.children += [identifier.export()]
        }
        
        for note in notes {
            record.children += [note.export()]
        }
        
        for multimediaLink in multimediaLinks {
            record.children += [multimediaLink.export()]
        }
        
        for citation in citations {
            record.children += [citation.export()]
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
