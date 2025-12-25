//
//  Translation.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class Translation: RecordProtocol {
    public var text: String
    public var mimeType: String?
    public var lang: String?
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "MIME": \Translation.mimeType,
        "LANG": \Translation.lang,
    ]
    
    init(
        text: String,
        mime: String? = nil,
        lang: String? = nil
    ) {
        self.text = text
        self.mimeType = mime
        self.lang = lang
    }
    
    required init(record: Record) throws {
        self.text = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "TRAN", value: text)
        
        if let mimeType {
            let mimeRecord = Record(level: 1, tag: "MIME", value: mimeType)
            record.children.append(mimeRecord)
        }
        if let lang {
            let langRecord = Record(level: 1, tag: "LANG", value: lang)
            record.children.append(langRecord)
        }
        return record
    }
}
