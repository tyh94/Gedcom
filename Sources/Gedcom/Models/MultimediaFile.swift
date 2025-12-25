//
//  MultimediaFile.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class MultimediaFile: RecordProtocol {
    public var path: String
    
    public var form: MultimediaFileForm = MultimediaFileForm(form: "")
    public var title: String?
    public var translations: [FileTranslation] = []
    
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "FORM" : \MultimediaFile.form,
        "TITL" : \MultimediaFile.title,
        "TRAN" : \MultimediaFile.translations,
    ]
    
    public init(
        path: String,
        form: MultimediaFileForm,
        title: String? = nil
    ) {
        self.path = path
        self.form = form
        self.title = title
    }
    
    required init(record: Record) throws {
        self.path = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "FILE", value: path)
        
        record.children += [form.export()]
        
        if let title {
            record.children += [Record(level: 1, tag: "TITL", value: title)]
        }
        
        for translation in translations {
            record.children += [translation.export()]
        }
        
        return record
    }
}
