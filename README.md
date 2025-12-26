# GEDCOM swift

This is a library to support the import and export of GEDCOM files in Swift.

## Test Cases

Test files have been taken here:
https://gedcom.io/tools/#example-familysearch-gedcom-70-files

## Usage

```swift
import Gedcom

let parser = GedcomParser()
let file = try parser.parse(withFile: filePath)

```

```swift
import Gedcom

let exporter = GedcomExporter()
let content = exporter.exportContent(gedcom: gedcomFile)

```

## Use with archive

```swift
import Gedcom

let path: URL // path to acrive
let archive = try Archive(url: path, accessMode: .read, pathEncoding: nil)

guard let archive = archive else {
  throw GedcomError.badArchive
}
guard let entry = archive["gedcom.ged"] else {
  throw GedcomError.missingManifest
}

var data = Data()
try _ = archive.extract(entry) { data in
  data.append(data)
}

let parser = GedcomParser()
let file = try parser.parse(withData: data)

```

```swift
import Gedcom
import ZIPFoundation

let path: URL // path to created acrive
let exporter = GedcomExporter()
let content = exporter.exportContent(gedcom: gedcomFile)
let data = content.data(using: encoding)!

let archive = try Archive(url: path, accessMode: .create)

try archive.addEntry(with: "gedcom.ged", type: .file, uncompressedSize: Int64(data.count), bufferSize: 4, provider: { (position, size) -> Data indata.subdata(in: Data.Index(position)..<Int(position)+size)
})

```
