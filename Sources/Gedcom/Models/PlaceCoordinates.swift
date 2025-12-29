//
//  PlaceCoordinates.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class PlaceCoordinates: RecordProtocol {
    public var latitude: Latitude = Latitude(degrees: 0)
    public var longitude: Longitude = Longitude(degrees: 0)
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "LATI": \PlaceCoordinates.latitude,
        "LONG": \PlaceCoordinates.longitude,
    ]
    
    public init(latitude: Latitude, longitude: Longitude) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public init(lat: Double, lon: Double) {
        self.latitude = Latitude(degrees: lat)
        self.longitude = Longitude(degrees: lon)
    }
    
    required init(record: Record) throws {
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "MAP")
        record.children.append(
            Record(level: 1, tag: "LATI", value: latitude.stringValue)
        )
        record.children.append(
            Record(level: 1, tag: "LONG", value: longitude.stringValue)
        )
        return record
    }
}

extension PlaceCoordinates {
    var lat: Double {
        latitude.degrees
    }
    
    var lon: Double {
        longitude.degrees
    }
}
