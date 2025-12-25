//
//  CallNumber.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class CallNumber: RecordProtocol {
    public var callNumber: String
    public var medium: Medium?
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "MEDI": \CallNumber.medium,
    ]
    
    init(callNumber: String, medium: Medium? = nil) {
        self.callNumber = callNumber
        self.medium = medium
    }
    
    required init(record: Record) throws {
        callNumber = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "CALN", value: callNumber)
        if let medium{
            record.children += [medium.export()]
        }
        return record
    }
}
