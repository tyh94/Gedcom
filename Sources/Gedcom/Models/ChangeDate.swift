//
//  ChangeDate.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 15.12.2025.
//

public class ChangeDate: RecordProtocol {
    public var date: DateTime = DateTime()
    public var notes: [NoteStructure] = []
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "DATE": \ChangeDate.date,
        "NOTE": \ChangeDate.notes,
        "SNOTE": \ChangeDate.notes,
    ]
    
    init(date: String, time: String? = nil, notes: [NoteStructure] = []) {
        self.date = DateTime(date: date, time: time)
        self.notes = notes
    }
    
    required init(record: Record) throws {
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "CHAN")
        let exportedDate = date.export()
        record.children.append(exportedDate)
        for note in notes {
            let exportedNote = note.export()
            record.children.append(exportedNote)
        }
        return record
    }
}
