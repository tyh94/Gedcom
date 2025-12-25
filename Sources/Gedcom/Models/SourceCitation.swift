//
//  SourceCitation.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class SourceCitation: RecordProtocol {
    public var xref: String
    public var page: String?
    public var data: SourceCitationData?
    public var events: [SourceEventData] = []
    public var quality: Int?
    public var multimediaLinks: [MultimediaLink] = []
    public var notes: [NoteStructure] = []
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "PAGE": \SourceCitation.page,
        
        "DATA": \SourceCitation.data,
        "EVEN": \SourceCitation.events,
        
        "QUAY": \SourceCitation.quality,
        "OBJE": \SourceCitation.multimediaLinks,
        
        "NOTE": \SourceCitation.notes,
        "SNOTE": \SourceCitation.notes,
    ]
    
    init(
        xref: String,
        page: String? = nil,
        data: SourceCitationData? = nil,
        events: [SourceEventData] = [],
        quality: Int? = nil,
        links: [MultimediaLink] = [],
        notes: [NoteStructure] = []
    ) {
        self.xref = xref
        self.page = page
        self.data = data
        self.events = events
        self.quality = quality
        self.multimediaLinks = links
        self.notes = notes
    }
    
    required init(record: Record) throws {
        xref = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "SOUR", value: xref)
        if let page {
            record.children.append(Record(level: 1, tag: "PAGE", value: page))
        }
        if let data {
            record.children.append(data.export())
        }
        for event in events {
            record.children.append(event.export())
        }
        if let quality {
            record.children.append(Record(level: 1, tag: "QUAY", value: "\(quality)"))
        }
        for link in multimediaLinks {
            record.children.append(link.export())
        }
        for note in notes {
            record.children.append(note.export())
        }
        
        return record
    }
}
