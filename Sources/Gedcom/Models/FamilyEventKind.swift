//
//  FamilyEventKind.swift
//  FamilyBook
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public enum FamilyEventKind: String {
    /// Declaring a marriage void from the beginning (never existed).
    case annulment = "ANUL"
    /// Periodic count of the population for a designated locality, such
    /// as a national or state census.
    case census = "CENS"
    /// Dissolving a marriage through civil action.
    case divorce = "DIV"
    /// Filing for a divorce by a spouse.
    case divorceFiled = "DIVF"
    /// Recording or announcing an agreement between 2 people to
    /// become married.
    case engagement = "ENGA"
    /// Official public notice given that 2 people intend to marry.
    case marriageBann = "MARB"
    /// Recording a formal agreement of marriage, including the
    /// prenuptial agreement in which marriage partners reach
    /// agreement about the property rights of 1 or both, securing
    /// property to their children.
    case marriageContract = "MARC"
    /// Obtaining a legal license to marry.
    case marriageLicense = "MARL"
    /// A legal, common-law, or customary event such as a wedding
    /// or marriage ceremony that joins 2 partners to create or extend
    /// a family unit.
    case marriage = "MARR"
    /// Creating an agreement between 2 people contemplating
    /// marriage, at which time they agree to release or modify
    /// property rights that would otherwise arise from the marriage.
    case marriageSettlement = "MARS"
    /// a generic family event. It must have a TYPE substructure to define what kind of event is being provided.
    case even = "EVEN"
}
