//
//  SourceRepositoryCitation.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class SourceRepositoryCitation: RecordProtocol {
    public var xref: String
    public var notes: [NoteStructure] = []
    public var callNumbers: [CallNumber] = []
    
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "NOTE" : \SourceRepositoryCitation.notes,
        "SNOTE" : \SourceRepositoryCitation.notes,
        "CALN" : \SourceRepositoryCitation.callNumbers
    ]
    
    public init(
        xref: String,
        notes: [NoteStructure] = [],
        callNumbers: [CallNumber] = []
    ) {
        self.xref = xref
        self.notes = notes
        self.callNumbers = callNumbers
    }
    
    required init(record: Record) throws {
        xref = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "REPO", value: xref)
        
        for note in notes {
            record.children += [note.export()]
        }
        for callNumber in callNumbers {
            record.children += [callNumber.export()]
        }
        
        return record
    }
}
