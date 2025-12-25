//
//  GedcomFile.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class GedcomFile: RecordProtocol {
    public private(set) var header: Header = Header()
    public private(set) var familyRecords: [Family] = []
    public private(set) var individualRecords: [Individual] = []
    public private(set) var multimediaRecords: [Multimedia] = []
    public private(set) var repositoryRecords: [Repository] = []
    public private(set) var sharedNoteRecords: [SharedNote] = []
    public private(set) var sourceRecords: [Source] = []
    public private(set) var submitterRecords: [Submitter] = []
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "HEAD": \GedcomFile.header,
        "INDI": \GedcomFile.individualRecords,
        "FAM": \GedcomFile.familyRecords,
        "OBJE": \GedcomFile.multimediaRecords,
        "REPO": \GedcomFile.repositoryRecords,
        "SNOTE": \GedcomFile.sharedNoteRecords,
        "SOUR": \GedcomFile.sourceRecords,
        "SUBM": \GedcomFile.submitterRecords,
    ]
    
    public init() {}
    
    required init(record: Record) throws {
        try updateFromRecord(record, keys: Self.keys)
    }
    
    public func add(individual: Individual) {
        individualRecords += [individual]
    }
    
    public func add(family: Family) {
        familyRecords += [family]
    }
    
    public func add(media: Multimedia) {
        multimediaRecords += [media]
    }
    
    public func add(repo: Repository) {
        repositoryRecords += [repo]
    }
    
    public func add(note: SharedNote) {
        sharedNoteRecords += [note]
    }
    
    public func add(source: Source) {
        sourceRecords += [source]
    }
    
    public func add(submitter: Submitter) {
        submitterRecords += [submitter]
    }
    
    func export() -> Record {
        var records: [Record] = []
        
        records += [header.export()]
        
        for fam in familyRecords {
            records += [fam.export()]
        }
        
        for ind in individualRecords {
            records += [ind.export()]
        }
        
        for multi in multimediaRecords {
            records += [multi.export()]
        }
        
        for repo in repositoryRecords {
            records += [repo.export()]
        }
        
        for note in sharedNoteRecords {
            records += [note.export()]
        }
        
        for source in sourceRecords {
            records += [source.export()]
        }
        
        for submitter in submitterRecords {
            records += [submitter.export()]
        }
        
        records += [Record(level: 0, tag: "TRLR")]
        
        let record = Record(level: 0, tag: "")
        record.children = records
        return record
    }
}
