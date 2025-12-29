//
//  IndividualAttributeStructure.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class IndividualAttributeStructure  : RecordProtocol {
    public var kind: IndividualAttributeKind
    public var text: String?
    public var type: String?
    
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
        // Event attributes
        "TYPE" : \IndividualAttributeStructure.type,
        "DATE" : \IndividualAttributeStructure.date,
        "ADDR" : \IndividualAttributeStructure.address,
        "PLACE" : \IndividualAttributeStructure.place,
        "PHON" : \IndividualAttributeStructure.phones,
        "EMAIL" : \IndividualAttributeStructure.emails,
        "FAX" : \IndividualAttributeStructure.fax,
        "WWW" : \IndividualAttributeStructure.www,
        
        "AGNC" : \IndividualAttributeStructure.agency,
        "RELI" : \IndividualAttributeStructure.religion,
        "CAUS" : \IndividualAttributeStructure.cause,
        "RESN" : \IndividualAttributeStructure.restrictions,
        "SDATE" : \IndividualAttributeStructure.sdate,
        "ASSOC" : \IndividualAttributeStructure.associations,
        "NOTE" : \IndividualAttributeStructure.notes,
        "SNOTE" : \IndividualAttributeStructure.notes,
        "SOUR" : \IndividualAttributeStructure.citations,
        "OBJ" : \IndividualAttributeStructure.multimediaLinks,
        "UID" : \IndividualAttributeStructure.uid,
        // Individual attributes
        "AGE" : \IndividualAttributeStructure.age,
    ]
    
    public init(
        kind: IndividualAttributeKind,
        text: String? = nil,
        type: String? = nil,
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
        uid: [UUID] = []
    ) {
        self.kind = kind
        self.text = text
        self.type = type
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
        self.kind = IndividualAttributeKind(rawValue: record.line.tag)!
        
        if record.line.value != nil {
            text = record.line.value!
        }
        
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: kind.rawValue, value: text)
        
        if let type {
            record.children += [Record(level: 1, tag: "TYPE", value: type)]
        }
        
        if let age {
            record.children += [age.export()]
        }
        
        if let date {
            record.children += [date.export()]
        }
        if let sdate {
            record.children += [sdate.export()]
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
