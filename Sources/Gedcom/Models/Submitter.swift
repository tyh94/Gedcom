//
//  Submitter.swift
//  FamilyBook
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class Submitter: RecordProtocol {
    public var xref: String = ""
    public var name: String = ""
    public var address: AddressStructure?
    public var phone: [String] = []
    public var email: [String] = []
    public var fax: [String] = []
    public var www: [URL] = []
    public var multimediaLinks: [MultimediaLink] = []
    public var languages: [String] = []
    public var identifiers: [IdentifierStructure] = []
    public var notes: [NoteStructure] = []
    public var changeDate: ChangeDate?
    public var creationDate: CreationDate?
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "NAME": \Submitter.name,
        "ADDR": \Submitter.address,
        "PHON": \Submitter.phone,
        "EMAIL": \Submitter.email,
        "FAX": \Submitter.fax,
        "WWW": \Submitter.www,
        "OBJE": \Submitter.multimediaLinks,
        "LANG": \Submitter.languages,
        "REFN": \Submitter.identifiers,
        "UID": \Submitter.identifiers,
        "EXID": \Submitter.identifiers,
        "NOTE": \Submitter.notes,
        "SNOTE": \Submitter.notes,
        "CHAN": \Submitter.changeDate,
        "CREA": \Submitter.creationDate
    ]
    
    init(xref: String, name: String)
    {
        self.xref = xref
        self.name = name
    }
    
    required init(record: Record) throws {
        guard let xref = record.line.xref else {
            throw GedcomError.missingXref
        }
        
        self.xref = xref
        self.name = ""
        
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, xref: xref, tag: "SUBM")
        
        record.children.append(Record(level: 1, tag: "NAME", value: name))
        
        if let address = address {
            let child = address.export()
            record.children.append(child)
        }
        for phone in phone {
            record.children.append(Record(level: 1, tag: "PHON", value: phone))
        }
        for email in email {
            record.children.append(Record(level: 1, tag: "EMAIL", value: email))
        }
        for fax in fax {
            record.children.append(Record(level: 1, tag: "FAX", value: fax))
        }
        for www in www {
            record.children.append(Record(level: 1, tag: "WWW", value: www.absoluteString))
        }
        
        for multimediaLink in multimediaLinks {
            let child = multimediaLink.export()
            record.children.append(child)
        }
        
        for lang in languages {
            record.children.append(Record(level: 1, tag: "LANG", value: lang))
        }
        
        for identifier in identifiers {
            let child = identifier.export()
            record.children.append(child)
        }
        for note in notes {
            let child = note.export()
            record.children.append(child)
        }
        
        if let changeDate {
            let child = changeDate.export()
            record.children.append(child)
        }
        if let creationDate {
            let child = creationDate.export()
            record.children.append(child)
        }
        
        record.setLevel(0)
        return record
    }
}
