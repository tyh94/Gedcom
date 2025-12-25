//
//  SourceDataEvents.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class SourceDataEvents: RecordProtocol {
    public var eventTypes: [String] = []
    public var period: SourceDataEventPeriod?
    public var place: PlaceStructure?
    nonisolated(unsafe) static let keys : [String: AnyKeyPath] = [
        "DATE": \SourceDataEvents.period,
        "PLAC": \SourceDataEvents.place,
    ]
    
    init(types: [String]) {
        eventTypes = types
    }
    required init(record: Record) throws {
        self.eventTypes = (record.line.value ?? "")
            .components(separatedBy: ",")
            .map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "EVEN", value: eventTypes.joined(separator: ", "))
        
        if let period {
            record.children += [period.export()]
        }
        if let place {
            record.children += [place.export()]
        }
        
        return record
    }
}
