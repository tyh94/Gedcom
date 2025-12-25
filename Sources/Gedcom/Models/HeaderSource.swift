//
//  HeaderSource.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 16.12.2025.
//

import Foundation

public class HeaderSource: RecordProtocol {
    public var source: String = ""
    public var version: String?
    public var name: String?
    public var corporation: HeaderSourceCorporation?
    public var data: HeaderSourceData?
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "VERS": \HeaderSource.version,
        "NAME": \HeaderSource.name,
        "CORP": \HeaderSource.corporation,
        "DATA": \HeaderSource.data,
    ]
    
    init(source: String) {
        self.source = source
    }
    
    required init(record: Record) throws {
        source = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "SOUR", value: source)
        
        if let version = version {
            record.children.append(Record(level: 1, tag: "VERS", value: version))
        }
        if let name = name {
            record.children.append(Record(level: 1, tag: "NAME", value: name))
        }
        
        if let corporation = corporation {
            let child = corporation.export()
            record.children.append(child)
        }
        if let data = data {
            let child = data.export()
            record.children.append(child)
        }
        return record
    }
}
