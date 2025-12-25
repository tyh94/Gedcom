//
//  LdsIndividualOrdinance.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class LdsIndividualOrdinance: RecordProtocol {
    public var kind: LdsIndividualOrdinanceKind
    
    public var date: DateValue?
    public var temple: String?
    public var place: PlaceStructure?
    
    public var status: LdsOrdinanceStatus?
    
    public var notes: [NoteStructure] = []
    public var citations: [SourceCitation] = []
    
    // Only SLGC
    var familyChild: String? // XREF
    
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "DATE" : \LdsIndividualOrdinance.date,
        "TEMP" : \LdsIndividualOrdinance.temple,
        "PLAC" : \LdsIndividualOrdinance.place,
        
        "STAT": \LdsIndividualOrdinance.status,
        
        "NOTE" : \LdsIndividualOrdinance.notes,
        "SNOTE" : \LdsIndividualOrdinance.notes,
        
        "SOUR" : \LdsIndividualOrdinance.citations,
        
        "FAMC" : \LdsIndividualOrdinance.familyChild,
    ]
    
    init(kind: LdsIndividualOrdinanceKind,
         date: DateValue? = nil,
         temple: String? = nil,
         familyChild: String? = nil,
         place: PlaceStructure? = nil,
         status: LdsOrdinanceStatus? = nil,
         notes: [NoteStructure] = [],
         citations: [SourceCitation] = [])
    {
        self.kind = kind
        self.date = date
        self.temple = temple
        self.familyChild = familyChild
        self.place = place
        self.status = status
        self.notes = notes
        self.citations = citations
    }
    
    required init(record: Record) throws {
        self.kind = LdsIndividualOrdinanceKind(rawValue: record.line.tag)!
        
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: kind.rawValue)
        
        if let date {
            record.children += [date.export()]
        }
        if let temple {
            record.children += [Record(level: 1, tag: "TEMP", value: temple)]
        }
        
        if let place {
            record.children += [place.export()]
        }
        
        if let status {
            record.children += [status.export()]
        }
        for note in notes {
            record.children += [note.export()]
        }
        for citation in citations {
            record.children += [citation.export()]
        }
        
        if let familyChild {
            record.children += [Record(level: 1, tag: "FAMC", value: familyChild)]
        }
        
        
        return record
    }
}
