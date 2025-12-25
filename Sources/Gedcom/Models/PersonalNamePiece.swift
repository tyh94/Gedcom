//
//  PersonalNamePiece.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public enum PersonalNamePiece: Equatable {
    case namePrefix(String)
    case givenName(String)
    case nickname(String)
    case surnamePrefix(String)
    case surname(String)
    case nameSuffix(String)
}

extension PersonalNamePiece {
    func export() -> Record {
        switch self {
        case .namePrefix(let s):
            return Record(level: 0, tag: "NPFX", value: s)
        case .givenName(let s):
            return Record(level: 0, tag: "GIVN", value: s)
        case .nickname(let s):
            return Record(level: 0, tag: "NICK", value: s)
        case .surnamePrefix(let s):
            return Record(level: 0, tag: "SPFX", value: s)
        case .surname(let s):
            return Record(level: 0, tag: "SURN", value: s)
        case .nameSuffix(let s):
            return Record(level: 0, tag: "NSFX", value: s)
        }
    }
}
