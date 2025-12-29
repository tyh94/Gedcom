//
//  CreationDate.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 15.12.2025.
//

public class CreationDate: RecordProtocol {
    public var date: DateTime = DateTime()
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "DATE": \CreationDate.date,
    ]
    
    public init(date: String, time: String? = nil) {
        self.date = DateTime(date: date, time: time)
    }
    
    required init(record: Record) throws {
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "CREA")
        let exportedDate = date.export()
        record.children.append(exportedDate)
        return record
    }
}
