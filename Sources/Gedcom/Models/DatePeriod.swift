//
//  DatePeriod.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 15.12.2025.
//

public class DatePeriod: RecordProtocol {
    public var date: String = ""
    public var time: String?
    public var phrase: String?
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "TIME": \DatePeriod.time,
        "PHRASE": \DatePeriod.phrase,
    ]
    
    init(
        date: String,
        time: String? = nil,
        phrase: String? = nil
    ) {
        self.date = date
        self.time = time
        self.phrase = phrase
    }
    
    required init(record: Record) throws {
        date = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "DATE", value: date)
        if let time {
            let timeRecord = Record(level: 1, tag: "TIME", value: time)
            record.children.append(timeRecord)
        }
        if let phrase {
            let phraseRecord = Record(level: 1, tag: "PHRASE", value: phrase)
            record.children.append(phraseRecord)
        }
        return record
    }
}
