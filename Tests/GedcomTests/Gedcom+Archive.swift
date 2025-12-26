//
//  Gedcom+Archive.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 26.12.2025.
//

@testable import Gedcom
import Foundation
import ZIPFoundation

extension GedcomParser {
    public func parse(
        withArchive path: URL,
        encoding: String.Encoding = .utf8
    ) throws -> GedcomFile {
        let archive = try Archive(url: path, accessMode: .read, pathEncoding: nil)
        var gedcomEntry: Entry?
        for entry in archive {
            if entry.path.hasSuffix(".ged") {
                gedcomEntry = entry
                break
            }
        }
        
        guard let entry = gedcomEntry else {
            throw GedcomError.missingManifest
        }
        var data = Data()
        try _ = archive.extract(entry) {
          data.append($0)
        }
        return try parse(withData: data, encoding: encoding)
    }
}
