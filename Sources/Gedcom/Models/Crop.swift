//
//  Crop.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class Crop: RecordProtocol {
    public var top: Int?
    public var left: Int?
    public var height: Int?
    public var width: Int?
    nonisolated(unsafe) static let keys :[String: AnyKeyPath] = [
        "TOP": \Crop.top,
        "LEFT": \Crop.left,
        "HEIGHT": \Crop.height,
        "WIDTH": \Crop.width,
    ]
    
   public init(
        top: Int? = nil,
        left: Int? = nil,
        height: Int? = nil,
        width: Int? = nil
    ) {
        self.top = top
        self.left = left
        self.height = height
        self.width = width
    }
    
    required init(record: Record) throws {
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, tag: "CROP")
        
        if let top {
            record.children.append(Record(level: 1, tag: "TOP", value: "\(top)"))
        }
        if let left {
            record.children.append(Record(level: 1, tag: "LEFT", value: "\(left)"))
        }
        if let height {
            record.children.append(Record(level: 1, tag: "HEIGHT", value: "\(height)"))
        }
        if let width {
            record.children.append(Record(level: 1, tag: "WIDTH", value: "\(width)"))
        }
        
        return record
    }
}
