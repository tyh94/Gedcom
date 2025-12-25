//
//  RoundtripTest.swift
//  Gedcom
//
//  Created by Mattias Holm on 2025-05-18.
//

import Testing
import Foundation
@testable import Gedcom

@Suite("Round Trip Test") struct RoundtripTest {
    @Test func testRoundtripMinFile() async throws {
        let parser = GedcomParser()
        let exporter = GedcomExporter()
        let module = Bundle.module
        guard
            let resourceURL = module.url(forResource: "Gedcom7/minimal70",
                                         withExtension: "ged") else {
            Issue.record("Resource 'Gedcom7/minimal70.ged' not found in bundle")
            return
        }
        
        let ged = try parser.parse(withFile: resourceURL)
        
        let fileData = try Data(contentsOf: resourceURL)
        let fileContent = String(data: fileData, encoding: .utf8)
        
        let result = exporter.exportContent(gedcom: ged)
        
        #expect(fileContent == result)
    }
}
