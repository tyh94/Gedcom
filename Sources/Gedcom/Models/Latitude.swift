//
//  Latitude.swift
//  FamilyBook
//
//  Created by Татьяна Макеева on 16.12.2025.
//

public struct Latitude {
    public var degrees: Double
    public var direction: Direction
    
    public enum Direction: String {
        case north = "N"
        case south = "S"
    }
    
    public init(degrees: Double) {
        self.degrees = abs(degrees)
        self.direction = degrees >= 0 ? .north : .south
    }
    
    public init(_ string: String) throws {
        guard !string.isEmpty else {
            throw GedcomError.invalidCoordinate("Empty latitude string")
        }
        
        let directionChar = string.prefix(1).uppercased()
        let valueString = String(string.dropFirst())
        
        guard let direction = Direction(rawValue: directionChar),
              let degrees = Double(valueString) else {
            throw GedcomError.invalidCoordinate("Invalid latitude format: \(string)")
        }
        
        self.degrees = degrees
        self.direction = direction
    }
    
    var decimalDegrees: Double {
        switch direction {
        case .north: return degrees
        case .south: return -degrees
        }
    }
    
    var stringValue: String {
        "\(direction.rawValue)\(degrees)"
    }
}
