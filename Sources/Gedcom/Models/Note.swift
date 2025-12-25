//
//  Note.swift
//  FamilyBook
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class Note: RecordProtocol {
    public var text: String = ""
    public var mimeType: String?
    public var lang: String?
    public var translations: [Translation] = []
    public var citations: [SourceCitation] = []
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "MIME": \Note.mimeType,
        "LANG": \Note.lang,
        "TRAN": \Note.translations,
        "SOUR": \Note.citations,
    ]
    
    public init(text: String, mime: String? = nil, lang: String? = nil)
    {
        self.text = text
        self.mimeType = mime
        self.lang = lang
    }
    
    required init(record: Record) throws {
        self.text = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "NOTE", value: text)
        
        if let mimeType {
            let mimeRecord = Record(level: 1, tag: "MIME", value: mimeType)
            record.children.append(mimeRecord)
        }
        if let lang {
            let langRecord = Record(level: 1, tag: "LANG", value: lang)
            record.children.append(langRecord)
        }
        
        for translation in translations {
            let translationRecord = translation.export()
            translationRecord.line.level += 1
            record.children.append(translationRecord)
        }
        
        for citation in citations {
            let citationRecord = citation.export()
            citationRecord.line.level += 1
            record.children.append(citationRecord)
        }
        
        return record
    }
}



