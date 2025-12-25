//
//  SourceCitationData.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class SourceCitationData: RecordProtocol {
    public var date: DateValue?
    public var text: [SourceText] = []
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "DATE": \SourceCitationData.date,
        "TEXT": \SourceCitationData.text,
    ]
    
    init(date: DateValue? = nil) {
        self.date = date
    }
    
    required init(record: Record) throws {
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "DATA")
        if let date {
            record.children += [date.export()]
        }
        for text in self.text {
            record.children += [text.export()]
        }
        return record
    }
}
