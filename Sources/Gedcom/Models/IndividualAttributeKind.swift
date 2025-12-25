//
//  IndividualAttributeKind.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

public enum IndividualAttributeKind : String {
    /// The name of an individual’s rank or status in society which is
    /// sometimes based on racial or religious differences, or
    /// differences in wealth, inherited rank, profession, or
    /// occupation.
    case caste = "CAST"
    /// The physical characteristics of a person.
    case physicalDescription = "DSCR"
    /// Indicator of a level of education attained.
    case education = "EDUC"
    /// A number or other string assigned to identify a person within
    /// some significant external system. It must have a TYPE
    /// substructure to define what kind of identification number is
    /// being provided.
    case identifyingNumber = "IDNO"
    /// An individual’s national heritage or origin, or other folk,
    /// house, kindred, lineage, or tribal interest.
    case nationality = "NATI"
    /// The number of children that this person is known to be the
    /// parent of (all marriages).
    case numberOfChildren = "NCHI"
    /// The number of times this person has participated in a family
    /// as a spouse or parent.
    case numberOfMarriages = "NMR"
    /// The type of work or profession of an individual.
    case occupation = "OCCU"
    /// Pertaining to possessions such as real estate or other
    /// property of interest.
    case property = "PROP"
    /// A religious denomination to which a person is affiliated or
    /// for which a record applies.
    case religion = "RELI"
    /// An address or place of residence where an individual
    /// resided.
    case residence = "RESI"
    /// A number assigned by the United States Social Security
    /// Administration, used for tax identification purposes. It is a
    /// type of IDNO.
    case socialSecurityNumber = "SSN"
    /// A formal designation used by an individual in connection
    /// with positions of royalty or other social status, such as Grand
    /// Duke.
    case title = "TITL"
    /// is a structure for a generic individual attribute. It must have a TYPE
    ///  substructure to define what kind of attribute is being provided.
    case fact = "FACT"
}
