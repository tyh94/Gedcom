//
//  HeaderSourceData.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 16.12.2025.
//

import Foundation

public class HeaderSourceData: RecordProtocol {
    public var data: String = ""
    public var date: DateTimeExact?
    public var copyright: String?
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "DATE": \HeaderSourceData.date,
        "COPR": \HeaderSourceData.copyright,
    ]
    
    init(data: String) {
        self.data = data
    }
    
    required init(record: Record) throws {
        data = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "DATA", value: data)
        
        if let date = date {
            let exportedDate = date.export()
            record.children.append(exportedDate)
        }
        
        if let copyright {
            let copyrightRecord = Record(level: 1, tag: "COPR", value: copyright)
            record.children.append(copyrightRecord)
        }
        return record
    }
}
