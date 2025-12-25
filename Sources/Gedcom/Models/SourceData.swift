//
//  SourceData.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class SourceData: RecordProtocol {
    public var events: [SourceDataEvents] = []
    public var agency: String?
    public var notes: [NoteStructure] = []
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "EVEN": \SourceData.events,
        "AGNC": \SourceData.agency,
        "NOTE": \SourceData.notes,
        "SNOTE": \SourceData.notes
    ]
    
    init() {
        
    }
    required init(record: Record) throws {
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "DATA")
        
        for event in events {
            record.children += [event.export()]
        }
        
        if let agency {
            record.children += [Record(level: 0, tag: "AGNC", value: agency)]
        }
        
        for note in notes {
            record.children += [note.export()]
        }
        
        return record
    }
}
