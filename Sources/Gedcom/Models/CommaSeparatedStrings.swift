//
//  CommaSeparatedStrings.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 16.12.2025.
//

import Foundation

public struct CommaSeparatedStrings: Equatable {
    public var values: [String]
    
    public init(_ string: String) {
        self.values = string
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
    
    public init(_ array: [String]) {
        self.values = array
    }
    
    public var stringValue: String {
        values.joined(separator: ", ")
    }
}

extension CommaSeparatedStrings: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension CommaSeparatedStrings: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: String...) {
        self.values = elements
    }
}
