//
//  Multimedia.swift
//  FamilyBook
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class Multimedia: RecordProtocol {
    public var xref: String
    public var restrictions: [Restriction] = []
    
    public var files: [MultimediaFile] = []
    
    public var citations: [SourceCitation] = []
    public var notes: [NoteStructure] = []
    public var identifiers: [IdentifierStructure] = []
    public var changeDate: ChangeDate?
    public var creationDate: CreationDate?
    
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "RESN" : \Multimedia.restrictions,
        "FILE" : \Multimedia.files,
        "SOUR" : \Multimedia.citations,
        "NOTE" : \Multimedia.notes,
        "SNOTE" : \Multimedia.notes,
        "REFN" : \Multimedia.identifiers,
        "UID" : \Multimedia.identifiers,
        "EXID" : \Multimedia.identifiers,
        "CHAN" : \Multimedia.changeDate,
        "CREA" : \Multimedia.creationDate
    ]
    
    public init(xref: String) {
        self.xref = xref
    }
    
    required init(record: Record) throws {
        self.xref = record.line.xref!
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, xref: xref, tag: "OBJE")
        
        if restrictions.count > 0 {
            record.children += [Record(level: 1, tag: "RESN",
                                       value: restrictions.map({$0.rawValue}).joined(separator: ", "))]
        }
        
        for file in files {
            record.children += [file.export()]
        }
        
        for identifer in identifiers {
            record.children += [identifer.export()]
        }
        
        for note in notes {
            record.children += [note.export()]
        }
        
        for citation in citations {
            record.children += [citation.export()]
        }
        
        if let changeDate {
            record.children += [changeDate.export()]
        }
        if let creationDate {
            record.children += [creationDate.export()]
        }
        
        record.setLevel(0)
        return record
    }
}
