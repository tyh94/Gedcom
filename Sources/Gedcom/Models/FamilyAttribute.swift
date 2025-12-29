//
//  FamilyAttribute.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 15.12.2025.
//


import Foundation

public class FamilyAttribute : RecordProtocol {
    public var kind: FamilyAttributeKind
    public var text: String?
    public var type: String?
    
    // Family event details
    public var husbandInfo: SpouseAge?
    public var wifeInfo: SpouseAge?
    
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
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "HUSB": \FamilyAttribute.husbandInfo,
        "WIFE": \FamilyAttribute.wifeInfo,
        
        // Event attributes
        "TYPE": \FamilyAttribute.type,
        "DATE": \FamilyAttribute.date,
        "ADDR": \FamilyAttribute.address,
        "PLACE": \FamilyAttribute.place,
        "PHON": \FamilyAttribute.phones,
        "EMAIL": \FamilyAttribute.emails,
        "FAX": \FamilyAttribute.fax,
        "WWW": \FamilyAttribute.www,
        
        "AGNC": \FamilyAttribute.agency,
        "RELI": \FamilyAttribute.religion,
        "CAUS": \FamilyAttribute.cause,
        "RESN": \FamilyAttribute.restrictions,
        "SDATE": \FamilyAttribute.sdate,
        "ASSOC": \FamilyAttribute.associations,
        "NOTE": \FamilyAttribute.notes,
        "SNOTE": \FamilyAttribute.notes,
        "SOUR": \FamilyAttribute.citations,
        "OBJ": \FamilyAttribute.multimediaLinks,
        "UID": \FamilyAttribute.uid,
    ]
    
    public init(
        kind: FamilyAttributeKind,
        text: String? = nil,
        type: String? = nil,
        husband: SpouseAge? = nil,
        wife: SpouseAge? = nil,
        agency: String? = nil,
        religion: String? = nil,
        cause: String? = nil
    ) {
        self.kind = kind
        self.text = text
        self.type = type
        self.husbandInfo = husband
        self.wifeInfo = wife
        self.agency = agency
        self.religion = religion
        self.cause = cause
    }
    
    required init(record: Record) throws {
        guard let kind = FamilyAttributeKind(rawValue: record.line.tag) else
        {
            throw GedcomError.badRecord
        }
        self.kind = kind
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
        
        if let husbandInfo {
            record.children += [husbandInfo.export()]
        }
        if let wifeInfo {
            record.children += [wifeInfo.export()]
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
