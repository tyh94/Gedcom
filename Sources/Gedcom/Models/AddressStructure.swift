//
//  AddressStructure.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class AddressStructure: RecordProtocol {
    public var address: String
    public var adr1: String?
    public var adr2: String?
    public var adr3: String?
    public var city: String?
    public var state: String?
    public var postalCode: String?
    public var country: String?
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "ADR1": \AddressStructure.adr1,
        "ADR2": \AddressStructure.adr2,
        "ADR3": \AddressStructure.adr3,
        "CITY": \AddressStructure.city,
        "STAE": \AddressStructure.state,
        "POST": \AddressStructure.postalCode,
        "CTRY": \AddressStructure.country,
    ]
    
    public init(addr: String) {
        address = addr
    }
    
    required init(record: Record) throws {
        address = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "ADDR", value: address)
        if let adr1 {
            record.children.append(Record(level: 1, tag: "ADR1", value: adr1))
        }
        if let adr2 {
            record.children.append(Record(level: 1, tag: "ADR2", value: adr2))
        }
        if let adr3 {
            record.children.append(Record(level: 1, tag: "ADR3", value: adr3))
        }
        if let city {
            record.children.append(Record(level: 1, tag: "CITY", value: city))
        }
        if let state {
            record.children.append(Record(level: 1, tag: "STAE", value: state))
        }
        if let postalCode {
            record.children.append(Record(level: 1, tag: "POST", value: postalCode))
        }
        if let country {
            record.children.append(Record(level: 1, tag: "CTRY", value: country))
        }
        
        return record
    }
}

