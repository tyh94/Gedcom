//
//  RecordProtocol.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

protocol RecordProtocol {
    init(record: Record) throws
    func export() -> Record
}

import Foundation

extension RecordProtocol where Self: AnyObject {
    // Для классов используем ReferenceWritableKeyPath
    func updateFromRecord(_ record: Record, keys: [String: AnyKeyPath]) throws {
        for child in record.children {
            guard let kp = keys[child.line.tag] else {
                continue
            }
            
            try processChildRecord(child, keyPath: kp)
        }
    }
    
    private func processChildRecord(_ child: Record, keyPath: AnyKeyPath) throws {
        switch keyPath {
        case let wkp as ReferenceWritableKeyPath<Self, String>:
            self[keyPath: wkp] = child.line.value ?? ""
            
        case let wkp as ReferenceWritableKeyPath<Self, String?>:
            self[keyPath: wkp] = child.line.value ?? ""
            
        case let wkp as ReferenceWritableKeyPath<Self, [String]>:
            self[keyPath: wkp].append(child.line.value ?? "")
            
        case let wkp as ReferenceWritableKeyPath<Self, CommaSeparatedStrings>:
            if let value = child.line.value {
                self[keyPath: wkp] = CommaSeparatedStrings(value)
            }
            
        case let wkp as ReferenceWritableKeyPath<Self, [UUID]>:
            guard let value = child.line.value,
                  let uuid = UUID(uuidString: value) else {
                throw GedcomError.unknownKeyPath("Expected non-empty string value for \(child.line.tag)")
            }
            self[keyPath: wkp].append(uuid)
            
        case let wkp as ReferenceWritableKeyPath<Self, Int?>:
            guard let value = child.line.value else {
                throw GedcomError.unknownKeyPath("Expected integer value for \(child.line.tag)")
            }
            self[keyPath: wkp] = Int(value)
            
        case let wkp as ReferenceWritableKeyPath<Self, AddressStructure?>:
            self[keyPath: wkp] = try AddressStructure(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, [IdentifierStructure]>:
            self[keyPath: wkp].append(try IdentifierStructure(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [AssoiciationStructure]>:
            self[keyPath: wkp].append(try AssoiciationStructure(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [NoteStructure]>:
            self[keyPath: wkp].append(try NoteStructure(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [MultimediaLink]>:
            self[keyPath: wkp].append(try MultimediaLink(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [MultimediaFile]>:
            self[keyPath: wkp].append(try MultimediaFile(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [FileTranslation]>:
            self[keyPath: wkp].append(try FileTranslation(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [Translation]>:
            self[keyPath: wkp].append(try Translation(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [SourceCitation]>:
            self[keyPath: wkp].append(try SourceCitation(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [CallNumber]>:
            self[keyPath: wkp].append(try CallNumber(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [FamilyAttribute]>:
            self[keyPath: wkp].append(try FamilyAttribute(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [FamilyEvent]>:
            self[keyPath: wkp].append(try FamilyEvent(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [NonFamilyEventStructure]>:
            self[keyPath: wkp].append(try NonFamilyEventStructure(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [LdsSpouseSealing]>:
            self[keyPath: wkp].append(try LdsSpouseSealing(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [PhraseRef]>:
            self[keyPath: wkp].append(try PhraseRef(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [PersonalName]>:
            self[keyPath: wkp].append(try PersonalName(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [PersonalNameTranslation]>:
            self[keyPath: wkp].append(try PersonalNameTranslation(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [IndividualAttributeStructure]>:
            self[keyPath: wkp].append(try IndividualAttributeStructure(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [IndividualEvent]>:
            self[keyPath: wkp].append(try IndividualEvent(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [NonEventStructure]>:
            self[keyPath: wkp].append(try NonEventStructure(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [LdsIndividualOrdinance]>:
            self[keyPath: wkp].append(try LdsIndividualOrdinance(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [SourceText]>:
            self[keyPath: wkp].append(try SourceText(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [SourceDataEvents]>:
            self[keyPath: wkp].append(try SourceDataEvents(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [SourceEventData]>:
            self[keyPath: wkp].append(try SourceEventData(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [FamilyChild]>:
            self[keyPath: wkp].append(try FamilyChild(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [FamilySpouse]>:
            self[keyPath: wkp].append(try FamilySpouse(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [SourceRepositoryCitation]>:
            self[keyPath: wkp].append(try SourceRepositoryCitation(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [PlaceTranslation]>:
            self[keyPath: wkp].append(try PlaceTranslation(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [EXID]>:
            self[keyPath: wkp].append(try EXID(record: child))
            
        case let wkp as ReferenceWritableKeyPath<Self, [Restriction]>:
            let strings: [String] = (child.line.value?.components(separatedBy: ",").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})) ?? []
            self[keyPath: wkp] = try strings.map {
                guard let restriction = Restriction(rawValue: $0) else {
                    throw GedcomError.unknownKeyPath("Unknown restriction: \($0)")
                }
                return restriction
            }
            
        case let wkp as ReferenceWritableKeyPath<Self, [URL]>:
            guard let urlString = child.line.value,
                  let url = URL(string: urlString) else {
                throw GedcomError.badURL
            }
            self[keyPath: wkp].append(url)
            
        case let wkp as ReferenceWritableKeyPath<Self, ChangeDate?>:
            self[keyPath: wkp] = try ChangeDate(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, CreationDate?>:
            self[keyPath: wkp] = try CreationDate(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, CreationDate?>:
            self[keyPath: wkp] = try CreationDate(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, DateTime>:
            self[keyPath: wkp] = try DateTime(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, DateValue?>:
            self[keyPath: wkp] = try DateValue(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, DatePeriod?>:
            self[keyPath: wkp] = try DatePeriod(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, DateTimeExact?>:
            self[keyPath: wkp] = try DateTimeExact(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, Role?>:
            self[keyPath: wkp] = try Role(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, Medium?>:
            self[keyPath: wkp] = try Medium(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, PlaceStructure?>:
            self[keyPath: wkp] = try PlaceStructure(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, LdsOrdinanceStatus?>:
            self[keyPath: wkp] = try LdsOrdinanceStatus(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, Age>:
            self[keyPath: wkp] = try Age(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, Age?>:
            self[keyPath: wkp] = try Age(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, SpouseAge>:
            self[keyPath: wkp] = try SpouseAge(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, SpouseAge?>:
            self[keyPath: wkp] = try SpouseAge(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, FamilyChildAdoption>:
            self[keyPath: wkp] = try FamilyChildAdoption(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, FamilyChildAdoption?>:
            self[keyPath: wkp] = try FamilyChildAdoption(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, PhraseRef?>:
            self[keyPath: wkp] = try PhraseRef(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, HeaderSource?>:
            self[keyPath: wkp] = try HeaderSource(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, HeaderPlace?>:
            self[keyPath: wkp] = try HeaderPlace(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, HeaderSourceData?>:
            self[keyPath: wkp] = try HeaderSourceData(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, HeaderSourceCorporation?>:
            self[keyPath: wkp] = try HeaderSourceCorporation(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, MultimediaFileForm>:
            self[keyPath: wkp] = try MultimediaFileForm(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, Crop?>:
            self[keyPath: wkp] = try Crop(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, NameType?>:
            self[keyPath: wkp] = try NameType(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, SourceDataEventPeriod?>:
            self[keyPath: wkp] = try SourceDataEventPeriod(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, SourceEventRole?>:
            self[keyPath: wkp] = try SourceEventRole(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, Gedc>:
            self[keyPath: wkp] = try Gedc(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, Schema?>:
            self[keyPath: wkp] = try Schema(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, NoteStructure?>:
            self[keyPath: wkp] = try NoteStructure(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, Pedigree?>:
            self[keyPath: wkp] = try Pedigree(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, ChildStatus?>:
            self[keyPath: wkp] = try ChildStatus(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, FamilyChildAdoptionKind?>:
            self[keyPath: wkp] = try FamilyChildAdoptionKind(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, SourceCitationData?>:
            self[keyPath: wkp] = try SourceCitationData(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, SourceData?>:
            self[keyPath: wkp] = try SourceData(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, SourceText?>:
            self[keyPath: wkp] = try SourceText(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, PlaceCoordinates?>:
            self[keyPath: wkp] = try PlaceCoordinates(record: child)
            
        case let wkp as ReferenceWritableKeyPath<Self, Latitude>:
            if let value = child.line.value {
                self[keyPath: wkp] = try Latitude(value)
            }
            
        case let wkp as ReferenceWritableKeyPath<Self, Longitude>:
            if let value = child.line.value {
                self[keyPath: wkp] = try Longitude(value)
            }

        case let wkp as ReferenceWritableKeyPath<Self, [PersonalNamePiece]>:
            let value = child.line.value ?? ""
            switch (child.line.tag) {
            case "NPFX":
                self[keyPath: wkp].append(.namePrefix(value))
            case "GIVN":
                self[keyPath: wkp].append(.givenName(value))
            case "NICK":
                self[keyPath: wkp].append(.nickname(value))
            case "SPFX":
                self[keyPath: wkp].append(.surnamePrefix(value))
            case "SURN":
                self[keyPath: wkp].append(.surname(value))
            case "NSFX":
                self[keyPath: wkp].append(.nameSuffix(value))
            default:
                throw GedcomError.badNamePiece
            }
            
        case let wkp as ReferenceWritableKeyPath<Self, Sex?>:
            self[keyPath: wkp] = Sex(rawValue: child.line.value ?? "") ?? .unknown
            
            // MARK: Gedcomfile
        case let wkp as ReferenceWritableKeyPath<Self, Header>:
            self[keyPath: wkp] = try Header(record: child)
        case let wkp as ReferenceWritableKeyPath<Self, [Family]>:
            self[keyPath: wkp].append(try Family(record: child))
        case let wkp as ReferenceWritableKeyPath<Self, [Individual]>:
            self[keyPath: wkp].append(try Individual(record: child))
        case let wkp as ReferenceWritableKeyPath<Self, [Multimedia]>:
            self[keyPath: wkp].append(try Multimedia(record: child))
        case let wkp as ReferenceWritableKeyPath<Self, [Repository]>:
            self[keyPath: wkp].append(try Repository(record: child))
        case let wkp as ReferenceWritableKeyPath<Self, [SharedNote]>:
            self[keyPath: wkp].append(try SharedNote(record: child))
        case let wkp as ReferenceWritableKeyPath<Self, [Source]>:
            self[keyPath: wkp].append(try Source(record: child))
        case let wkp as ReferenceWritableKeyPath<Self, [Submitter]>:
            self[keyPath: wkp].append(try Submitter(record: child))
            assert(child.line.xref != nil)
            
        default:
            throw GedcomError.unknownKeyPath(String(describing: keyPath))
        }
    }
}
