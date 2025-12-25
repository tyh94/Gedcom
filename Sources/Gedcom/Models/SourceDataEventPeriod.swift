//
//  SourceDataEventPeriod.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class SourceDataEventPeriod: RecordProtocol {
    public var date: String
    public var phrase: String?
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "PHRASE": \SourceDataEventPeriod.phrase,
    ]
    
    init(date: String, phrase: String? = nil) {
        self.date = date
        self.phrase = phrase
    }
    required init(record: Record) throws {
        self.date = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "DATE", value: date)
        
        if let phrase {
            record.children += [Record(level: 1, tag: "PHRASE", value: phrase)]
        }
        return record
    }
}
