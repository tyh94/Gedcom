//
//  Header.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class Header: RecordProtocol {
    public var gedc: Gedc
    public var schema: Schema?
    public var source: HeaderSource?
    public var date: DateTimeExact?
    public var destination: String?
    
    public var place: HeaderPlace?
    public var copyright: String?
    public var lang: String?
    public var submitter: String?
    public var note: NoteStructure?
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "GEDC": \Header.gedc,
        "SCHMA": \Header.schema,
        "SOUR": \Header.source,
        
        "DEST": \Header.destination,
        "DATE": \Header.date,
        
        "SUBM": \Header.submitter,
        "COPR": \Header.copyright,
        "LANG": \Header.lang,
        "PLAC": \Header.place,
        "NOTE": \Header.note,
        "SOTE": \Header.note,
    ]
    
    init() {
        gedc = Gedc()
    }
    
    public init(
        gedc: Gedc,
        schema: Schema? = nil,
        source: HeaderSource? = nil,
        date: DateTimeExact? = nil,
        destination: String? = nil,
        place: HeaderPlace? = nil,
        copyright: String? = nil,
        lang: String? = nil,
        submitter: String? = nil,
        note: NoteStructure? = nil
    ) {
        self.gedc = gedc
        self.schema = schema
        self.source = source
        self.date = date
        self.destination = destination
        self.place = place
        self.copyright = copyright
        self.lang = lang
        self.submitter = submitter
        self.note = note
    }
    
    required init(record: Record) throws {
        gedc = Gedc()
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "HEAD")
        
        record.children.append(gedc.export())
        
        if let schema {
            let child = schema.export()
            record.children.append(child)
        }
        
        if let source {
            let child = source.export()
            record.children.append(child)
        }
        
        if let destination {
            record.children.append(Record(level: 1, tag: "DEST", value: destination))
        }
        
        if let date {
            let child = date.export()
            record.children.append(child)
        }
        
        if let submitter {
            record.children.append(Record(level: 1, tag: "SUBM", value: submitter))
        }
        if let copyright {
            record.children.append(Record(level: 1, tag: "COPR", value: copyright))
        }
        if let lang {
            record.children.append(Record(level: 1, tag: "LANG", value: lang))
        }
        
        if let place {
            let child = place.export()
            record.children.append(child)
        }
        
        if let note {
            let note = note.export()
            record.children.append(note)
        }
        
        record.setLevel(0)
        return record
    }
}

