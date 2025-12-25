//
//  Repository.swift
//  FamilyBook
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class Repository: RecordProtocol {
    public var xref: String
    public var name: String = ""
    public var address: AddressStructure?
    public var phoneNumbers: [String] = []
    public var emails: [String] = []
    public var faxNumbers: [String] = []
    public var www: [URL] = []
    public var notes: [NoteStructure] = []
    public var identifiers: [IdentifierStructure] = []
    public var changeDate: ChangeDate?
    public var creationDate: CreationDate?
    
    
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "NAME" : \Repository.name,
        "ADDR" : \Repository.address,
        "PHON" : \Repository.phoneNumbers,
        "EMAIL" : \Repository.emails,
        "FAX" : \Repository.faxNumbers,
        "WWW" : \Repository.www,
        "NOTE" : \Repository.notes,
        "SNOTE" : \Repository.notes,
        "REFN" : \Repository.identifiers,
        "UID" : \Repository.identifiers,
        "EXID" : \Repository.identifiers,
        "CHAN" : \Repository.changeDate,
        "CREA" : \Repository.creationDate
    ]
    
    init(xref: String, name: String) {
        self.xref = xref
        self.name = name
    }
    required init(record: Record) throws {
        self.xref = record.line.xref!
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, xref: xref, tag: "REPO")
        record.children += [Record(level: 1, tag: "NAME", value: name)]
        
        if let address {
            record.children += [address.export()]
        }
        for phoneNumber in phoneNumbers {
            record.children += [Record(level: 1, tag: "PHON", value: phoneNumber)]
        }
        
        for email in emails {
            record.children += [Record(level: 1, tag: "EMAIL", value: email)]
        }
        
        for faxNumber in faxNumbers {
            record.children += [Record(level: 1, tag: "FAX", value: faxNumber)]
        }
        for url in www {
            record.children += [Record(level: 1, tag: "WWW", value: url.absoluteString)]
        }
        
        for note in notes {
            record.children += [note.export()]
        }
        
        for identifier in identifiers {
            record.children += [identifier.export()]
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

