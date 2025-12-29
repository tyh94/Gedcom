//
//  SourceEventData.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class SourceEventData: RecordProtocol {
    public var event: String
    public var phrase: String?
    public var role: SourceEventRole?
    
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "PHRASE" : \SourceEventData.phrase,
        "ROLE" : \SourceEventData.role,
    ]
    
    public init(event: String, phrase: String? = nil, role: SourceEventRole? = nil) {
        self.event = event
        self.phrase = phrase
        self.role = role
    }
    required init(record: Record) throws {
        self.event = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "EVEN", value: event)
        
        if let phrase {
            record.children += [Record(level: 1, tag: "PHRASE", value: phrase)]
        }
        if let role {
            record.children += [role.export()]
        }
        
        return record
    }
}
