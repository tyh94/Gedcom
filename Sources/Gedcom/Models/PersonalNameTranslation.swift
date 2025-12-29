//
//  PersonalNameTranslation.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public class PersonalNameTranslation: RecordProtocol {
    public var name: String
    public var lang: String = ""
    public var namePieces : [PersonalNamePiece] = []
    
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "LANG" : \PersonalNameTranslation.lang,
        "NPFX" : \PersonalNameTranslation.namePieces,
        "GIVN" : \PersonalNameTranslation.namePieces,
        "NICK" : \PersonalNameTranslation.namePieces,
        "SPFX" : \PersonalNameTranslation.namePieces,
        "SURN" : \PersonalNameTranslation.namePieces,
        "NSFX" : \PersonalNameTranslation.namePieces,
    ]
    
    public init(name: String, lang: String, namePieces: [PersonalNamePiece] = []) {
        self.name = name
        self.lang = lang
        self.namePieces = namePieces
    }
    
    required init(record: Record) throws {
        self.name = record.line.value ?? ""
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "TRAN", value: name)
        record.children += [Record(level: 1, tag: "LANG", value: lang)]
        
        for namePiece in namePieces {
            record.children += [namePiece.export()]
        }
        
        return record
    }
}
