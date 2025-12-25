//
//  Longitude.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 16.12.2025.
//

public struct Longitude {
    public var degrees: Double
    public var direction: Direction
    
    public enum Direction: String {
        case east = "E"
        case west = "W"
    }
    
    public init(degrees: Double) {
        self.degrees = abs(degrees)
        self.direction = degrees >= 0 ? .east : .west
    }
    
    public init(_ string: String) throws {
        guard !string.isEmpty else {
            throw GedcomError.invalidCoordinate("Empty longitude string")
        }
        
        let directionChar = string.prefix(1).uppercased()
        let valueString = String(string.dropFirst())
        
        guard let direction = Direction(rawValue: directionChar),
              let degrees = Double(valueString) else {
            throw GedcomError.invalidCoordinate("Invalid longitude format: \(string)")
        }
        
        self.degrees = degrees
        self.direction = direction
    }
    
    var decimalDegrees: Double {
        switch direction {
        case .east: return degrees
        case .west: return -degrees
        }
    }
    
    var stringValue: String {
        "\(direction.rawValue)\(degrees)"
    }
}
