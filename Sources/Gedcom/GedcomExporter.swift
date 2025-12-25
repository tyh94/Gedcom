//
//  GedcomExporter.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 17.12.2025.
//

import Foundation

public final class GedcomExporter: Sendable {
    enum Error: Swift.Error {
        case noData
    }
    
    public init() {}
    
    public func exportContent(gedcom: GedcomFile) -> String {
        let record = gedcom.export()
        let records = record.children
        
        var result = ""
        for record in records {
            result += record.export()
        }
        
        return result
    }
    
    public func exportContent(
        gedcom: GedcomFile,
        encoding: String.Encoding = .utf8
    ) throws -> Data {
        let content: String = exportContent(gedcom: gedcom)
        
        guard let data = content.data(using: encoding) else {
            throw Error.noData
        }
        return data
    }
    
    public func export(
        gedcom: GedcomFile,
        file path: URL,
        encoding: String.Encoding = .utf8
    ) throws {
        let data = try exportContent(gedcom: gedcom, encoding: encoding)
        try data.write(to: path)
    }
}
