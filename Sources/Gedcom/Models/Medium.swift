//
//  Medium.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class Medium: RecordProtocol {
    public var kind: MediumKind
    public var phrase: String?
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "PHRASE": \Medium.phrase,
    ]
    
    public init(
        kind: MediumKind,
        phrase: String? = nil
    ) {
        self.kind = kind
        self.phrase = phrase
    }
    
    required init(record: Record) throws {
        kind = MediumKind(rawValue: record.line.value ?? "OTHER") ?? .OTHER
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "MEDI", value: kind.rawValue)
        if let phrase = phrase {
            record.children += [Record(level: 1, tag: "PHRASE", value: phrase)]
        }
        return record
    }
}
