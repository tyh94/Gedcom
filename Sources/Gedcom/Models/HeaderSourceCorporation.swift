//
//  HeaderSourceCorporation.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 16.12.2025.
//

import Foundation

public class HeaderSourceCorporation: RecordProtocol {
    public var corporation: String = ""
    public var address: AddressStructure?
    public var phone: [String] = []
    public var email: [String] = []
    public var fax: [String] = []
    public var www: [URL] = []
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "ADDR": \HeaderSourceCorporation.address,
        "PHON": \HeaderSourceCorporation.phone,
        "EMAIL": \HeaderSourceCorporation.email,
        "FAX": \HeaderSourceCorporation.fax,
        "WWW": \HeaderSourceCorporation.www,
    ]
    
    public init(
        corporation: String = "",
        address: AddressStructure? = nil,
        phone: [String] = [],
        email: [String] = [],
        fax: [String] = [],
        www: [URL] = []
    ) {
        self.corporation = corporation
        self.address = address
        self.phone = phone
        self.email = email
        self.fax = fax
        self.www = www
    }
    
    required init(record: Record) throws {
        corporation = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "CORP", value: corporation)
        
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
        return record
    }
}
