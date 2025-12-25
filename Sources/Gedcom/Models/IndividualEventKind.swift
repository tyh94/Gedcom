//
//  IndividualEventKind.swift
//  Gedcom
//
//  Created by Татьяна Макеева on 12.12.2025.
//

import Foundation

public enum IndividualEventKind: String {
    /// Creation of a legally approved child-parent relationship that does not exist biologically.
    case adoption = "ADOP"
    /// Baptism, performed in infancy or later.
    case baptism = "BAPM"
    /// The ceremonial event held when a Jewish boy reaches age 13.
    case barMitzvah = "BARM"
    /// The ceremonial event held when a Jewish girl reaches age 13, also known as “Bat Mitzvah.”
    case basMitzvah = "BASM"
    /// Entering into life.
    case birth = "BIRT"
    /// Bestowing divine care or intercession. Sometimes given in connection with a naming ceremony.
    case blessing = "BLES"
    /// Depositing the mortal remains of a deceased person.
    case burial = "BURI"
    /// Periodic count of the population for a designated locality, such as a national or state census.
    case census = "CENS"
    /// Baptism or naming events for a child.
    case christening = "CHR"
    /// Baptism or naming events for an adult person.
    case adultChristening = "CHRA"
    /// Conferring full church membership.
    case confirmation = "CONF"
    /// The act of reducing a dead body to ashes by fire.
    case cremation = "CREM"
    /// Mortal life terminates.
    case death = "DEAT"
    /// Leaving one’s homeland with the intent of residing elsewhere.
    case emigration = "EMIG"
    /// The first act of sharing in the Lord’s supper as part of church worship.
    case firstCommunion = "FCOM"
    /// Awarding educational diplomas or degrees to individuals.
    case graduation = "GRAD"
    /// Entering into a new locality with the intent of residing there.
    case immigration = "IMMI"
    /// Obtaining citizenship.
    case naturalization = "NATU"
    /// Receiving authority to act in religious matters.
    case ordination = "ORDN"
    /// Judicial determination of the validity of a will. It may indicate several related court activities over several dates.
    case probate = "PROB"
    /// Exiting an occupational relationship with an employer after a qualifying time period.
    case retirement = "RETI"
    /// A legal document treated as an event, by which a person disposes of his or her estate. It takes effect after death. The event date is the date the will was signed while the person was alive.
    case will = "WILL"
    /// generic individual event. It must have a TYPE substructure to define what kind of event is being provided
    case even = "EVEN"
}
