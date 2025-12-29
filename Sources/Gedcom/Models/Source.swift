//
//  Source.swift
//  FamilyBook
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public class Source: RecordProtocol {
    public var xref: String
    public var data: SourceData?
    public var author: String?
    public var title: String?
    public var abbreviation: String?
    public var publication: String?
    public var text: SourceText?
    public var sourceRepoCitation: [SourceRepositoryCitation] = []
    
    public var identifiers: [IdentifierStructure] = []
    public var notes: [NoteStructure] = []
    public var multimediaLinks: [MultimediaLink] = []
    public var changeDate: ChangeDate?
    public var creationDate: CreationDate?
    
    nonisolated(unsafe) static let keys: [String: AnyKeyPath] = [
        "DATA": \Source.data,
        "AUTH": \Source.author,
        "TITL": \Source.title,
        "ABBR": \Source.abbreviation,
        "PUBL": \Source.publication,
        "TEXT": \Source.text,
        "REPO": \Source.sourceRepoCitation,
        "REFN": \Source.identifiers,
        "UID": \Source.identifiers,
        "EXID": \Source.identifiers,
        "NOTE": \Source.notes,
        "SNOTE": \Source.notes,
        "OBJE": \Source.multimediaLinks,
        "CHAN": \Source.changeDate,
        "CREA": \Source.creationDate
    ]
    
    public init(
        xref: String,
        data: SourceData? = nil,
        author: String? = nil,
        title: String? = nil,
        abbreviation: String? = nil,
        publication: String? = nil,
        text: SourceText? = nil,
        sourceRepoCitation: [SourceRepositoryCitation]= [],
        identifiers: [IdentifierStructure]= [],
        notes: [NoteStructure]= [],
        multimediaLinks: [MultimediaLink]= [],
        changeDate: ChangeDate? = nil,
        creationDate: CreationDate? = nil
    ) {
        self.xref = xref
        self.data = data
        self.author = author
        self.title = title
        self.abbreviation = abbreviation
        self.publication = publication
        self.text = text
        self.sourceRepoCitation = sourceRepoCitation
        self.identifiers = identifiers
        self.notes = notes
        self.multimediaLinks = multimediaLinks
        self.changeDate = changeDate
        self.creationDate = creationDate
    }
    
    required init(record: Record) throws {
        guard let xref = record.line.xref else {
            throw GedcomError.badRecord
        }
        
        self.xref = xref
        try updateFromRecord(record, keys: Self.keys)
    }
    
    func export() -> Record {
        let record = Record(level: 0, xref: xref, tag: "SOUR")
        
        if let data {
            record.children += [data.export()]
        }
        if let author {
            record.children += [Record(level: 1, tag: "AUTH", value: author)]
        }
        
        if let title {
            record.children += [Record(level: 1, tag: "TITL", value: title)]
        }
        if let abbreviation {
            record.children += [Record(level: 1, tag: "ABBR", value: abbreviation)]
        }
        if let publication {
            record.children += [Record(level: 1, tag: "PUBL", value: publication)]
        }
        
        if let text {
            record.children += [text.export()]
        }
        
        for citation in sourceRepoCitation {
            record.children += [citation.export()]
        }
        for identifier in identifiers {
            record.children += [identifier.export()]
        }
        
        for note in notes {
            record.children += [note.export()]
        }
        
        for multimediaLink in multimediaLinks {
            record.children += [multimediaLink.export()]
        }
        
        if let changeDate {
            record.children += [changeDate.export()]
        }
        if let creationDate {
            record.children += [creationDate.export()]
        }
        
        record.setLevel(0)
        return record
    }
}
