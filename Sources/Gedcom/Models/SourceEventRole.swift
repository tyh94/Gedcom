//
//  SourceEventRole.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class SourceEventRole: RecordProtocol {
    public var role: String
    public var phrase: String?
    
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "PHRASE" : \SourceEventRole.phrase,
    ]
    
    public init(role: String, phrase: String? = nil) {
        self.role = role
        self.phrase = phrase
    }
    
    required init(record: Record) throws {
        self.role = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "ROLE", value: role)
        if let phrase {
            record.children += [Record(level: 1, tag: "PHRASE", value: phrase)]
        }
        return record
    }
}
