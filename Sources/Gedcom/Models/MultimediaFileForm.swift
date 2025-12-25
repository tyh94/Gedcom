//
//  MultimediaFileForm.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class MultimediaFileForm: RecordProtocol {
    public var form: String = ""
    public var medium: Medium?
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "MEDI" : \MultimediaFileForm.medium,
    ]
    
    public init(
        form: String,
        medium: Medium? = nil
    ) {
        self.form = form
        self.medium = medium
    }
    
    required init(record: Record) throws {
        self.form = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "FORM", value: form)
        
        if let medium {
            record.children += [medium.export()]
        }
        
        return record
    }
}
