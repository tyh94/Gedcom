//
//  SNoteRef.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class SNoteRef: RecordProtocol {
    public var xref: String
    
    required convenience init(record: Record) throws {
        self.init(xref: record.line.value!)
    }
    
    public init(xref: String) {
        self.xref = xref
    }
    
    func export() -> Record {
        Record(level: 0, tag: "SNOTE", value: xref)
    }
}
