//
//  Record.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

class Record {
    var line: Line
    var children: [Record] = []
    
    init?(string: String) {
        let line = Line(string)
        guard let line else { return nil }
        self.line = line
    }
    
    init(line: Line) {
        self.line = line
    }
    
    init(level: Int, xref: String? = nil, tag: String, value: String? = nil) {
        let line = Line(level: level, xref: xref, tag: tag, value: value)
        self.line = line
    }
    
    func setLevel(_ level: Int) {
        line.level = level
        for child in children {
            child.setLevel(level + 1)
        }
    }
    
    func export() -> String {
        var string = line.export()
        for child in children {
            string += child.export()
        }
        return string
    }
}
