//
//  MediumKind.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public enum MediumKind: String {
    case audio = "AUDIO" //  An audio recording
    case book = "BOOK"  // A bound book
    case card = "CARD"  // A card or file entry
    case electronic = "ELECTRONIC" // A digital artifact
    case fiche = "FICHE"  // Microfiche
    case film = "FILM" // Microfilm
    case magazine = "MAGAZINE"  // Printed periodical
    case manuscript = "MANUSCRIPT" // Written pages
    case map = "MAP"  // Cartographic map
    case newspaper = "NEWSPAPER"  // Printed newspaper
    case photo = "PHOTO"  // Photograph
    case tombstone = "TOMBSTONE"  // Burial marker or related memorial
    case video = "VIDEO"  // Motion picture recording
    case other = "OTHER"  // A value not listed here; should have a PHRASE substructure
}
