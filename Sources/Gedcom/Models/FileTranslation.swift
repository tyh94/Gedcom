//
//  FileTranslation.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class FileTranslation: RecordProtocol {
    public var path: String = ""
    public var form: String = ""
    
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "FORM": \FileTranslation.form,
    ]
    
    init(path: String, form: String)
    {
        self.path = path
        self.form = form
    }
    
    required init(record: Record) throws {
        self.path = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "TRAN", value: path)
        record.children += [Record(level: 1, tag: "FORM", value: form)]
        return record
    }
}
