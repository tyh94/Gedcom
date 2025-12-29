//
//  PlaceStructure.swift
//  FamilyBook
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class PlaceStructure: RecordProtocol {
    public var place: CommaSeparatedStrings = []
    public var form: CommaSeparatedStrings = []
    public var lang: String?
    public var translations: [PlaceTranslation] = []
    public var map: PlaceCoordinates?
    public var exids: [EXID] = []
    public var notes: [NoteStructure] = []
    
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "FORM": \PlaceStructure.form,
        "LANG": \PlaceStructure.lang,
        "TRAN": \PlaceStructure.translations,
        "MAP": \PlaceStructure.map,
        "EXID": \PlaceStructure.exids,
        "NOTE": \PlaceStructure.notes,
        "SNOTE": \PlaceStructure.notes,
        
    ]
    
    public init(
        place: CommaSeparatedStrings,
        form: CommaSeparatedStrings = [],
        lang: String? = nil
    ) {
        self.place = place
        self.form = form
        self.lang = lang
    }
    
    required init(record: Record) throws {
        self.place = (record.line.value ?? "").map { CommaSeparatedStrings($0) }!
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "PLAC", value: place.stringValue)
        
        if form.values.count > 0 {
            record.children += [Record(level: 1, tag: "FORM", value: form.stringValue)]
        }
        
        if let lang {
            record.children += [Record(level: 1, tag: "LANG", value: lang)]
        }
        
        for translation in translations {
            record.children += [translation.export()]
        }
        
        if let map {
            record.children += [map.export()]
        }
        
        for exid in exids {
            record.children += [exid.export()]
        }
        for note in notes {
            record.children += [note.export()]
        }
        
        return record
    }
}
