//
//  LoadingTests.swift
//  Gedcom
//
//  Created by Mattias Holm on 2024-11-28.
//

import Testing
import Foundation
@testable import Gedcom
import ZIPFoundation

@Suite("Load Gedcom Archive") struct LoadingArchiveTests {
    let parser = GedcomParser()
    
    @Test func testLoadMinArchive() async throws {
        let module = Bundle.module
        guard
            let resourceURL = module.url(forResource: "Gedcom7/minimal70",
                                         withExtension: "gdz") else {
            Issue.record("Resource 'Gedcom7/minimal70.gzd' not found in bundle")
            return
        }
        
        let ged = try parser.parse(withArchive: resourceURL)
        #expect(ged.familyRecords.count == 0)
        #expect(ged.individualRecords.count == 0)
        #expect(ged.multimediaRecords.count == 0)
        #expect(ged.repositoryRecords.count == 0)
        #expect(ged.sharedNoteRecords.count == 0)
        #expect(ged.sourceRecords.count == 0)
        #expect(ged.submitterRecords.count == 0)
    }
}

@Suite("Load Max Archive") struct MaxArchiveLoaderTests {
    let module = Bundle.module
    let resourceURL = Bundle.module.url(forResource: "Gedcom7/maximal70",
                                        withExtension: "gdz")!
    let parser = GedcomParser()
    let ged: GedcomFile
    let submitterRecordsMap: [String: Submitter]
    let familyRecordsMap: [String: Family]
    let individualRecordsMap: [String: Individual]
    let multimediaRecordsMap: [String: Multimedia]
    let repositoryRecordsMap: [String: Repository]
    let sharedNoteRecordsMap: [String: SharedNote]
    let sourceRecordsMap: [String: Source]
    init() throws {
        ged = try parser.parse(withArchive: resourceURL)
        submitterRecordsMap = ged.submitterRecords.reduce(into: [:]) { $0[$1.xref] = $1 }
        familyRecordsMap = ged.familyRecords.reduce(into: [:]) { $0[$1.xref] = $1 }
        individualRecordsMap = ged.individualRecords.reduce(into: [:]) { $0[$1.xref] = $1 }
        multimediaRecordsMap = ged.multimediaRecords.reduce(into: [:]) { $0[$1.xref] = $1 }
        repositoryRecordsMap = ged.repositoryRecords.reduce(into: [:]) { $0[$1.xref] = $1 }
        sharedNoteRecordsMap = ged.sharedNoteRecords.reduce(into: [:]) { $0[$1.xref] = $1 }
        sourceRecordsMap = ged.sourceRecords.reduce(into: [:]) { $0[$1.xref] = $1 }
    }
    
    @Test func fileStructure() async throws {
        #expect(ged.familyRecords.count == 2)
        #expect(ged.individualRecords.count == 4)
        #expect(ged.multimediaRecords.count == 2)
        #expect(ged.repositoryRecords.count == 2)
        #expect(ged.sharedNoteRecords.count == 2)
        #expect(ged.sourceRecords.count == 2)
        #expect(ged.submitterRecords.count == 2)
    }
    
    @Test func header() async throws {
        #expect(ged.header.gedc.vers == "7.0")
        #expect(ged.header.source != nil)
        #expect(ged.header.source?.source == "https://gedcom.io/")
        #expect(ged.header.source?.name == "GEDCOM Steering Committee")
        #expect(ged.header.source?.corporation?.corporation == "FamilySearch")
        #expect(ged.header.source?.corporation?.address?.address == "Family History Department\n15 East South Temple Street\nSalt Lake City, UT 84150 USA")
        #expect(ged.header.source?.corporation?.address?.adr1 == "Family History Department")
        #expect(ged.header.source?.corporation?.address?.adr2 == "15 East South Temple Street")
        #expect(ged.header.source?.corporation?.address?.adr3 == "Salt Lake City, UT 84150 USA")
        #expect(ged.header.source?.corporation?.address?.city == "Salt Lake City")
        #expect(ged.header.source?.corporation?.address?.state == "UT")
        #expect(ged.header.source?.corporation?.address?.postalCode == "84150")
        #expect(ged.header.source?.corporation?.address?.country == "USA")
        #expect(ged.header.source?.corporation?.phone == ["+1 (555) 555-1212", "+1 (555) 555-1234"])
        #expect(ged.header.source?.corporation?.email == ["GEDCOM@FamilySearch.org", "GEDCOM@example.com"])
        #expect(ged.header.source?.corporation?.fax == ["+1 (555) 555-1212", "+1 (555) 555-1234"])
        #expect(ged.header.source?.corporation?.www == [URL(string: "http://gedcom.io")!, URL(string: "http://gedcom.info")!])
        #expect(ged.header.source?.data?.data == "HEAD-SOUR-DATA")
        #expect(ged.header.source?.data?.date?.date == "1 NOV 2022")
        #expect(ged.header.source?.data?.date?.time == "8:38")
        #expect(ged.header.source?.data?.copyright == "copyright statement")
        #expect(ged.header.destination == "https://gedcom.io/")
        #expect(ged.header.date?.date == "10 JUN 2022")
        #expect(ged.header.date?.time == "15:43:20.48Z")
        #expect(ged.header.submitter == "@U1@")
        #expect(ged.header.copyright == "another copyright statement")
        #expect(ged.header.lang == "en-US")
        #expect(ged.header.place?.form == ["City", "County", "State", "Country"])
        
        switch ged.header.note {
        case .note(let n):
            #expect(n.text == "American English")
            #expect(n.mimeType == "text/plain")
            #expect(n.lang == "en-US")
            #expect(n.translations[0].text == "British English")
            #expect(n.translations[0].lang == "en-GB")
            #expect(n.citations[0].xref == "@S1@")
            #expect(n.citations[0].page == "1")
            #expect(n.citations[1].xref == "@S1@")
            #expect(n.citations[1].page == "2")
        default:
            Issue.record("bad header note")
        }
        
        #expect(ged.header.schema?.tags["_SKYPEID"] == URL(string: "http://xmlns.com/foaf/0.1/skypeID")!)
        #expect(ged.header.schema?.tags["_JABBERID"] == URL(string: "http://xmlns.com/foaf/0.1/jabberID")!)
    }
    
    @Test func submitterRecords() async throws {
        #expect(submitterRecordsMap["@U1@"]!.name == "GEDCOM Steering Committee")
        
        #expect(submitterRecordsMap["@U1@"]!.address?.address == "Family History Department\n15 East South Temple Street\nSalt Lake City, UT 84150 USA")
        #expect(submitterRecordsMap["@U1@"]!.address?.adr1 == "Family History Department")
        #expect(submitterRecordsMap["@U1@"]!.address?.adr2 == "15 East South Temple Street")
        #expect(submitterRecordsMap["@U1@"]!.address?.adr3 == "Salt Lake City, UT 84150 USA")
        #expect(submitterRecordsMap["@U1@"]!.address?.city == "Salt Lake City")
        #expect(submitterRecordsMap["@U1@"]!.address?.state == "UT")
        #expect(submitterRecordsMap["@U1@"]!.address?.postalCode == "84150")
        #expect(submitterRecordsMap["@U1@"]!.address?.country == "USA")
        #expect(submitterRecordsMap["@U1@"]!.phone == ["+1 (555) 555-1212", "+1 (555) 555-1234"])
        #expect(submitterRecordsMap["@U1@"]!.email == ["GEDCOM@FamilySearch.org", "GEDCOM@example.com"])
        #expect(submitterRecordsMap["@U1@"]!.fax == ["+1 (555) 555-1212", "+1 (555) 555-1234"])
        #expect(submitterRecordsMap["@U1@"]!.www == [URL(string: "http://gedcom.io")!, URL(string: "http://gedcom.info")!])
        
        #expect(submitterRecordsMap["@U1@"]!.multimediaLinks.count == 2)
        #expect(submitterRecordsMap["@U1@"]!.multimediaLinks[0].xref == "@O1@")
        #expect(submitterRecordsMap["@U1@"]!.multimediaLinks[0].crop!.top == 0)
        #expect(submitterRecordsMap["@U1@"]!.multimediaLinks[0].crop!.left == 0)
        #expect(submitterRecordsMap["@U1@"]!.multimediaLinks[0].crop!.width == 100)
        #expect(submitterRecordsMap["@U1@"]!.multimediaLinks[0].crop!.height == 100)
        #expect(submitterRecordsMap["@U1@"]!.multimediaLinks[0].title == "Title")
        
        #expect(submitterRecordsMap["@U1@"]!.multimediaLinks[1].xref == "@O1@")
        #expect(submitterRecordsMap["@U1@"]!.multimediaLinks[1].crop!.top == 100)
        #expect(submitterRecordsMap["@U1@"]!.multimediaLinks[1].crop!.left == 100)
        #expect(submitterRecordsMap["@U1@"]!.multimediaLinks[1].crop!.width == nil)
        #expect(submitterRecordsMap["@U1@"]!.multimediaLinks[1].crop!.height == nil)
        #expect(submitterRecordsMap["@U1@"]!.multimediaLinks[1].title == "Title")
        #expect(submitterRecordsMap["@U1@"]!.languages == ["en-US", "en-GB"])
        #expect(submitterRecordsMap["@U1@"]!.identifiers.count == 6)
        switch (submitterRecordsMap["@U1@"]!.identifiers[0]) {
        case .Refn(let refn):
            #expect(refn.refn == "1")
            #expect(refn.type == "User-generated identifier")
        default:
            Issue.record("unexpected identifier type")
        }
        switch (submitterRecordsMap["@U1@"]!.identifiers[1]) {
        case .Refn(let refn):
            #expect(refn.refn == "10")
            #expect(refn.type == "User-generated identifier")
        default:
            Issue.record("unexpected identifier type")
        }
        switch (submitterRecordsMap["@U1@"]!.identifiers[2]) {
        case .Uuid(let uid):
            #expect(uid.uid == UUID(uuidString: "24132fe0-26f6-4f87-9924-389a4f40f0ec"))
        default:
            Issue.record("unexpected identifier type")
        }
        switch (submitterRecordsMap["@U1@"]!.identifiers[3]) {
        case .Uuid(let uid):
            #expect(uid.uid == UUID(uuidString: "b451c8df-5550-473b-a55c-ed31e65c60c8"))
        default:
            Issue.record("unexpected identifier type")
        }
        switch (submitterRecordsMap["@U1@"]!.identifiers[4]) {
        case .Exid(let exid):
            #expect(exid.exid == "123")
            #expect(exid.type == "http://example.com")
        default:
            Issue.record("unexpected identifier type")
        }
        switch (submitterRecordsMap["@U1@"]!.identifiers[5]) {
        case .Exid(let exid):
            #expect(exid.exid == "456")
            #expect(exid.type == "http://example.com")
        default:
            Issue.record("unexpected identifier type")
        }
        
        #expect(submitterRecordsMap["@U1@"]!.notes.count == 2)
        switch (submitterRecordsMap["@U1@"]!.notes[0]) {
        case .note(let note):
            #expect(note.text == "American English")
            #expect(note.mimeType == "text/plain")
            #expect(note.lang == "en-US")
            #expect(note.translations.count == 1)
            #expect(note.translations[0].text == "British English")
            #expect(note.translations[0].lang == "en-GB")
            #expect(note.citations.count == 2)
            #expect(note.citations[0].xref == "@S1@")
            #expect(note.citations[0].page == "1")
            #expect(note.citations[1].xref == "@S2@")
            #expect(note.citations[1].page == "2")
        default:
            Issue.record("unexpected note type")
        }
        switch (submitterRecordsMap["@U1@"]!.notes[1]) {
        case .sNote(let note):
            #expect(note.xref == "@N1@")
        default:
            Issue.record("unexpected snote type")
        }
        #expect(submitterRecordsMap["@U1@"]!.changeDate != nil)
        #expect(submitterRecordsMap["@U1@"]!.changeDate!.date.date == "27 MAR 2022")
        #expect(submitterRecordsMap["@U1@"]!.changeDate!.date.time == "08:56")
        #expect(submitterRecordsMap["@U1@"]!.changeDate!.notes.count == 2)
        #expect(submitterRecordsMap["@U1@"]!.creationDate != nil)
        #expect(submitterRecordsMap["@U1@"]!.creationDate!.date.date == "27 MAR 2022")
        #expect(submitterRecordsMap["@U1@"]!.creationDate!.date.time == "08:55")
        
        #expect(submitterRecordsMap["@U2@"]!.name == "Submitter 2")
        
        // 0: Note
        // 1: SNote N1
        #expect(submitterRecordsMap["@U1@"]!.notes.count == 2)
    }
    
    @Test func sharedNotes() async throws {
        // Shared notes loading
        #expect(sharedNoteRecordsMap["@N1@"]!.xref == "@N1@")
        #expect(sharedNoteRecordsMap["@N1@"]!.text == "Shared note 1")
        #expect(sharedNoteRecordsMap["@N1@"]!.mimeType == "text/plain")
        #expect(sharedNoteRecordsMap["@N1@"]!.lang == "en-US")
        #expect(sharedNoteRecordsMap["@N1@"]!.translations.count == 2)
        #expect(sharedNoteRecordsMap["@N1@"]!.translations[0].text == "Shared note 1")
        #expect(sharedNoteRecordsMap["@N1@"]!.translations[0].mimeType == "text/plain")
        #expect(sharedNoteRecordsMap["@N1@"]!.translations[0].lang == "en-GB")
        #expect(sharedNoteRecordsMap["@N1@"]!.translations[1].text == "Shared note 1")
        #expect(sharedNoteRecordsMap["@N1@"]!.translations[1].mimeType == "text/plain")
        #expect(sharedNoteRecordsMap["@N1@"]!.translations[1].lang == "en-CA")
        
        #expect(sharedNoteRecordsMap["@N1@"]!.citations.count == 2)
        #expect(sharedNoteRecordsMap["@N1@"]!.citations[0].xref == "@S1@")
        #expect(sharedNoteRecordsMap["@N1@"]!.citations[0].page == "1")
        #expect(sharedNoteRecordsMap["@N1@"]!.citations[1].xref == "@S2@")
        #expect(sharedNoteRecordsMap["@N1@"]!.citations[1].page == "2")
        
        #expect(sharedNoteRecordsMap["@N1@"]!.identifiers.count == 6)
        switch (sharedNoteRecordsMap["@N1@"]!.identifiers[0]) {
        case .Refn(let refn):
            #expect(refn.refn == "1")
            #expect(refn.type == "User-generated identifier")
        default:
            Issue.record("unexpected identifier type")
        }
        switch (sharedNoteRecordsMap["@N1@"]!.identifiers[1]) {
        case .Refn(let refn):
            #expect(refn.refn == "10")
            #expect(refn.type == "User-generated identifier")
        default:
            Issue.record("unexpected identifier type")
        }
        switch (sharedNoteRecordsMap["@N1@"]!.identifiers[2]) {
        case .Uuid(let uid):
            #expect(uid.uid == UUID(uuidString: "6efbee0b-96a1-43ea-83c8-828ec71c54d7"))
        default:
            Issue.record("unexpected identifier type")
        }
        switch (sharedNoteRecordsMap["@N1@"]!.identifiers[3]) {
        case .Uuid(let uid):
            #expect(uid.uid == UUID(uuidString: "4094d92a-5525-44ec-973d-6c527aa5535a"))
        default:
            Issue.record("unexpected identifier type")
        }
        switch (sharedNoteRecordsMap["@N1@"]!.identifiers[4]) {
        case .Exid(let exid):
            #expect(exid.exid == "123")
            #expect(exid.type == "http://example.com")
        default:
            Issue.record("unexpected identifier type")
        }
        switch (sharedNoteRecordsMap["@N1@"]!.identifiers[5]) {
        case .Exid(let exid):
            #expect(exid.exid == "456")
            #expect(exid.type == "http://example.com")
        default:
            Issue.record("unexpected identifier type")
        }
        
        #expect(sharedNoteRecordsMap["@N1@"]!.changeDate?.date.date == "27 MAR 2022")
        #expect(sharedNoteRecordsMap["@N1@"]!.changeDate?.date.time == "08:56")
        #expect(sharedNoteRecordsMap["@N1@"]!.changeDate?.notes.count == 2)
        switch (sharedNoteRecordsMap["@N1@"]!.changeDate?.notes[0]) {
        case .note(let note):
            #expect(note.text == "Change date note 1")
        default:
            Issue.record("unexpected note type")
        }
        switch (sharedNoteRecordsMap["@N1@"]!.changeDate?.notes[1]) {
        case .note(let note):
            #expect(note.text == "Change date note 2")
        default:
            Issue.record("unexpected note type")
        }
        #expect(sharedNoteRecordsMap["@N1@"]!.creationDate?.date.date == "27 MAR 2022")
        #expect(sharedNoteRecordsMap["@N1@"]!.creationDate?.date.time == "08:55")
        #expect(sharedNoteRecordsMap["@N2@"]!.text == "Shared note 2")
        
        
    }
    
    @Test func sources() async throws {
        
        // Sources
        #expect(sourceRecordsMap["@S1@"]!.data!.events.count == 2)
        #expect(sourceRecordsMap["@S1@"]!.data!.events[0].eventTypes
                == ["BIRT", "DEAT"])
        #expect(sourceRecordsMap["@S1@"]!.data!.events[0].period!.date
                == "FROM 1701 TO 1800")
        #expect(sourceRecordsMap["@S1@"]!.data!.events[0].period!.phrase
                == "18th century")
        
        #expect(sourceRecordsMap["@S1@"]!.data!.events[0].place?.place
                == ["Some City", "Some County", "Some State", "Some Country"])
        #expect(sourceRecordsMap["@S1@"]!.data!.events[0].place?.form
                == ["City", "County", "State", "Country"])
        #expect(sourceRecordsMap["@S1@"]!.data!.events[0].place?.lang == "en-US")
        #expect(sourceRecordsMap["@S1@"]!.data!.events[0].place?.translations.count == 2)
        #expect(sourceRecordsMap["@S1@"]!.data!.events[0].place?.translations.count == 2)
        #expect(sourceRecordsMap["@S1@"]!.data!.events[0].place?.translations[0].place
                == ["Some City", "Some County", "Some State", "Some Country"])
        #expect(sourceRecordsMap["@S1@"]!.data!.events[0].place?.translations[0].lang
                == "en-GB")
        #expect(sourceRecordsMap["@S1@"]!.data!.events[0].place?.translations[1].place
                == ["Some City", "Some County", "Some State", "Some Country"])
        #expect(sourceRecordsMap["@S1@"]!.data!.events[0].place!.translations[1].lang
                == "en")
        #expect(sourceRecordsMap["@S1@"]!.data!.events[0].place!.map!.lat == 18.150944)
        #expect(sourceRecordsMap["@S1@"]!.data!.events[0].place!.map!.lon == 168.150944)
        #expect(sourceRecordsMap["@S1@"]!.data!.events[0].place!.exids.count == 2)
        #expect(sourceRecordsMap["@S1@"]!.data!.events[0].place!.exids[0].exid == "123")
        #expect(sourceRecordsMap["@S1@"]!.data!.events[0].place!.exids[0].type == "http://example.com")
        #expect(sourceRecordsMap["@S1@"]!.data!.events[0].place!.exids[1].exid == "456")
        #expect(sourceRecordsMap["@S1@"]!.data!.events[0].place!.exids[1].type == "http://example.com")
        #expect(sourceRecordsMap["@S1@"]!.data!.events[0].place!.notes.count ==  2)
        switch sourceRecordsMap["@S1@"]!.data!.events[0].place!.notes[0] {
        case .note(let note):
            #expect(note.text == "American English")
            #expect(note.mimeType == "text/plain")
            #expect(note.lang == "en-US")
            #expect(note.translations.count == 1)
            #expect(note.translations[0].text == "British English")
            #expect(note.translations[0].lang == "en-GB")
            #expect(note.citations.count == 2)
            #expect(note.citations[0].xref == "@S1@")
            #expect(note.citations[0].page == "1")
            #expect(note.citations[1].xref == "@S2@")
            #expect(note.citations[1].page == "2")
        default:
            Issue.record("unexpected note type")
        }
        switch sourceRecordsMap["@S1@"]!.data!.events[0].place!.notes[1] {
        case .sNote(let snote):
            #expect(snote.xref == "@N1@")
        default:
            Issue.record("unexpected note type")
        }
        
        #expect(sourceRecordsMap["@S1@"]!.data!.events[1].eventTypes == ["MARR"])
        //2 EVEN MARR
        //  3 DATE FROM 1701 TO 1800
        //    4 PHRASE 18th century
        
        #expect(sourceRecordsMap["@S1@"]!.data!.agency ==  "Agency name")
        
        #expect(sourceRecordsMap["@S1@"]!.data!.notes.count ==  2)
        switch sourceRecordsMap["@S1@"]!.data!.notes[0] {
        case .note(let note):
            #expect(note.text == "American English")
            #expect(note.mimeType == "text/plain")
            #expect(note.lang == "en-US")
            #expect(note.translations.count == 1)
            #expect(note.translations[0].text == "British English")
            #expect(note.translations[0].lang == "en-GB")
            #expect(note.citations.count == 2)
            #expect(note.citations[0].xref == "@S1@")
            #expect(note.citations[0].page == "1")
            #expect(note.citations[1].xref == "@S2@")
            #expect(note.citations[1].page == "2")
        default:
            Issue.record("unexpected note type")
        }
        
        switch sourceRecordsMap["@S1@"]!.data!.notes[1] {
        case .sNote(let snote):
            #expect(snote.xref == "@N1@")
        default:
            Issue.record("unexpected note type")
        }
        
        #expect(sourceRecordsMap["@S1@"]!.author == "Author")
        #expect(sourceRecordsMap["@S1@"]!.title == "Title")
        #expect(sourceRecordsMap["@S1@"]!.abbreviation == "Abbreviation")
        #expect(sourceRecordsMap["@S1@"]!.publication == "Publication info")
        #expect(sourceRecordsMap["@S1@"]!.text?.text == "Source text")
        #expect(sourceRecordsMap["@S1@"]!.text?.mimeType == "text/plain")
        #expect(sourceRecordsMap["@S1@"]!.text?.lang == "en-US")
        
        #expect(sourceRecordsMap["@S1@"]!.sourceRepoCitation.count == 2)
        #expect(sourceRecordsMap["@S1@"]!.sourceRepoCitation[0].xref == "@R1@")
        #expect(sourceRecordsMap["@S1@"]!.sourceRepoCitation[0].notes.count == 2)
        switch sourceRecordsMap["@S1@"]!.sourceRepoCitation[0].notes[0] {
        case .note(let note):
            #expect(note.text == "Note text")
        default:
            Issue.record("unexpected note type")
        }
        switch sourceRecordsMap["@S1@"]!.sourceRepoCitation[0].notes[1] {
        case .sNote(let note):
            #expect(note.xref == "@N1@")
        default:
            Issue.record("unexpected note type")
        }
        #expect(sourceRecordsMap["@S1@"]!.sourceRepoCitation[0].callNumbers.count == 1)
        #expect(sourceRecordsMap["@S1@"]!.sourceRepoCitation[0].callNumbers[0].callNumber == "Call number")
        #expect(sourceRecordsMap["@S1@"]!.sourceRepoCitation[0].callNumbers[0].medium!.kind == .book)
        #expect(sourceRecordsMap["@S1@"]!.sourceRepoCitation[0].callNumbers[0].medium!.phrase == "Booklet")
        
        #expect(sourceRecordsMap["@S1@"]!.sourceRepoCitation[1].xref == "@R2@")
        #expect(sourceRecordsMap["@S1@"]!.sourceRepoCitation[1].callNumbers.count == 10)
        
        for (c, ex) in zip(sourceRecordsMap["@S1@"]!.sourceRepoCitation[1].callNumbers,
                           [MediumKind.video, MediumKind.card, MediumKind.fiche, MediumKind.film, MediumKind.magazine, MediumKind.manuscript, MediumKind.map, MediumKind.newspaper, MediumKind.photo, MediumKind.tombstone]) {
            #expect(c.callNumber == "Call number")
            #expect(c.medium!.kind == ex)
        }
        
        #expect(sourceRecordsMap["@S1@"]!.identifiers.count == 6)
        switch (sourceRecordsMap["@S1@"]!.identifiers[0]) {
        case .Refn(let refn):
            #expect(refn.refn == "1")
            #expect(refn.type == "User-generated identifier")
        default:
            Issue.record("unexpected identifier type")
        }
        switch (sourceRecordsMap["@S1@"]!.identifiers[1]) {
        case .Refn(let refn):
            #expect(refn.refn == "10")
            #expect(refn.type == "User-generated identifier")
        default:
            Issue.record("unexpected identifier type")
        }
        switch (sourceRecordsMap["@S1@"]!.identifiers[2]) {
        case .Uuid(let uid):
            #expect(uid.uid == UUID(uuidString: "f065a3e8-5c03-4b4a-a89d-6c5e71430a8d"))
        default:
            Issue.record("unexpected identifier type")
        }
        switch (sourceRecordsMap["@S1@"]!.identifiers[3]) {
        case .Uuid(let uid):
            #expect(uid.uid == UUID(uuidString: "9441c3f3-74df-42b4-bbc1-fed42fd7f536"))
        default:
            Issue.record("unexpected identifier type")
        }
        switch (sourceRecordsMap["@S1@"]!.identifiers[4]) {
        case .Exid(let exid):
            #expect(exid.exid == "123")
            #expect(exid.type == "http://example.com")
        default:
            Issue.record("unexpected identifier type")
        }
        switch (sourceRecordsMap["@S1@"]!.identifiers[5]) {
        case .Exid(let exid):
            #expect(exid.exid == "456")
            #expect(exid.type == "http://example.com")
        default:
            Issue.record("unexpected identifier type")
        }
        
        #expect(sourceRecordsMap["@S1@"]!.multimediaLinks.count == 2)
        #expect(sourceRecordsMap["@S1@"]!.multimediaLinks[0].xref == "@O1@")
        #expect(sourceRecordsMap["@S1@"]!.multimediaLinks[1].xref == "@O2@")
        
        #expect(sourceRecordsMap["@S1@"]!.notes.count == 2)
        switch sourceRecordsMap["@S1@"]!.notes[0] {
        case .note(let note):
            #expect(note.text == "Note text")
        default:
            Issue.record("unexpected note type")
        }
        switch sourceRecordsMap["@S1@"]!.notes[1] {
        case .sNote(let note):
            #expect(note.xref == "@N1@")
        default:
            Issue.record("unexpected note type")
        }
        
        #expect(sourceRecordsMap["@S1@"]!.changeDate != nil)
        #expect(sourceRecordsMap["@S1@"]!.changeDate!.date.date == "27 MAR 2022")
        #expect(sourceRecordsMap["@S1@"]!.changeDate!.date.time == "08:56")
        #expect(sourceRecordsMap["@S1@"]!.changeDate!.notes.count == 2)
        
        #expect(sourceRecordsMap["@S1@"]!.creationDate != nil)
        #expect(sourceRecordsMap["@S1@"]!.creationDate!.date.date == "27 MAR 2022")
        #expect(sourceRecordsMap["@S1@"]!.creationDate!.date.time == "08:55")
        
        #expect(sourceRecordsMap["@S2@"]!.title == "Source Two")
    }
    
    @Test func repositories() async throws {
        
        // Repositories
        #expect(repositoryRecordsMap["@R1@"]!.name == "Repository 1")
        #expect(repositoryRecordsMap["@R1@"]!.address!.address == "Family History Department\n15 East South Temple Street\nSalt Lake City, UT 84150 USA")
        #expect(repositoryRecordsMap["@R1@"]!.address!.adr1 == "Family History Department")
        #expect(repositoryRecordsMap["@R1@"]!.address!.adr2 == "15 East South Temple Street")
        #expect(repositoryRecordsMap["@R1@"]!.address!.adr3 == "Salt Lake City, UT 84150 USA")
        #expect(repositoryRecordsMap["@R1@"]!.address!.city == "Salt Lake City")
        #expect(repositoryRecordsMap["@R1@"]!.address!.state == "UT")
        #expect(repositoryRecordsMap["@R1@"]!.address!.postalCode == "84150")
        #expect(repositoryRecordsMap["@R1@"]!.address!.country == "USA")
        #expect(repositoryRecordsMap["@R1@"]!.phoneNumbers
                == ["+1 (555) 555-1212", "+1 (555) 555-1234"])
        #expect(repositoryRecordsMap["@R1@"]!.emails
                == ["GEDCOM@FamilySearch.org", "GEDCOM@example.com"])
        #expect(repositoryRecordsMap["@R1@"]!.faxNumbers
                == ["+1 (555) 555-1212", "+1 (555) 555-1234"])
        #expect(repositoryRecordsMap["@R1@"]!.www
                == [URL(string: "http://gedcom.io")!, URL(string: "http://gedcom.info")!])
        #expect(repositoryRecordsMap["@R1@"]!.notes.count == 2)
        switch repositoryRecordsMap["@R1@"]!.notes[0] {
        case .note(let note):
            #expect(note.text == "Note text")
        default:
            Issue.record("unexpected note type")
        }
        switch repositoryRecordsMap["@R1@"]!.notes[1] {
        case .sNote(let note):
            #expect(note.xref == "@N1@")
        default:
            Issue.record("unexpected note type")
        }
        
        #expect(repositoryRecordsMap["@R1@"]!.identifiers.count == 6)
        switch (repositoryRecordsMap["@R1@"]!.identifiers[0]) {
        case .Refn(let refn):
            #expect(refn.refn == "1")
            #expect(refn.type == "User-generated identifier")
        default:
            Issue.record("unexpected identifier type")
        }
        switch (repositoryRecordsMap["@R1@"]!.identifiers[1]) {
        case .Refn(let refn):
            #expect(refn.refn == "10")
            #expect(refn.type == "User-generated identifier")
        default:
            Issue.record("unexpected identifier type")
        }
        switch (repositoryRecordsMap["@R1@"]!.identifiers[2]) {
        case .Uuid(let uid):
            #expect(uid.uid == UUID(uuidString: "efa7885b-c806-4590-9f1b-247797e4c96d"))
        default:
            Issue.record("unexpected identifier type")
        }
        switch (repositoryRecordsMap["@R1@"]!.identifiers[3]) {
        case .Uuid(let uid):
            #expect(uid.uid == UUID(uuidString: "d530f6ab-cfd4-44cd-ab2c-e40bddb76bf8"))
        default:
            Issue.record("unexpected identifier type")
        }
        switch (repositoryRecordsMap["@R1@"]!.identifiers[4]) {
        case .Exid(let exid):
            #expect(exid.exid == "123")
            #expect(exid.type == "http://example.com")
        default:
            Issue.record("unexpected identifier type")
        }
        switch (repositoryRecordsMap["@R1@"]!.identifiers[5]) {
        case .Exid(let exid):
            #expect(exid.exid == "456")
            #expect(exid.type == "http://example.com")
        default:
            Issue.record("unexpected identifier type")
        }
        
        #expect(repositoryRecordsMap["@R1@"]!.changeDate != nil)
        #expect(repositoryRecordsMap["@R1@"]!.changeDate!.date.date == "27 MAR 2022")
        #expect(repositoryRecordsMap["@R1@"]!.changeDate!.date.time == "08:56")
        #expect(repositoryRecordsMap["@R1@"]!.changeDate!.notes.count == 2)
        #expect(repositoryRecordsMap["@R1@"]!.creationDate != nil)
        #expect(repositoryRecordsMap["@R1@"]!.creationDate!.date.date == "27 MAR 2022")
        #expect(repositoryRecordsMap["@R1@"]!.creationDate!.date.time == "08:55")
        
        #expect(repositoryRecordsMap["@R2@"]!.name == "Repository 2")
    }
    
    @Test func multimediaObjects() async throws {
        
        // Multimedia objects
        #expect(multimediaRecordsMap["@O1@"]!.restrictions == [.CONFIDENTIAL, .LOCKED])
        #expect(multimediaRecordsMap["@O1@"]!.files.count == 2)
        // In the GDZ the path is not a file url, otherwise a file: url
        #expect(multimediaRecordsMap["@O1@"]!.files[0].path == "path/to/file1")
        #expect(multimediaRecordsMap["@O1@"]!.files[0].form.form == "text/plain")
        #expect(multimediaRecordsMap["@O1@"]!.files[0].form.medium?.kind == .other)
        #expect(multimediaRecordsMap["@O1@"]!.files[0].form.medium?.phrase == "Transcript")
        #expect(multimediaRecordsMap["@O1@"]!.files[1].path == "media/original.mp3")
        #expect(multimediaRecordsMap["@O1@"]!.files[1].form.form == "audio/mp3")
        #expect(multimediaRecordsMap["@O1@"]!.files[1].form.medium?.kind == .audio)
        #expect(multimediaRecordsMap["@O1@"]!.files[1].title == "Object title")
        #expect(multimediaRecordsMap["@O1@"]!.files[1].translations.count == 2)
        #expect(multimediaRecordsMap["@O1@"]!.files[1].translations[0].path == "media/derived.oga")
        #expect(multimediaRecordsMap["@O1@"]!.files[1].translations[0].form == "audio/ogg")
        #expect(multimediaRecordsMap["@O1@"]!.files[1].translations[1].path == "media/transcript.vtt")
        #expect(multimediaRecordsMap["@O1@"]!.files[1].translations[1].form == "text/vtt")
        
        #expect(multimediaRecordsMap["@O1@"]!.identifiers.count == 6)
        switch (multimediaRecordsMap["@O1@"]!.identifiers[0]) {
        case .Refn(let refn):
            #expect(refn.refn == "1")
            #expect(refn.type == "User-generated identifier")
        default:
            Issue.record("unexpected identifier type")
        }
        switch (multimediaRecordsMap["@O1@"]!.identifiers[1]) {
        case .Refn(let refn):
            #expect(refn.refn == "10")
            #expect(refn.type == "User-generated identifier")
        default:
            Issue.record("unexpected identifier type")
        }
        switch (multimediaRecordsMap["@O1@"]!.identifiers[2]) {
        case .Uuid(let uid):
            #expect(uid.uid == UUID(uuidString: "69ebdd0e-c78c-4b81-873f-dc8ac30a48b9"))
        default:
            Issue.record("unexpected identifier type")
        }
        switch (multimediaRecordsMap["@O1@"]!.identifiers[3]) {
        case .Uuid(let uid):
            #expect(uid.uid == UUID(uuidString: "79cae8c4-e673-4e4f-bc5d-13b02d931302"))
        default:
            Issue.record("unexpected identifier type")
        }
        switch (multimediaRecordsMap["@O1@"]!.identifiers[4]) {
        case .Exid(let exid):
            #expect(exid.exid == "123")
            #expect(exid.type == "http://example.com")
        default:
            Issue.record("unexpected identifier type")
        }
        switch (multimediaRecordsMap["@O1@"]!.identifiers[5]) {
        case .Exid(let exid):
            #expect(exid.exid == "456")
            #expect(exid.type == "http://example.com")
        default:
            Issue.record("unexpected identifier type")
        }
        #expect(multimediaRecordsMap["@O1@"]!.notes.count == 2)
        switch (multimediaRecordsMap["@O1@"]!.notes[0]) {
        case .note(let note):
            #expect(note.text == "American English")
            #expect(note.mimeType == "text/plain")
            #expect(note.lang == "en-US")
            #expect(note.translations.count == 2)
            #expect(note.translations[0].text == "British English")
            #expect(note.translations[0].lang == "en-GB")
            #expect(note.translations[1].text == "Canadian English")
            #expect(note.translations[1].lang == "en-CA")
            #expect(note.citations.count == 2)
            #expect(note.citations[0].xref == "@S1@")
            #expect(note.citations[0].page == "1")
            #expect(note.citations[1].xref == "@S2@")
            #expect(note.citations[1].page == "2")
        default:
            Issue.record("unexpected note type")
        }
        switch (multimediaRecordsMap["@O1@"]!.notes[1]) {
        case .sNote(let note):
            #expect(note.xref == "@N1@")
        default:
            Issue.record("unexpected snote type")
        }
        
        #expect(multimediaRecordsMap["@O1@"]!.citations.count == 2)
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].page == "1")
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].data?.date?.date == "28 MAR 2022")
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].data?.date?.time == "10:29")
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].data?.date?.phrase == "Morning")
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].data?.text.count == 2)
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].data?.text[0].text == "Text 1")
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].data?.text[0].mimeType == "text/plain")
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].data?.text[0].lang == "en-US")
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].data?.text[1].text == "Text 2")
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].data?.text[1].mimeType == "text/plain")
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].data?.text[1].lang == "en-US")
        
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].events.count == 1)
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].events[0].event == "BIRT")
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].events[0].phrase == "Event phrase")
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].events[0].role!.role == "OTHER")
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].events[0].role!.phrase == "Role phrase")
        
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].quality == 0)
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].multimediaLinks.count == 2)
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].multimediaLinks[0].xref == "@O1@")
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].multimediaLinks[0].crop!.top == 0)
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].multimediaLinks[0].crop!.left == 0)
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].multimediaLinks[0].crop!.height == 100)
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].multimediaLinks[0].crop!.width == 100)
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].multimediaLinks[0].title == "Title")
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].multimediaLinks[1].xref == "@O1@")
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].multimediaLinks[1].crop!.top == 100)
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].multimediaLinks[1].crop!.left == 100)
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].multimediaLinks[1].title == "Title")
        
        
        #expect(multimediaRecordsMap["@O1@"]!.citations[0].notes.count == 2)
        switch (multimediaRecordsMap["@O1@"]!.citations[0].notes[0]) {
        case .note(let note):
            #expect(note.text == "American English")
            #expect(note.mimeType == "text/plain")
            #expect(note.lang == "en-US")
            #expect(note.translations.count == 1)
            #expect(note.translations[0].text == "British English")
            #expect(note.translations[0].lang == "en-GB")
            #expect(note.citations.count == 2)
            #expect(note.citations[0].xref == "@S1@")
            #expect(note.citations[0].page == "1")
            #expect(note.citations[1].xref == "@S2@")
            #expect(note.citations[1].page == "2")
        default:
            Issue.record("unexpected note type")
        }
        switch (multimediaRecordsMap["@O1@"]!.citations[0].notes[1]) {
        case .sNote(let note):
            #expect(note.xref == "@N1@")
        default:
            Issue.record("unexpected snote type")
        }
        
        #expect(multimediaRecordsMap["@O1@"]!.changeDate != nil)
        #expect(multimediaRecordsMap["@O1@"]!.changeDate!.date.date == "27 MAR 2022")
        #expect(multimediaRecordsMap["@O1@"]!.changeDate!.date.time == "08:56")
        #expect(multimediaRecordsMap["@O1@"]!.changeDate!.notes.count == 2)
        #expect(multimediaRecordsMap["@O1@"]!.creationDate != nil)
        #expect(multimediaRecordsMap["@O1@"]!.creationDate!.date.date == "27 MAR 2022")
        #expect(multimediaRecordsMap["@O1@"]!.creationDate!.date.time == "08:55")
        
        
        #expect(multimediaRecordsMap["@O1@"]!.citations[1].xref == "@S1@")
        #expect(multimediaRecordsMap["@O1@"]!.citations[1].page == "2")
        
        #expect(multimediaRecordsMap["@O2@"]!.restrictions == [.PRIVACY])
        #expect(multimediaRecordsMap["@O2@"]!.files[0].path == "http://host.example.com/path/to/file2")
        #expect(multimediaRecordsMap["@O2@"]!.files[0].form.form == "text/plain")
        #expect(multimediaRecordsMap["@O2@"]!.files[0].form.medium?.kind == .electronic)
        
        
    }
    
    // Individual records
    @Test func individuals() async throws {
        
        #expect(individualRecordsMap["@I1@"]?.restrictions == [.CONFIDENTIAL, .LOCKED])
        #expect(individualRecordsMap["@I1@"]?.names.count == 4)
        
        #expect(individualRecordsMap["@I1@"]?.names[0].name == "Lt. Cmndr. Joseph \"John\" /de Allen/ jr.")
        #expect(individualRecordsMap["@I1@"]?.names[0].type?.kind == .other)
        #expect(individualRecordsMap["@I1@"]?.names[0].type?.phrase == "Name type phrase")
        
        #expect(individualRecordsMap["@I1@"]?.names[0].namePieces.count == 6)
        #expect(individualRecordsMap["@I1@"]?.names[0].namePieces[0] == .namePrefix("Lt. Cmndr."))
        #expect(individualRecordsMap["@I1@"]?.names[0].namePieces[1] == .givenName("Joseph"))
        #expect(individualRecordsMap["@I1@"]?.names[0].namePieces[2] == .nickname("John"))
        #expect(individualRecordsMap["@I1@"]?.names[0].namePieces[3] == .surnamePrefix("de"))
        #expect(individualRecordsMap["@I1@"]?.names[0].namePieces[4] == .surname("Allen"))
        #expect(individualRecordsMap["@I1@"]?.names[0].namePieces[5] == .nameSuffix("jr."))
        #expect(individualRecordsMap["@I1@"]?.names[0].translations[0].name == "npfx John /spfx Doe/ nsfx")
        #expect(individualRecordsMap["@I1@"]?.names[0].translations[0].lang == "en-GB")
        #expect(individualRecordsMap["@I1@"]?.names[0].translations[0].namePieces[0] == .namePrefix("npfx"))
        #expect(individualRecordsMap["@I1@"]?.names[0].translations[0].namePieces[1] == .givenName("John"))
        #expect(individualRecordsMap["@I1@"]?.names[0].translations[0].namePieces[2] == .nickname("John"))
        #expect(individualRecordsMap["@I1@"]?.names[0].translations[0].namePieces[3] == .surnamePrefix("spfx"))
        #expect(individualRecordsMap["@I1@"]?.names[0].translations[0].namePieces[4] == .surname("Doe"))
        #expect(individualRecordsMap["@I1@"]?.names[0].translations[0].namePieces[5] == .nameSuffix("nsfx"))
        
        #expect(individualRecordsMap["@I1@"]?.names[0].translations[1].name == "John /Doe/")
        #expect(individualRecordsMap["@I1@"]?.names[0].translations[1].lang == "en-CA")
        
        #expect(individualRecordsMap["@I1@"]?.names[0].notes.count == 3)
        switch individualRecordsMap["@I1@"]?.names[0].notes[0] {
        case .note(let n):
            #expect(n.text == "Note text")
            break
        default:
            Issue.record("bad note in individual name")
        }
        switch individualRecordsMap["@I1@"]?.names[0].notes[1] {
        case .sNote(let n):
            #expect(n.xref == "@N1@")
            break
        default:
            Issue.record("bad note in individual name")
        }
        switch individualRecordsMap["@I1@"]?.names[0].notes[2] {
        case .sNote(let n):
            #expect(n.xref == "@VOID@")
            break
        default:
            Issue.record("bad note in individual name")
        }
        
        
        #expect(individualRecordsMap["@I1@"]?.names[0].citations.count == 2)
        #expect(individualRecordsMap["@I1@"]?.names[0].citations[0].xref == "@S1@")
        #expect(individualRecordsMap["@I1@"]?.names[0].citations[0].page == "1")
        #expect(individualRecordsMap["@I1@"]?.names[0].citations[1].xref == "@S2@")
        
        #expect(individualRecordsMap["@I1@"]?.names[1].name == "John /Doe/")
        #expect(individualRecordsMap["@I1@"]?.names[1].type?.kind == .birth)
        
        #expect(individualRecordsMap["@I1@"]?.names[2].name == "Aka")
        #expect(individualRecordsMap["@I1@"]?.names[2].type?.kind == .aka)
        
        #expect(individualRecordsMap["@I1@"]?.names[3].name == "Immigrant Name")
        #expect(individualRecordsMap["@I1@"]?.names[3].type?.kind == .imigrant)
        
        #expect(individualRecordsMap["@I1@"]?.sex == .male)
        
        #expect(individualRecordsMap["@I1@"]?.attributes.count == 14)
        #expect(individualRecordsMap["@I1@"]?.attributes[0].kind == .caste)
        #expect(individualRecordsMap["@I1@"]?.attributes[0].text == "Caste")
        #expect(individualRecordsMap["@I1@"]?.attributes[0].type == "Caste type")
        
        #expect(individualRecordsMap["@I1@"]?.attributes[1].kind == .physicalDescription)
        #expect(individualRecordsMap["@I1@"]?.attributes[1].text == "Description")
        #expect(individualRecordsMap["@I1@"]?.attributes[1].type == "Description type")
        #expect(individualRecordsMap["@I1@"]?.attributes[1].citations[0].xref == "@VOID@")
        #expect(individualRecordsMap["@I1@"]?.attributes[1].citations[0].page == "Entire source")
        
        #expect(individualRecordsMap["@I1@"]?.attributes[2].kind == .education)
        #expect(individualRecordsMap["@I1@"]?.attributes[2].text == "Education")
        #expect(individualRecordsMap["@I1@"]?.attributes[2].type == "Education type")
        
        #expect(individualRecordsMap["@I1@"]?.attributes[3].kind == .identifyingNumber)
        #expect(individualRecordsMap["@I1@"]?.attributes[3].text == "ID number")
        #expect(individualRecordsMap["@I1@"]?.attributes[3].type == "ID number type")
        
        #expect(individualRecordsMap["@I1@"]?.attributes[4].kind == .nationality)
        #expect(individualRecordsMap["@I1@"]?.attributes[4].text == "Nationality")
        #expect(individualRecordsMap["@I1@"]?.attributes[4].type == "Nationality type")
        
        #expect(individualRecordsMap["@I1@"]?.attributes[5].kind == .numberOfChildren)
        #expect(individualRecordsMap["@I1@"]?.attributes[5].text == "2")
        #expect(individualRecordsMap["@I1@"]?.attributes[5].type == "nchi type")
        
        #expect(individualRecordsMap["@I1@"]?.attributes[6].kind == .numberOfMarriages)
        #expect(individualRecordsMap["@I1@"]?.attributes[6].text == "2")
        #expect(individualRecordsMap["@I1@"]?.attributes[6].type == "nmr type")
        
        #expect(individualRecordsMap["@I1@"]?.attributes[7].kind == .occupation)
        #expect(individualRecordsMap["@I1@"]?.attributes[7].text == "occu")
        #expect(individualRecordsMap["@I1@"]?.attributes[7].type == "occu type")
        
        #expect(individualRecordsMap["@I1@"]?.attributes[8].kind == .property)
        #expect(individualRecordsMap["@I1@"]?.attributes[8].text == "prop")
        #expect(individualRecordsMap["@I1@"]?.attributes[8].type == "prop type")
        
        #expect(individualRecordsMap["@I1@"]?.attributes[9].kind == .religion)
        #expect(individualRecordsMap["@I1@"]?.attributes[9].text == "reli")
        #expect(individualRecordsMap["@I1@"]?.attributes[9].type == "reli type")
        
        #expect(individualRecordsMap["@I1@"]?.attributes[10].kind == .residence)
        #expect(individualRecordsMap["@I1@"]?.attributes[10].text == "resi")
        #expect(individualRecordsMap["@I1@"]?.attributes[10].type == "resi type")
        
        #expect(individualRecordsMap["@I1@"]?.attributes[11].kind == .socialSecurityNumber)
        #expect(individualRecordsMap["@I1@"]?.attributes[11].text == "ssn")
        #expect(individualRecordsMap["@I1@"]?.attributes[11].type == "ssn type")
        
        #expect(individualRecordsMap["@I1@"]?.attributes[12].kind == .title)
        #expect(individualRecordsMap["@I1@"]?.attributes[12].text == "titl")
        #expect(individualRecordsMap["@I1@"]?.attributes[12].type == "titl type")
        
        #expect(individualRecordsMap["@I1@"]?.attributes[13].kind == .fact)
        #expect(individualRecordsMap["@I1@"]?.attributes[13].text == "fact")
        #expect(individualRecordsMap["@I1@"]?.attributes[13].type == "fact type")
        
        #expect(individualRecordsMap["@I1@"]?.events.count == 26)
        #expect(individualRecordsMap["@I1@"]?.events[0].kind == .baptism)
        #expect(individualRecordsMap["@I1@"]?.events[0].type == "bapm type")
        
        #expect(individualRecordsMap["@I1@"]?.events[1].kind == .baptism)
        #expect(individualRecordsMap["@I1@"]?.events[1].occurred == true)
        
        
        #expect(individualRecordsMap["@I1@"]?.events[2].kind == .barMitzvah)
        #expect(individualRecordsMap["@I1@"]?.events[2].type == "barm type")
        
        #expect(individualRecordsMap["@I1@"]?.events[3].kind == .basMitzvah)
        #expect(individualRecordsMap["@I1@"]?.events[3].type == "basm type")
        
        #expect(individualRecordsMap["@I1@"]?.events[4].kind == .blessing)
        #expect(individualRecordsMap["@I1@"]?.events[4].type == "bles type")
        
        #expect(individualRecordsMap["@I1@"]?.events[5].kind == .burial)
        #expect(individualRecordsMap["@I1@"]?.events[5].type == "buri type")
        #expect(individualRecordsMap["@I1@"]?.events[5].date?.date == "30 MAR 2022")
        
        #expect(individualRecordsMap["@I1@"]?.events[6].kind == .census)
        #expect(individualRecordsMap["@I1@"]?.events[6].type == "cens type")
        #expect(individualRecordsMap["@I1@"]?.events[7].kind == .adultChristening)
        #expect(individualRecordsMap["@I1@"]?.events[7].type == "chra type")
        #expect(individualRecordsMap["@I1@"]?.events[8].kind == .confirmation)
        #expect(individualRecordsMap["@I1@"]?.events[8].type == "conf type")
        #expect(individualRecordsMap["@I1@"]?.events[9].kind == .cremation)
        #expect(individualRecordsMap["@I1@"]?.events[9].type == "crem type")
        
        #expect(individualRecordsMap["@I1@"]?.events[10].kind == .death)
        #expect(individualRecordsMap["@I1@"]?.events[10].type == "deat type")
        #expect(individualRecordsMap["@I1@"]?.events[10].date?.date == "28 MAR 2022")
        #expect(individualRecordsMap["@I1@"]?.events[10].place?.place == ["Somewhere"])
        #expect(individualRecordsMap["@I1@"]?.events[10].address?.address == "Address")
        #expect(individualRecordsMap["@I1@"]?.events[10].phones == ["+1 (555) 555-1212", "+1 (555) 555-1234"])
        #expect(individualRecordsMap["@I1@"]?.events[10].emails == ["GEDCOM@FamilySearch.org", "GEDCOM@example.com"])
        #expect(individualRecordsMap["@I1@"]?.events[10].fax == ["+1 (555) 555-1212", "+1 (555) 555-1234"])
        #expect(individualRecordsMap["@I1@"]?.events[10].www == [URL(string: "http://gedcom.io")!, URL(string: "http://gedcom.info")!])
        #expect(individualRecordsMap["@I1@"]?.events[10].agency == "Agency")
        #expect(individualRecordsMap["@I1@"]?.events[10].religion == "Religion")
        #expect(individualRecordsMap["@I1@"]?.events[10].cause == "Cause of death")
        #expect(individualRecordsMap["@I1@"]?.events[10].cause == "Cause of death")
        #expect(individualRecordsMap["@I1@"]?.events[10].restrictions == [.CONFIDENTIAL, .LOCKED])
        #expect(individualRecordsMap["@I1@"]?.events[10].sdate?.date == "28 MAR 2022")
        #expect(individualRecordsMap["@I1@"]?.events[10].sdate?.time == "16:47")
        #expect(individualRecordsMap["@I1@"]?.events[10].sdate?.phrase == "sdate phrase")
        
        #expect(individualRecordsMap["@I1@"]?.events[10].associations[0].xref == "@I3@")
        #expect(individualRecordsMap["@I1@"]?.events[10].associations[0].role?.kind == .CHIL)
        
        #expect(individualRecordsMap["@I1@"]?.events[10].associations[1].xref == "@VOID@")
        #expect(individualRecordsMap["@I1@"]?.events[10].associations[1].role?.kind == .PARENT)
        switch individualRecordsMap["@I1@"]?.events[10].notes[0] {
        case .note(let n):
            #expect(n.text == "Note text")
        default:
            Issue.record("bad note in individual event")
        }
        switch individualRecordsMap["@I1@"]?.events[10].notes[1] {
        case .sNote(let n):
            #expect(n.xref == "@N1@")
        default:
            Issue.record("bad note in individual event")
        }
        
        #expect(individualRecordsMap["@I1@"]?.events[10].citations[0].xref == "@S1@")
        #expect(individualRecordsMap["@I1@"]?.events[10].citations[0].page == "1")
        #expect(individualRecordsMap["@I1@"]?.events[10].citations[1].xref == "@S2@")
        #expect(individualRecordsMap["@I1@"]?.events[10].citations[1].page == "2")
        
        #expect(individualRecordsMap["@I1@"]?.events[10].multimediaLinks[0].xref == "@O1@")
        #expect(individualRecordsMap["@I1@"]?.events[10].multimediaLinks[1].xref == "@O2@")
        #expect(individualRecordsMap["@I1@"]?.events[10].uid == [
            UUID(uuidString: "82092878-6f4f-4bca-ad59-d1ae87c5e521")!,
            UUID(uuidString: "daf4b8c0-4141-42c4-bec8-01d1d818dfaf")!])
        
        #expect(individualRecordsMap["@I1@"]?.events[11].kind == .emigration)
        #expect(individualRecordsMap["@I1@"]?.events[11].type == "emig type")
        #expect(individualRecordsMap["@I1@"]?.events[12].kind == .firstCommunion)
        #expect(individualRecordsMap["@I1@"]?.events[12].type == "fcom type")
        #expect(individualRecordsMap["@I1@"]?.events[13].kind == .graduation)
        #expect(individualRecordsMap["@I1@"]?.events[13].type == "grad type")
        #expect(individualRecordsMap["@I1@"]?.events[14].kind == .immigration)
        #expect(individualRecordsMap["@I1@"]?.events[14].type == "immi type")
        #expect(individualRecordsMap["@I1@"]?.events[15].kind == .naturalization)
        #expect(individualRecordsMap["@I1@"]?.events[15].type == "natu type")
        #expect(individualRecordsMap["@I1@"]?.events[16].kind == .ordination)
        #expect(individualRecordsMap["@I1@"]?.events[16].type == "ordn type")
        #expect(individualRecordsMap["@I1@"]?.events[17].kind == .probate)
        #expect(individualRecordsMap["@I1@"]?.events[17].type == "prob type")
        #expect(individualRecordsMap["@I1@"]?.events[18].kind == .retirement)
        #expect(individualRecordsMap["@I1@"]?.events[18].type == "reti type")
        #expect(individualRecordsMap["@I1@"]?.events[19].kind == .will)
        #expect(individualRecordsMap["@I1@"]?.events[19].type == "will type")
        
        #expect(individualRecordsMap["@I1@"]?.events[20].kind == .adoption)
        #expect(individualRecordsMap["@I1@"]?.events[20].type == "adop type")
        #expect(individualRecordsMap["@I1@"]?.events[20].familyChild?.xref == "@VOID@")
        #expect(individualRecordsMap["@I1@"]?.events[20].familyChild?.adoption?.kind == .BOTH)
        #expect(individualRecordsMap["@I1@"]?.events[20].familyChild?.adoption?.phrase == "Adoption phrase")
        
        #expect(individualRecordsMap["@I1@"]?.events[21].kind == .adoption)
        #expect(individualRecordsMap["@I1@"]?.events[21].familyChild?.xref == "@VOID@")
        #expect(individualRecordsMap["@I1@"]?.events[21].familyChild?.adoption?.kind == .HUSB)
        
        #expect(individualRecordsMap["@I1@"]?.events[22].kind == .adoption)
        #expect(individualRecordsMap["@I1@"]?.events[22].familyChild?.xref == "@VOID@")
        #expect(individualRecordsMap["@I1@"]?.events[22].familyChild?.adoption?.kind == .WIFE)
        
        #expect(individualRecordsMap["@I1@"]?.events[23].kind == .birth)
        #expect(individualRecordsMap["@I1@"]?.events[23].type == "birth type")
        #expect(individualRecordsMap["@I1@"]?.events[23].date?.date == "1 JAN 2000")
        
        #expect(individualRecordsMap["@I1@"]?.events[24].kind == .christening)
        #expect(individualRecordsMap["@I1@"]?.events[24].type == "chr type")
        #expect(individualRecordsMap["@I1@"]?.events[24].date?.date == "9 JAN 2000")
        #expect(individualRecordsMap["@I1@"]?.events[24].age?.age == "8d")
        #expect(individualRecordsMap["@I1@"]?.events[24].age?.phrase == "Age phrase")
        
        #expect(individualRecordsMap["@I1@"]?.events[25].kind == .even)
        #expect(individualRecordsMap["@I1@"]?.events[25].text == "Event")
        #expect(individualRecordsMap["@I1@"]?.events[25].type == "Event type")
        
        #expect(individualRecordsMap["@I1@"]?.nonEvents[0].kind == .naturalization)
        #expect(individualRecordsMap["@I1@"]?.nonEvents[0].date?.date == "FROM 1700 TO 1800")
        #expect(individualRecordsMap["@I1@"]?.nonEvents[0].date?.phrase == "No date phrase")
        
        switch individualRecordsMap["@I1@"]?.nonEvents[0].notes[0] {
        case .note(let n):
            #expect(n.text == "Note text")
        default:
            Issue.record("bad note in individual non-event details")
        }
        
        switch individualRecordsMap["@I1@"]?.nonEvents[0].notes[1] {
        case .sNote(let n):
            #expect(n.xref == "@N1@")
        default:
            Issue.record("bad note in individual non-event details")
        }
        
        #expect(individualRecordsMap["@I1@"]?.nonEvents[0].citations[0].xref == "@S1@")
        #expect(individualRecordsMap["@I1@"]?.nonEvents[0].citations[0].page == "1")
        #expect(individualRecordsMap["@I1@"]?.nonEvents[0].citations[1].xref == "@S1@")
        #expect(individualRecordsMap["@I1@"]?.nonEvents[0].citations[1].page == "2")
        
        #expect(individualRecordsMap["@I1@"]?.nonEvents[1].kind == .emigration)
        
        
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[0].kind == .BAPL)
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[0].status?.kind == .STILLBORN)
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[0].status?.date.date == "27 MAR 2022")
        
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[1].kind == .BAPL)
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[1].status?.kind == .SUBMITTED)
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[1].status?.date.date == "27 MAR 2022")
        
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[2].kind == .BAPL)
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[2].date?.date == "27 MAR 2022")
        
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[3].kind == .CONL)
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[3].status?.kind == .INFANT)
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[3].status?.date.date == "27 MAR 2022")
        
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[4].kind == .CONL)
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[4].date?.date == "27 MAR 2022")
        
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[5].kind == .ENDL)
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[5].status?.kind == .CHILD)
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[5].status?.date.date == "27 MAR 2022")
        
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[6].kind == .ENDL)
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[6].date?.date == "27 MAR 2022")
        
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[7].kind == .INIL)
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[7].status?.kind == .EXCLUDED)
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[7].status?.date.date == "27 MAR 2022")
        
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[8].kind == .INIL)
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[8].date?.date == "27 MAR 2022")
        
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[9].kind == .SLGC)
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[9].date?.date == "27 MAR 2022")
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[9].date?.time == "15:47")
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[9].date?.phrase == "Afternoon")
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[9].temple == "SLAKE")
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[9].familyChild == "@VOID@")
        
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[10].kind == .SLGC)
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[10].place?.place == ["Place"])
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[10].status?.kind == .BIC)
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[10].status?.date.date == "27 MAR 2022")
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[10].status?.date.time == "15:48")
        
        switch individualRecordsMap["@I1@"]?.ldsDetails[10].notes[0] {
        case .note(let n):
            #expect(n.text == "Note text")
        default:
            Issue.record("bad note in lds details")
        }
        switch individualRecordsMap["@I1@"]?.ldsDetails[10].notes[1] {
        case .sNote(let n):
            #expect(n.xref == "@N1@")
        default:
            Issue.record("bad note in lds details")
        }
        
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[10].citations[0].xref == "@S1@")
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[10].citations[0].page == "1")
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[10].citations[1].xref == "@S2@")
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[10].citations[1].page == "2")
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[10].familyChild == "@VOID@")
        
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[11].kind == .SLGC)
        #expect(individualRecordsMap["@I1@"]?.ldsDetails[11].familyChild == "@F2@")
        
        #expect(individualRecordsMap["@I1@"]?.childOfFamilies.count == 5)
        #expect(individualRecordsMap["@I1@"]?.childOfFamilies[0].xref == "@VOID@")
        #expect(individualRecordsMap["@I1@"]?.childOfFamilies[0].pedigree?.kind == .OTHER)
        #expect(individualRecordsMap["@I1@"]?.childOfFamilies[0].pedigree?.phrase == "Other type")
        #expect(individualRecordsMap["@I1@"]?.childOfFamilies[0].status?.kind == .CHALLENGED)
        #expect(individualRecordsMap["@I1@"]?.childOfFamilies[0].status?.phrase == "Phrase")
        
        #expect(individualRecordsMap["@I1@"]?.childOfFamilies[1].xref == "@VOID@")
        #expect(individualRecordsMap["@I1@"]?.childOfFamilies[1].pedigree?.kind == .FOSTER)
        #expect(individualRecordsMap["@I1@"]?.childOfFamilies[2].xref == "@VOID@")
        #expect(individualRecordsMap["@I1@"]?.childOfFamilies[2].pedigree?.kind == .SEALING)
        #expect(individualRecordsMap["@I1@"]?.childOfFamilies[3].xref == "@F2@")
        #expect(individualRecordsMap["@I1@"]?.childOfFamilies[3].pedigree?.kind == .ADOPTED)
        #expect(individualRecordsMap["@I1@"]?.childOfFamilies[3].status?.kind == .PROVEN)
        #expect(individualRecordsMap["@I1@"]?.childOfFamilies[4].xref == "@F2@")
        #expect(individualRecordsMap["@I1@"]?.childOfFamilies[4].pedigree?.kind == .BIRTH)
        #expect(individualRecordsMap["@I1@"]?.childOfFamilies[4].status?.kind == .DISPROVEN)
        
        #expect(individualRecordsMap["@I1@"]?.spouseFamilies.count == 2)
        #expect(individualRecordsMap["@I1@"]?.spouseFamilies[0].xref == "@VOID@")
        switch individualRecordsMap["@I1@"]?.spouseFamilies[0].notes[0] {
        case .note(let n):
            #expect(n.text == "Note text")
        default:
            Issue.record("bad note in individual fams")
        }
        switch individualRecordsMap["@I1@"]?.spouseFamilies[0].notes[1] {
        case .sNote(let n):
            #expect(n.xref == "@N1@")
        default:
            Issue.record("bad note in individual fams")
        }
        
        #expect(individualRecordsMap["@I1@"]?.spouseFamilies[1].xref == "@F1@")
        
        #expect(individualRecordsMap["@I1@"]?.submitters.count == 2)
        #expect(individualRecordsMap["@I1@"]?.submitters[0] == "@U1@")
        #expect(individualRecordsMap["@I1@"]?.submitters[1] == "@U2@")
        
        #expect(individualRecordsMap["@I1@"]?.associations.count == 9)
        #expect(individualRecordsMap["@I1@"]?.associations[0].xref == "@VOID@")
        #expect(individualRecordsMap["@I1@"]?.associations[0].phrase == "Mr Stockdale")
        #expect(individualRecordsMap["@I1@"]?.associations[0].role?.kind == .FRIEND)
        
        #expect(individualRecordsMap["@I1@"]?.associations[1].xref == "@VOID@")
        #expect(individualRecordsMap["@I1@"]?.associations[1].role?.kind == .NGHBR)
        
        #expect(individualRecordsMap["@I1@"]?.associations[2].xref == "@VOID@")
        #expect(individualRecordsMap["@I1@"]?.associations[2].role?.kind == .FATH)
        
        #expect(individualRecordsMap["@I1@"]?.associations[3].xref == "@VOID@")
        #expect(individualRecordsMap["@I1@"]?.associations[3].role?.kind == .GODP)
        
        #expect(individualRecordsMap["@I1@"]?.associations[4].xref == "@VOID@")
        #expect(individualRecordsMap["@I1@"]?.associations[4].role?.kind == .HUSB)
        
        #expect(individualRecordsMap["@I1@"]?.associations[5].xref == "@VOID@")
        #expect(individualRecordsMap["@I1@"]?.associations[5].role?.kind == .MOTH)
        
        #expect(individualRecordsMap["@I1@"]?.associations[6].xref == "@VOID@")
        #expect(individualRecordsMap["@I1@"]?.associations[6].role?.kind == .MULTIPLE)
        
        #expect(individualRecordsMap["@I1@"]?.associations[7].xref == "@VOID@")
        #expect(individualRecordsMap["@I1@"]?.associations[7].role?.kind == .SPOU)
        
        #expect(individualRecordsMap["@I1@"]?.associations[8].xref == "@VOID@")
        #expect(individualRecordsMap["@I1@"]?.associations[8].role?.kind == .WIFE)
        
        #expect(individualRecordsMap["@I1@"]?.aliases.count == 2)
        #expect(individualRecordsMap["@I1@"]?.aliases[0].xref == "@VOID@")
        #expect(individualRecordsMap["@I1@"]?.aliases[1].xref == "@I3@")
        #expect(individualRecordsMap["@I1@"]?.aliases[1].phrase == "Alias")
        
        #expect(individualRecordsMap["@I1@"]?.ancestorInterest.count == 2)
        #expect(individualRecordsMap["@I1@"]?.ancestorInterest[0] == "@U1@")
        #expect(individualRecordsMap["@I1@"]?.ancestorInterest[1] == "@VOID@")
        
        #expect(individualRecordsMap["@I1@"]?.decendantInterest.count == 2)
        #expect(individualRecordsMap["@I1@"]?.decendantInterest[0] == "@U1@")
        #expect(individualRecordsMap["@I1@"]?.decendantInterest[1] == "@VOID@")
        
        #expect(individualRecordsMap["@I1@"]?.identifiers.count == 6)
        switch individualRecordsMap["@I1@"]?.identifiers[0] {
        case .Refn(let ident):
            #expect(ident.refn == "1")
            #expect(ident.type == "User-generated identifier")
        default:
            Issue.record("bad identifier in individual")
        }
        
        switch individualRecordsMap["@I1@"]?.identifiers[1] {
        case .Refn(let ident):
            #expect(ident.refn == "10")
            #expect(ident.type == "User-generated identifier")
        default:
            Issue.record("bad identifier in individual")
        }
        
        switch individualRecordsMap["@I1@"]?.identifiers[2] {
        case .Uuid(let ident):
            #expect(ident.uid == UUID(uuidString: "3d75b5eb-36e9-40b3-b79f-f088b5c18595")!)
        default:
            Issue.record("bad identifier in individual")
        }
        
        switch individualRecordsMap["@I1@"]?.identifiers[3] {
        case .Uuid(let ident):
            #expect(ident.uid == UUID(uuidString: "cb49c361-7124-447e-b587-4c6d36e51825")!)
        default:
            Issue.record("bad identifier in individual")
        }
        
        switch individualRecordsMap["@I1@"]?.identifiers[4] {
        case .Exid(let ident):
            #expect(ident.exid == "123")
            #expect(ident.type == "http://example.com")
        default:
            Issue.record("bad identifier in individual")
        }
        
        switch individualRecordsMap["@I1@"]?.identifiers[5] {
        case .Exid(let ident):
            #expect(ident.exid == "456")
            #expect(ident.type == "http://example.com")
            
        default:
            Issue.record("bad identifier in individual")
        }
        
        
        #expect(individualRecordsMap["@I1@"]?.notes.count == 2)
        switch individualRecordsMap["@I1@"]?.notes[0] {
        case .note(let n):
            #expect(n.text == "me@example.com is an example email address.\n@me and @I are example social media handles.\n@@@@ has four @ characters where only the first is escaped.")
        default:
            Issue.record("bad note in individual")
        }
        switch individualRecordsMap["@I1@"]?.notes[1] {
        case .sNote(let n):
            #expect(n.xref == "@N1@")
        default:
            Issue.record("bad note in individual")
        }
        
        #expect(individualRecordsMap["@I1@"]?.citations.count == 2)
        #expect(individualRecordsMap["@I1@"]?.citations[0].xref == "@S1@")
        #expect(individualRecordsMap["@I1@"]?.citations[0].page == "1")
        #expect(individualRecordsMap["@I1@"]?.citations[0].quality == 3)
        #expect(individualRecordsMap["@I1@"]?.citations[1].xref == "@S2@")
        
        #expect(individualRecordsMap["@I1@"]?.multimediaLinks.count == 2)
        #expect(individualRecordsMap["@I1@"]?.multimediaLinks[0].xref == "@O1@")
        #expect(individualRecordsMap["@I1@"]?.multimediaLinks[1].xref == "@O2@")
        
        #expect(individualRecordsMap["@I1@"]?.changeDate?.date.date == "27 MAR 2022")
        #expect(individualRecordsMap["@I1@"]?.changeDate?.date.time == "08:56")
        switch individualRecordsMap["@I1@"]?.changeDate?.notes[0] {
        case .note(let n):
            #expect(n.text == "Change date note 1")
        default :
            Issue.record("bad note in individual change date")
        }
        switch individualRecordsMap["@I1@"]?.changeDate?.notes[1] {
        case .note(let n):
            #expect(n.text == "Change date note 2")
        default :
            Issue.record("bad note in individual change date")
        }
        
        
        #expect(individualRecordsMap["@I1@"]?.creationDate?.date.date == "27 MAR 2022")
        #expect(individualRecordsMap["@I1@"]?.creationDate?.date.time == "08:55")
        
        #expect(individualRecordsMap["@I2@"]?.names[0].name == "Maiden Name")
        #expect(individualRecordsMap["@I2@"]?.names[0].type?.kind == .maiden)
        
        #expect(individualRecordsMap["@I2@"]?.names[1].name == "Married Name")
        #expect(individualRecordsMap["@I2@"]?.names[1].type?.kind == .married)
        
        #expect(individualRecordsMap["@I2@"]?.names[2].name == "Professional Name")
        #expect(individualRecordsMap["@I2@"]?.names[2].type?.kind == .professional)
        
        #expect(individualRecordsMap["@I2@"]?.sex == .female)
        #expect(individualRecordsMap["@I2@"]?.spouseFamilies[0].xref == "@F1@")
        
        #expect(individualRecordsMap["@I3@"]?.sex == .other)
        
        #expect(individualRecordsMap["@I4@"]?.sex == .unknown)
        #expect(individualRecordsMap["@I4@"]?.childOfFamilies[0].xref == "@F1@")
    }
    
    // Family records
    @Test func families() async throws {
        #expect(familyRecordsMap["@F1@"]?.restrictions == [.CONFIDENTIAL, .LOCKED])
        
        #expect(familyRecordsMap["@F1@"]?.attributes.count == 3)
        
        #expect(familyRecordsMap["@F1@"]?.attributes[0].kind == .NCHI)
        #expect(familyRecordsMap["@F1@"]?.attributes[0].type == "Type of children")
        #expect(familyRecordsMap["@F1@"]?.attributes[0].husbandInfo?.age.age == "25y")
        #expect(familyRecordsMap["@F1@"]?.attributes[0].husbandInfo?.age.phrase == "Adult")
        #expect(familyRecordsMap["@F1@"]?.attributes[0].wifeInfo?.age.age == "25y")
        #expect(familyRecordsMap["@F1@"]?.attributes[0].wifeInfo?.age.phrase == "Adult")
        
        #expect(familyRecordsMap["@F1@"]?.attributes[1].kind == .RESI)
        #expect(familyRecordsMap["@F1@"]?.attributes[1].type == "Type of residence")
        #expect(familyRecordsMap["@F1@"]?.attributes[1].husbandInfo?.age.age == "25y")
        #expect(familyRecordsMap["@F1@"]?.attributes[1].husbandInfo?.age.phrase == "Adult")
        #expect(familyRecordsMap["@F1@"]?.attributes[1].wifeInfo?.age.age == "25y")
        #expect(familyRecordsMap["@F1@"]?.attributes[1].wifeInfo?.age.phrase == "Adult")
        
        #expect(familyRecordsMap["@F1@"]?.attributes[2].kind == .FACT)
        #expect(familyRecordsMap["@F1@"]?.attributes[2].type == "Type of fact")
        #expect(familyRecordsMap["@F1@"]?.attributes[2].husbandInfo?.age.age == "25y")
        #expect(familyRecordsMap["@F1@"]?.attributes[2].husbandInfo?.age.phrase == "Adult")
        #expect(familyRecordsMap["@F1@"]?.attributes[2].wifeInfo?.age.age == "25y")
        #expect(familyRecordsMap["@F1@"]?.attributes[2].wifeInfo?.age.phrase == "Adult")
        
        #expect(familyRecordsMap["@F1@"]?.events[0].kind == .annulment)
        #expect(familyRecordsMap["@F1@"]?.events[0].occured == true)
        
        #expect(familyRecordsMap["@F1@"]?.events[1].kind == .census)
        #expect(familyRecordsMap["@F1@"]?.events[1].occured == true)
        
        #expect(familyRecordsMap["@F1@"]?.events[2].kind == .divorce)
        #expect(familyRecordsMap["@F1@"]?.events[2].occured == true)
        
        #expect(familyRecordsMap["@F1@"]?.events[3].kind == .divorceFiled)
        #expect(familyRecordsMap["@F1@"]?.events[3].occured == true)
        
        #expect(familyRecordsMap["@F1@"]?.events[4].kind == .engagement)
        #expect(familyRecordsMap["@F1@"]?.events[4].occured == true)
        
        #expect(familyRecordsMap["@F1@"]?.events[5].kind == .marriageBann)
        #expect(familyRecordsMap["@F1@"]?.events[5].occured == true)
        
        #expect(familyRecordsMap["@F1@"]?.events[6].kind == .marriageContract)
        #expect(familyRecordsMap["@F1@"]?.events[6].occured == true)
        
        #expect(familyRecordsMap["@F1@"]?.events[7].kind == .marriageLicense)
        #expect(familyRecordsMap["@F1@"]?.events[7].occured == true)
        
        #expect(familyRecordsMap["@F1@"]?.events[8].kind == .marriageSettlement)
        #expect(familyRecordsMap["@F1@"]?.events[8].occured == true)
        
        #expect(familyRecordsMap["@F1@"]?.events[9].kind == .marriage)
        #expect(familyRecordsMap["@F1@"]?.events[9].occured == true)
        #expect(familyRecordsMap["@F1@"]?.events[9].husbandInfo?.age.age == "25y")
        #expect(familyRecordsMap["@F1@"]?.events[9].husbandInfo?.age.phrase == "Adult")
        #expect(familyRecordsMap["@F1@"]?.events[9].wifeInfo?.age.age == "25y")
        #expect(familyRecordsMap["@F1@"]?.events[9].wifeInfo?.age.phrase == "Adult")
        #expect(familyRecordsMap["@F1@"]?.events[9].date?.date == "27 MAR 2022")
        #expect(familyRecordsMap["@F1@"]?.events[9].date?.time == "16:02")
        #expect(familyRecordsMap["@F1@"]?.events[9].date?.phrase == "Afternoon")
        #expect(familyRecordsMap["@F1@"]?.events[9].place?.place == ["Place"])
        #expect(familyRecordsMap["@F1@"]?.events[9].address?.address == "Address")
        #expect(familyRecordsMap["@F1@"]?.events[9].phones == ["+1 (555) 555-1212", "+1 (555) 555-1234"])
        #expect(familyRecordsMap["@F1@"]?.events[9].emails == ["GEDCOM@FamilySearch.org", "GEDCOM@example.com"])
        #expect(familyRecordsMap["@F1@"]?.events[9].fax == ["+1 (555) 555-1212", "+1 (555) 555-1234"])
        #expect(familyRecordsMap["@F1@"]?.events[9].www == [URL(string: "http://gedcom.io")!, URL(string: "http://gedcom.info")!])
        
        #expect(familyRecordsMap["@F1@"]?.events[9].agency == "Agency")
        #expect(familyRecordsMap["@F1@"]?.events[9].religion == "Religion")
        #expect(familyRecordsMap["@F1@"]?.events[9].cause == "Cause")
        #expect(familyRecordsMap["@F1@"]?.events[9].restrictions == [.CONFIDENTIAL, .LOCKED])
        #expect(familyRecordsMap["@F1@"]?.events[9].sdate?.date == "27 MAR 2022")
        #expect(familyRecordsMap["@F1@"]?.events[9].sdate?.time == "16:03")
        #expect(familyRecordsMap["@F1@"]?.events[9].sdate?.phrase == "Afternoon")
        #expect(familyRecordsMap["@F1@"]?.events[9].associations[0].xref == "@VOID@")
        #expect(familyRecordsMap["@F1@"]?.events[9].associations[0].role?.kind == .OFFICIATOR)
        #expect(familyRecordsMap["@F1@"]?.events[9].associations[1].xref == "@VOID@")
        #expect(familyRecordsMap["@F1@"]?.events[9].associations[1].role?.kind == .WITN)
        switch familyRecordsMap["@F1@"]?.events[9].associations[1].notes[0] {
        case .note(let n):
            #expect(n.text == "Note text")
        default:
            Issue.record("bad note in family event association")
        }
        
        switch familyRecordsMap["@F1@"]?.events[9].notes[0] {
        case .sNote(let n):
            #expect(n.xref == "@N1@")
        default:
            Issue.record("bad note in family event")
        }
        
        #expect(familyRecordsMap["@F1@"]?.events[9].citations[0].xref == "@S1@")
        #expect(familyRecordsMap["@F1@"]?.events[9].citations[0].page == "1")
        #expect(familyRecordsMap["@F1@"]?.events[9].citations[1].xref == "@S1@")
        #expect(familyRecordsMap["@F1@"]?.events[9].citations[1].page == "2")
        
        #expect(familyRecordsMap["@F1@"]?.events[9].multimediaLinks[0].xref == "@O1@")
        #expect(familyRecordsMap["@F1@"]?.events[9].multimediaLinks[1].xref == "@O2@")
        
        #expect(familyRecordsMap["@F1@"]?.events[9].uid == [UUID(uuidString: "bbcc0025-34cb-4542-8cfb-45ba201c9c2c")!, UUID(uuidString: "9ead4205-5bad-4c05-91c1-0aecd3f5127d")!])
        
        #expect(familyRecordsMap["@F1@"]?.events[10].kind == .even)
        #expect(familyRecordsMap["@F1@"]?.events[10].text == "Event")
        #expect(familyRecordsMap["@F1@"]?.events[10].type == "Event type")
        
        #expect(familyRecordsMap["@F1@"]?.nonEvents[0].kind == .divorce)
        #expect(familyRecordsMap["@F1@"]?.nonEvents[0].date?.date == "FROM 1700 TO 1800")
        #expect(familyRecordsMap["@F1@"]?.nonEvents[0].date?.phrase == "No date phrase")
        
        switch familyRecordsMap["@F1@"]?.nonEvents[0].notes[0] {
        case .note(let n):
            #expect(n.text == "Note text")
        default:
            Issue.record("bad note in family non event")
        }
        switch familyRecordsMap["@F1@"]?.nonEvents[0].notes[1] {
        case .sNote(let n):
            #expect(n.xref == "@N2@")
        default:
            Issue.record("bad note in family non event")
        }
        #expect(familyRecordsMap["@F1@"]?.nonEvents[0].citations[0].xref == "@S1@")
        #expect(familyRecordsMap["@F1@"]?.nonEvents[0].citations[0].page == "1")
        #expect(familyRecordsMap["@F1@"]?.nonEvents[0].citations[1].xref == "@S1@")
        #expect(familyRecordsMap["@F1@"]?.nonEvents[0].citations[1].page == "2")
        
        #expect(familyRecordsMap["@F1@"]?.nonEvents[1].kind == .annulment)
        
        
        #expect(familyRecordsMap["@F1@"]?.husband?.xref == "@I1@")
        #expect(familyRecordsMap["@F1@"]?.husband?.phrase == "Husband phrase")
        #expect(familyRecordsMap["@F1@"]?.wife?.xref == "@I2@")
        #expect(familyRecordsMap["@F1@"]?.wife?.phrase == "Wife phrase")
        
        #expect(familyRecordsMap["@F1@"]?.children[0].xref == "@I4@")
        #expect(familyRecordsMap["@F1@"]?.children[0].phrase == "First child")
        
        #expect(familyRecordsMap["@F1@"]?.children[1].xref == "@VOID@")
        #expect(familyRecordsMap["@F1@"]?.children[1].phrase == "Second child")
        
        #expect(familyRecordsMap["@F1@"]?.associations[0].xref == "@I3@")
        #expect(familyRecordsMap["@F1@"]?.associations[0].phrase == "Association text")
        #expect(familyRecordsMap["@F1@"]?.associations[0].role?.kind == .OTHER)
        #expect(familyRecordsMap["@F1@"]?.associations[0].role?.phrase == "Role text")
        switch familyRecordsMap["@F1@"]?.associations[0].notes[0] {
        case .note(let n):
            #expect(n.text == "Note text")
        default:
            Issue.record("bad note in family")
        }
        switch familyRecordsMap["@F1@"]?.associations[0].notes[1] {
        case .sNote(let n):
            #expect(n.xref == "@N1@")
        default:
            Issue.record("bad note in family")
        }
        
        #expect(familyRecordsMap["@F1@"]?.associations[0].citations[0].xref == "@S1@")
        #expect(familyRecordsMap["@F1@"]?.associations[0].citations[0].page == "1")
        
        #expect(familyRecordsMap["@F1@"]?.associations[0].citations[1].xref == "@S2@")
        #expect(familyRecordsMap["@F1@"]?.associations[0].citations[1].page == "2")
        
        #expect(familyRecordsMap["@F1@"]?.associations[1].xref == "@VOID@")
        #expect(familyRecordsMap["@F1@"]?.associations[1].role?.kind == .CLERGY)
        
        #expect(familyRecordsMap["@F1@"]?.submitters[0] == "@U1@")
        #expect(familyRecordsMap["@F1@"]?.submitters[1] == "@U2@")
        #expect(familyRecordsMap["@F1@"]?.submitters[2] == "@VOID@")
        
        
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[0].date?.date == "27 MAR 2022")
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[0].date?.time == "15:47")
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[0].date?.phrase == "Afternoon")
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[0].temple == "LOGAN")
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[0].place?.place == ["Place"])
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[0].status?.kind == .COMPLETED)
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[0].status?.date.date == "27 MAR 2022")
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[0].status?.date.time == "15:48")
        switch familyRecordsMap["@F1@"]?.ldsSpouseSealings[0].notes[0] {
        case .note(let n):
            #expect(n.text == "Note text")
        default:
            Issue.record("bad lds spouse sealing note")
        }
        switch familyRecordsMap["@F1@"]?.ldsSpouseSealings[0].notes[1] {
        case .sNote(let n):
            #expect(n.xref == "@N1@")
        default:
            Issue.record("bad lds spouse sealing note")
        }
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[0].citations[0].xref == "@S1@")
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[0].citations[0].page == "1")
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[0].citations[1].xref == "@S2@")
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[0].citations[1].page == "2")
        
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[1].date?.date == "27 MAR 2022")
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[1].status?.kind == .CANCELED)
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[1].status?.date.date == "27 MAR 2022")
        
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[2].date?.date == "27 MAR 2022")
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[2].status?.kind == .EXCLUDED)
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[2].status?.date.date == "27 MAR 2022")
        
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[3].date?.date == "27 MAR 2022")
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[3].status?.kind == .DNS)
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[3].status?.date.date == "27 MAR 2022")
        
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[4].date?.date == "27 MAR 2022")
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[4].status?.kind == .DNS_CAN)
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[4].status?.date.date == "27 MAR 2022")
        
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[5].date?.date == "27 MAR 2022")
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[5].status?.kind == .PRE_1970)
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[5].status?.date.date == "27 MAR 2022")
        
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[6].date?.date == "27 MAR 2022")
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[6].status?.kind == .UNCLEARED)
        #expect(familyRecordsMap["@F1@"]?.ldsSpouseSealings[6].status?.date.date == "27 MAR 2022")
        
        switch (familyRecordsMap["@F1@"]!.identifiers[0]) {
        case .Refn(let refn):
            #expect(refn.refn == "1")
            #expect(refn.type == "User-generated identifier")
        default:
            Issue.record("unexpected identifier type")
        }
        switch (familyRecordsMap["@F1@"]!.identifiers[1]) {
        case .Refn(let refn):
            #expect(refn.refn == "10")
            #expect(refn.type == "User-generated identifier")
        default:
            Issue.record("unexpected identifier type")
        }
        switch (familyRecordsMap["@F1@"]!.identifiers[2]) {
        case .Uuid(let uid):
            #expect(uid.uid == UUID(uuidString: "f096b664-5e40-40e2-bb72-c1664a46fe45")!)
        default:
            Issue.record("unexpected identifier type")
        }
        switch (familyRecordsMap["@F1@"]!.identifiers[3]) {
        case .Uuid(let uid):
            #expect(uid.uid == UUID(uuidString: "1f76f868-8a36-449c-af0d-a29247b3ab50")!)
        default:
            Issue.record("unexpected identifier type")
        }
        switch (familyRecordsMap["@F1@"]!.identifiers[4]) {
        case .Exid(let exid):
            #expect(exid.exid == "123")
            #expect(exid.type == "http://example.com")
        default:
            Issue.record("unexpected identifier type")
        }
        switch (familyRecordsMap["@F1@"]!.identifiers[5]) {
        case .Exid(let exid):
            #expect(exid.exid == "456")
            #expect(exid.type == "http://example.com")
        default:
            Issue.record("unexpected identifier type")
        }
        
        
        switch (familyRecordsMap["@F1@"]!.notes[0]) {
        case .note(let n):
            #expect(n.text == "Note text")
        default:
            Issue.record("unexpected family note")
        }
        switch (familyRecordsMap["@F1@"]!.notes[1]) {
        case .sNote(let n):
            #expect(n.xref == "@N1@")
        default:
            Issue.record("unexpected family note")
        }
        
        #expect(familyRecordsMap["@F1@"]?.citations[0].xref == "@S1@")
        #expect(familyRecordsMap["@F1@"]?.citations[0].page == "1")
        #expect(familyRecordsMap["@F1@"]?.citations[0].quality == 1)
        
        #expect(familyRecordsMap["@F1@"]?.citations[1].xref == "@S2@")
        #expect(familyRecordsMap["@F1@"]?.citations[1].page == "2")
        #expect(familyRecordsMap["@F1@"]?.citations[1].quality == 2)
        
        #expect(familyRecordsMap["@F1@"]?.multimediaLinks[0].xref == "@O1@")
        #expect(familyRecordsMap["@F1@"]?.multimediaLinks[1].xref == "@O2@")
        #expect(familyRecordsMap["@F1@"]?.multimediaLinks[2].xref == "@VOID@")
        #expect(familyRecordsMap["@F1@"]?.multimediaLinks[2].title == "Title")
        
        #expect(familyRecordsMap["@F1@"]?.changeDate?.date.date == "27 MAR 2022")
        #expect(familyRecordsMap["@F1@"]?.changeDate?.date.time == "08:56")
        switch familyRecordsMap["@F1@"]?.changeDate?.notes[0] {
        case .note(let n):
            #expect(n.text == "Change date note 1")
        default:
            Issue.record("unexpected change date note")
        }
        switch familyRecordsMap["@F1@"]?.changeDate?.notes[1] {
        case .note(let n):
            #expect(n.text == "Change date note 2")
        default:
            Issue.record("unexpected change date note")
        }
        #expect(familyRecordsMap["@F1@"]?.creationDate?.date.date == "27 MAR 2022")
        #expect(familyRecordsMap["@F1@"]?.creationDate?.date.time == "08:55")
        
        #expect(familyRecordsMap["@F2@"]?.events[0].kind == .marriage)
        #expect(familyRecordsMap["@F2@"]?.events[0].date?.date == "1998")
        #expect(familyRecordsMap["@F2@"]?.children[0].xref == "@I1@")
    }
}
