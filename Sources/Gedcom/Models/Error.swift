//
//  Error.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public enum GedcomError: Error {
    case missingManifest
    case unknownVersion
    case badLine(Int)
    case badLevel(Int)
    case badArchive
    case badRecord
    case badRestriction
    case badNamePiece
    case badURL
    case badSchema
    case missingXref
    case unknownKeyPath(String)
    case invalidCoordinate(String)
}
