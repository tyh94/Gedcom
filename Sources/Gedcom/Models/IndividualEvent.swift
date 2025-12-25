//
//  IndividualEvent.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//


import Foundation

public class IndividualEvent: RecordProtocol {
    public var kind: IndividualEventKind
    public var text: String?
    public var occurred: Bool // Text == Y
    public var type: String?
    
    // ADOP specific
    public var familyChild: FamilyChildAdoption?
    
    // Individual event detail
    public var age: Age?
    // Event detail
    public var date: DateValue?
    public var sdate: DateValue?
    public var place: PlaceStructure?
    public var address: AddressStructure?
    public var phones: [String] = []
    public var emails: [String] = []
    public var fax: [String] = []
    public var www: [URL] = []
    public var agency: String?
    public var religion: String?
    public var cause: String?
    public var restrictions: [Restriction] = []
    public var associations: [AssoiciationStructure] = []
    public var notes: [NoteStructure] = []
    public var citations: [SourceCitation] = []
    public var multimediaLinks: [MultimediaLink] = []
    public var uid: [UUID] = []
    
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "TYPE" : \IndividualEvent.type,
        "AGE" : \IndividualEvent.age,
        "ADDR" : \IndividualEvent.address,
        "DATE" : \IndividualEvent.date,
        "PHON" : \IndividualEvent.phones,
        "EMAIL" : \IndividualEvent.emails,
        "FAX" : \IndividualEvent.fax,
        "WWW" : \IndividualEvent.www,
        "SDATE" : \IndividualEvent.sdate,
        "PLAC": \IndividualEvent.place,
        "AGNC": \IndividualEvent.agency,
        "RELI": \IndividualEvent.religion,
        "CAUS": \IndividualEvent.cause,
        "RESN" : \IndividualEvent.restrictions,
        "ASSO" : \IndividualEvent.associations,
        "NOTE" : \IndividualEvent.notes,
        "SNOTE" : \IndividualEvent.notes,
        "SOUR" : \IndividualEvent.citations,
        "OBJE" : \IndividualEvent.multimediaLinks,
        "UID" : \IndividualEvent.uid,
        "FAMC" : \IndividualEvent.familyChild,
    ]
    
    public init(kind: IndividualEventKind,
                text: String? = nil,
                occurred: Bool? = nil, // Text == Y
                type: String? = nil,
                familyChild: FamilyChildAdoption? = nil,
                age: Age? = nil,
                date: DateValue? = nil,
                sdate: DateValue? = nil,
                place: PlaceStructure? = nil,
                address: AddressStructure? = nil,
                phones: [String] = [],
                emails: [String] = [],
                fax: [String] = [],
                www: [URL] = [],
                agency: String? = nil,
                religion: String? = nil,
                cause: String? = nil,
                restrictions: [Restriction] = [],
                associations: [AssoiciationStructure] = [],
                notes: [NoteStructure] = [],
                citations: [SourceCitation] = [],
                multimediaLinks: [MultimediaLink] = [],
                uid: [UUID] = []) {
        
        self.kind = kind
        self.text = text
        self.occurred = occurred ?? false
        self.type = type
        self.familyChild = familyChild
        self.age = age
        self.date = date
        self.sdate = sdate
        self.place = place
        self.address = address
        self.phones = phones
        self.emails = emails
        self.fax = fax
        self.www = www
        self.agency = agency
        self.religion = religion
        self.cause = cause
        self.restrictions = restrictions
        self.associations = associations
        self.notes = notes
        self.citations = citations
        self.multimediaLinks = multimediaLinks
        self.uid = uid
        
    }
    required init(record: Record) throws {
        self.kind = IndividualEventKind(rawValue: record.line.tag) ?? .even
        if record.line.value == "Y" {
            occurred = true
        } else {
            occurred = false
        }
        
        if kind == .even {
            text = record.line.value ?? ""
        }
        
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: kind.rawValue)
        if kind == .even {
            record.line.value = text
        } else if occurred {
            record.line.value = "Y"
        }
        
        if let type {
            record.children += [Record(level: 1, tag: "TYPE", value: type)]
        }
        
        if let familyChild {
            record.children += [familyChild.export()]
            
        }
        
        if let date {
            record.children += [date.export()]
        }
        
        if let age {
            record.children += [age.export()]
        }
        
        if let place {
            record.children += [place.export()]
        }
        if let address {
            record.children += [address.export()]
        }
        for phone in phones {
            record.children += [Record(level: 1, tag: "PHON", value: phone)]
        }
        for email in emails {
            record.children += [Record(level: 1, tag: "EMAIL", value: email)]
        }
        for fax in fax {
            record.children += [Record(level: 1, tag: "FAX", value: fax)]
        }
        for www in www {
            record.children += [Record(level: 1, tag: "WWW", value: www.absoluteString)]
        }
        if let agency {
            record.children += [Record(level: 1, tag: "AGNC", value: agency)]
        }
        if let religion {
            record.children += [Record(level: 1, tag: "RELI", value: religion)]
        }
        if let cause {
            record.children += [Record(level: 1, tag: "CAUS", value: cause)]
        }
        
        if restrictions.count > 0 {
            record.children += [Record(level: 1, tag: "RESN", value: restrictions.map({$0.rawValue}).joined(separator: ", "))]
        }
        
        if let sdate {
            let sdate = sdate.export()
            sdate.line.tag = "SDATE" // Override default export tag
            record.children += [sdate]
        }
        
        for association in associations {
            record.children += [association.export()]
        }
        
        for note in notes {
            record.children += [note.export()]
        }
        
        for citation in citations {
            record.children += [citation.export()]
        }
        
        for link in multimediaLinks {
            record.children += [link.export()]
        }
        
        for uuid in uid {
            record.children += [Record(level: 1, tag: "UID", value: uuid.uuidString.lowercased())]
        }
        
        return record
    }
}
