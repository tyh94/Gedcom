//
//  PlaceTranslation.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class PlaceTranslation: RecordProtocol {
    public var place: [String] = []
    public var lang: String = ""
    
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "LANG" : \PlaceTranslation.lang
    ]
    
    public init(place: [String], lang: String) {
        self.place = place
        self.lang = lang
    }
    
    required init(record: Record) throws {
        self.place = (record.line.value ?? "")
            .components(separatedBy: ",")
            .map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
        
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "TRAN", value: place.joined(separator: ", "))
        record.children += [Record(level: 1, tag: "LANG", value: lang)]
        return record
    }
}
