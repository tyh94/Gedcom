//
//  MultimediaLink.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class MultimediaLink: RecordProtocol {
    public var xref: String
    public var crop: Crop?
    public var title: String?
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "CROP" : \MultimediaLink.crop,
        "TITL" : \MultimediaLink.title
    ]
    
    public init(
        xref: String,
        crop: Crop? = nil,
        title: String? = nil
    ) {
        self.xref = xref
        self.crop = crop
        self.title = title
    }
    
    required init(record: Record) throws {
        self.xref = record.line.value!
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "OBJE", value: xref)
        
        if let crop {
            record.children.append(crop.export())
        }
        if let title {
            record.children.append(Record(level: 1, tag: "TITL", value: title))
        }
        
        return record
    }
}
