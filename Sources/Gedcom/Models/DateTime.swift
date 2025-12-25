//
//  DateTime.swift
//  FamilyBook
//
//  Created by Татьяна Макеева on 15.12.2025.
//

public class DateTime: RecordProtocol {
    public var date: String = ""
    public var time: String?
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "TIME": \DateTime.time,
    ]
    
    init() { }
    
    init(date: String, time: String? = nil)
    {
        self.date = date
        self.time = time
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
        return record
    }
}
