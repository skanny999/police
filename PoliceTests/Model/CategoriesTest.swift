//
//  CategoriesTest.swift
//  PoliceTests
//
//  Created by Riccardo on 29/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import XCTest
@testable import Police

class CategoriesTest: XCTestCase {
    
    func testCrimeCategory() {
        
        XCTAssertTrue(CrimeCategory.allCrime.rawValue == "all-crime")
        XCTAssertTrue(CrimeCategory.antiSocialBehaviour.rawValue == "anti-social-behaviour")
        XCTAssertTrue(CrimeCategory.bicicleTheft.rawValue == "bicycle-theft")
        XCTAssertTrue(CrimeCategory.burglary.rawValue == "burglary")
        XCTAssertTrue(CrimeCategory.arson.rawValue == "criminal-damage-arson")
        XCTAssertTrue(CrimeCategory.drugs.rawValue == "drugs")
        XCTAssertTrue(CrimeCategory.otherTheft.rawValue == "other-theft")
        XCTAssertTrue(CrimeCategory.weapon.rawValue == "possession-of-weapons")
        XCTAssertTrue(CrimeCategory.publicOder.rawValue == "public-order")
        XCTAssertTrue(CrimeCategory.robbery.rawValue == "robbery")
        XCTAssertTrue(CrimeCategory.shoplifting.rawValue == "shoplifting")
        XCTAssertTrue(CrimeCategory.theftFromPerson.rawValue == "theft-from-the-person")
        XCTAssertTrue(CrimeCategory.vehicle.rawValue == "vehicle-crime")
        XCTAssertTrue(CrimeCategory.violent.rawValue == "violent-crime")
        XCTAssertTrue(CrimeCategory.other.rawValue == "other-crime")
        
        XCTAssertTrue(CrimeCategory.allCrime.description == "All crime")
        XCTAssertTrue(CrimeCategory.antiSocialBehaviour.description == "Anti-social behaviour")
        XCTAssertTrue(CrimeCategory.bicicleTheft.description == "Bicycle theft")
        XCTAssertTrue(CrimeCategory.burglary.description == "Burglary")
        XCTAssertTrue(CrimeCategory.arson.description == "Criminal damage and arson")
        XCTAssertTrue(CrimeCategory.drugs.description == "Drugs")
        XCTAssertTrue(CrimeCategory.otherTheft.description == "Other theft")
        XCTAssertTrue(CrimeCategory.weapon.description == "Possession of weapons")
        XCTAssertTrue(CrimeCategory.publicOder.description == "Public order")
        XCTAssertTrue(CrimeCategory.robbery.description == "Robbery")
        XCTAssertTrue(CrimeCategory.shoplifting.description == "Shoplifting")
        XCTAssertTrue(CrimeCategory.theftFromPerson.description == "Theft from the person")
        XCTAssertTrue(CrimeCategory.vehicle.description == "Vehicle crime")
        XCTAssertTrue(CrimeCategory.violent.description == "Violence and sexual offences")
        XCTAssertTrue(CrimeCategory.other.description == "Other crime")
    }

    func testOutcomeCategoryCategory() {
        
        XCTAssertTrue(OutcomeCategory.awaiting.rawValue == "awaiting-court-result")
        XCTAssertTrue(OutcomeCategory.resultUnavailable.rawValue == "court-result-unavailable")
        XCTAssertTrue(OutcomeCategory.unableToProceed.rawValue == "unable-to-proceed")
        XCTAssertTrue(OutcomeCategory.localResolution.rawValue == "local-resolution")
        XCTAssertTrue(OutcomeCategory.noFurtheAction.rawValue == "no-further-action")
        XCTAssertTrue(OutcomeCategory.deprivedOfProperty.rawValue == "deprived-of-property")
        XCTAssertTrue(OutcomeCategory.fined.rawValue == "fined")
        XCTAssertTrue(OutcomeCategory.absoluteDischarged.rawValue == "absolute-discharge")
        XCTAssertTrue(OutcomeCategory.cautioned.rawValue == "cautioned")
        XCTAssertTrue(OutcomeCategory.drugPossessionWarning.rawValue == "drugs-possession-warning")
        XCTAssertTrue(OutcomeCategory.penaltNoticeIssued.rawValue == "penalty-notice-issued")
        XCTAssertTrue(OutcomeCategory.communityPenalty.rawValue == "community-penalty")
        XCTAssertTrue(OutcomeCategory.conditionalDischarge.rawValue == "conditional-discharge")
        XCTAssertTrue(OutcomeCategory.suspendedSentence.rawValue == "suspended-sentence")
        XCTAssertTrue(OutcomeCategory.imprisoned.rawValue == "imprisoned")
        XCTAssertTrue(OutcomeCategory.otherCourtDisposal.rawValue == "other-court-disposal")
        XCTAssertTrue(OutcomeCategory.compensation.rawValue == "compensation")
        XCTAssertTrue(OutcomeCategory.sentencedInAnotherCase.rawValue == "sentenced-in-another-case")
        XCTAssertTrue(OutcomeCategory.charged.rawValue == "charged")
        XCTAssertTrue(OutcomeCategory.notGuilty.rawValue == "not-guilty")
        XCTAssertTrue(OutcomeCategory.sentToCrownCourt.rawValue == "sent-to-crown-court")
        XCTAssertTrue(OutcomeCategory.unableToPersecute.rawValue == "unable-to-prosecute")
        XCTAssertTrue(OutcomeCategory.formalActionNotInPublicInterest.rawValue == "formal-action-not-in-public-interest")
        XCTAssertTrue(OutcomeCategory.actionTakenByAnotherInvestigation.rawValue == "action-taken-by-another-organisation")
        XCTAssertTrue(OutcomeCategory.furtherInvestigationNotInPublicInterest.rawValue == "further-investigation-not-in-public-interest")
        XCTAssertTrue(OutcomeCategory.underInvestigation.rawValue == "under-investigation")
        XCTAssertTrue(OutcomeCategory.statusUnavailable.rawValue == "status-update-unavailable")

        XCTAssertTrue(OutcomeCategory.awaiting.description == "Awaiting court outcome")
        XCTAssertTrue(OutcomeCategory.resultUnavailable.description == "Court result unavailable")
        XCTAssertTrue(OutcomeCategory.unableToProceed.description == "Court case unable to proceed")
        XCTAssertTrue(OutcomeCategory.localResolution.description == "Local resolution")
        XCTAssertTrue(OutcomeCategory.noFurtheAction.description == "Investigation complete; no suspect identified")
        XCTAssertTrue(OutcomeCategory.deprivedOfProperty.description == "Offender deprived of property")
        XCTAssertTrue(OutcomeCategory.fined.description == "Offender fined")
        XCTAssertTrue(OutcomeCategory.absoluteDischarged.description == "Offender given absolute discharge")
        XCTAssertTrue(OutcomeCategory.cautioned.description == "Offender given a caution")
        XCTAssertTrue(OutcomeCategory.drugPossessionWarning.description == "Offender given a drugs possession warning")
        XCTAssertTrue(OutcomeCategory.penaltNoticeIssued.description == "Offender given a penalty notice")
        XCTAssertTrue(OutcomeCategory.communityPenalty.description == "Offender given community sentence")
        XCTAssertTrue(OutcomeCategory.conditionalDischarge.description == "Offender given conditional discharge")
        XCTAssertTrue(OutcomeCategory.suspendedSentence.description == "Offender given suspended prison sentence")
        XCTAssertTrue(OutcomeCategory.imprisoned.description == "Offender sent to prison")
        XCTAssertTrue(OutcomeCategory.otherCourtDisposal.description == "Offender otherwise dealt with")
        XCTAssertTrue(OutcomeCategory.compensation.description == "Offender ordered to pay compensation")
        XCTAssertTrue(OutcomeCategory.sentencedInAnotherCase.description == "Suspect charged as part of another case")
        XCTAssertTrue(OutcomeCategory.charged.description == "Suspect charged")
        XCTAssertTrue(OutcomeCategory.notGuilty.description == "Defendant found not guilty")
        XCTAssertTrue(OutcomeCategory.sentToCrownCourt.description == "Defendant sent to Crown Court")
        XCTAssertTrue(OutcomeCategory.unableToPersecute.description == "Unable to prosecute suspect")
        XCTAssertTrue(OutcomeCategory.formalActionNotInPublicInterest.description == "Formal action is not in the public interest")
        XCTAssertTrue(OutcomeCategory.actionTakenByAnotherInvestigation.description == "Action to be taken by another organisation")
        XCTAssertTrue(OutcomeCategory.furtherInvestigationNotInPublicInterest.description == "Further investigation is not in the public interest")
        XCTAssertTrue(OutcomeCategory.underInvestigation.description == "Under investigation")
        XCTAssertTrue(OutcomeCategory.statusUnavailable.description == "Status update unavailable")

    }

}
