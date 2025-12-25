//
//  Schema.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 16.12.2025.
//

import Foundation

public class Schema: RecordProtocol {
    public var tags: [String: URL] = [:]
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "TAG" : \Schema.tags,
    ]
    
    init() {}
    
    required init(record: Record) throws {
        var mutableSelf = self
        
        for child in record.children {
            guard let kp = Self.keys[child.line.tag] else {
                //  throw GedcomError.badRecord
                continue
            }
            
            if let wkp = kp as? WritableKeyPath<Schema, [String: URL]> {
                let keyValue = child.line.value?.components(separatedBy: " ").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)}) ?? []
                guard keyValue.count == 2 else {
                    throw GedcomError.badSchema
                }
                guard let url = URL(string: keyValue[1]) else {
                    throw GedcomError.badSchema
                }
                guard !mutableSelf[keyPath: wkp].keys.contains(keyValue[0]) else {
                    throw GedcomError.badSchema
                }
                guard keyValue[0].starts(with: "_") else {
                    throw GedcomError.badSchema
                }
                mutableSelf[keyPath: wkp][keyValue[0]] = url
            }
        }
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "SCHMA")
        for key in tags.keys.sorted() {
            record.children.append(Record(level: 1, tag: "TAG", value: key + " " + tags[key]!.absoluteString))
        }
        return record
    }
}
