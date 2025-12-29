//
//  HeaderPlace.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 16.12.2025.
//

import Foundation

public class HeaderPlace: RecordProtocol {
    public var form: CommaSeparatedStrings = []
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "FORM": \HeaderPlace.form,
    ]
    
    public init(form: CommaSeparatedStrings) {
        self.form = form
    }
    
    required init(record: Record) throws {
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "PLAC")
        record.children.append(
            Record(level: 1, tag: "FORM", value: form.stringValue)
        )
        return record
    }
}
