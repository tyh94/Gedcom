import Foundation

public class LdsSpouseSealing: RecordProtocol {
    public var date: DateValue?
    public var temple: String?
    public var place: PlaceStructure?
    
    public var status: LdsOrdinanceStatus?
    
    public var notes: [NoteStructure] = []
    public var citations: [SourceCitation] = []
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "DATE": \LdsSpouseSealing.date,
        "TEMP": \LdsSpouseSealing.temple,
        "PLAC": \LdsSpouseSealing.place,
        
        "STAT": \LdsSpouseSealing.status,
        
        "NOTE": \LdsSpouseSealing.notes,
        "SNOTE": \LdsSpouseSealing.notes,
        
        "SOUR": \LdsSpouseSealing.citations,
    ]
    
    public init(
        date: DateValue? = nil,
         temple: String? = nil,
         place: PlaceStructure? = nil,
         status: LdsOrdinanceStatus? = nil,
         notes: [NoteStructure] = [],
         citations: [SourceCitation] = []
    ) {
        self.date = date
        self.temple = temple
        self.place = place
        self.status = status
        self.notes = notes
        self.citations = citations
    }
    
    required init(record: Record) throws {
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "SLGS")
        
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
        
        return record
    }
}
