//
//  LdsOrdinanceStatus.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class LdsOrdinanceStatus: RecordProtocol {
    public var kind: LdsOrdinanceStatusKind
    public var date: DateTime
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "DATE": \LdsOrdinanceStatus.date,
    ]
    
    init(kind: LdsOrdinanceStatusKind, date: DateTime) {
        self.kind = kind
        self.date = date
    }
    required init(record: Record) throws {
        self.date = DateTime()
        self.kind = LdsOrdinanceStatusKind(rawValue: record.line.value ?? "")!
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "STAT", value: kind.rawValue)
        record.children += [date.export()]
        return record
    }
}
