//
//  SourceText.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class SourceText: RecordProtocol {
    public var text: String
    public var mimeType: String?
    public var lang: String?
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "MIME": \SourceText.mimeType,
        "LANG": \SourceText.lang,
    ]
    
    init(text: String, mime: String? = nil, lang: String? = nil) {
        self.text = text
        self.mimeType = mime
        self.lang = lang
    }
    required init(record: Record) throws {
        text = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "TEXT", value: text)
        
        if let mimeType {
            record.children += [Record(level: 0, tag: "MIME", value: mimeType)]
        }
        if let lang {
            record.children += [Record(level: 0, tag: "LANG", value: lang)]
        }
        
        return record
    }
}
