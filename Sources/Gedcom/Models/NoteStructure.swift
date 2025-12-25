//
//  NoteStructure.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public enum NoteStructure {
    case note(Note)
    case sNote(SNoteRef)
}

extension NoteStructure: RecordProtocol {
    init(record: Record) throws {
        switch record.line.tag {
        case "NOTE":
            self = .note(try Gedcom.Note(record: record))
        case "SNOTE":
            self = .sNote(try SNoteRef(record: record))
        default:
            throw GedcomError.badRecord
        }
    }
    
    func export() -> Record {
        switch self {
        case .note(let note):
            return note.export()
        case .sNote(let snote):
            return snote.export()
        }
    }
}
