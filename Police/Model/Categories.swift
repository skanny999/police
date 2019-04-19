//
//  Categories.swift
//  Police
//
//  Created by Riccardo on 26/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation
import UIKit

enum CrimeCategory: String, CaseIterable {
    
    case allCrime = "all-crime"
    case antiSocialBehaviour = "anti-social-behaviour"
    case bicicleTheft = "bicycle-theft"
    case burglary = "burglary"
    case arson = "criminal-damage-arson"
    case drugs = "drugs"
    case otherTheft = "other-theft"
    case weapon = "possession-of-weapons"
    case publicOder = "public-order"
    case robbery = "robbery"
    case shoplifting = "shoplifting"
    case theftFromPerson = "theft-from-the-person"
    case vehicle = "vehicle-crime"
    case violent = "violent-crime"
    case other = "other-crime"
    
    var description: String {
        switch self {
        case .allCrime:
            return "All crime"
        case .antiSocialBehaviour:
            return "Anti-social behaviour"
        case .bicicleTheft:
            return "Bicycle theft"
        case .burglary:
            return "Burglary"
        case .arson:
            return "Criminal damage and arson"
        case .drugs:
            return "Drugs"
        case .otherTheft:
            return "Other theft"
        case .weapon:
            return "Possession of weapons"
        case .publicOder:
            return "Public order"
        case .robbery:
            return "Robbery"
        case .shoplifting:
            return "Shoplifting"
        case .theftFromPerson:
            return "Theft from the person"
        case .vehicle:
            return "Vehicle crime"
        case .violent:
            return "Violence and sexual offences"
        case .other:
            return "Other crime"
        }
    }
    
    var image: UIImage {
        return UIImage(named: "crime-selected")!
    }
    
    var gravity: CrimeGravity {
        
        switch self {
        case .antiSocialBehaviour, .drugs, .publicOder, .shoplifting, .vehicle, .other:
            return .medium
        case .burglary, .arson, .bicicleTheft, .theftFromPerson, .otherTheft:
            return .bad
        case .allCrime, .violent, .weapon, .robbery:
            return .veryBad
        }
    }
    
    var colour: UIColor {
        switch self.gravity {
        case .medium:
            return UIColor(red: 250/255, green: 220/255, blue: 85/255, alpha: 1)
        case .bad:
            return .orange
        case .veryBad:
            return .red
        }
    }
}

enum CrimeGravity {
    case medium, bad, veryBad
}

enum OutcomeCategory: String, CaseIterable {
    
    case awaiting = "awaiting-court-result"
    case resultUnavailable = "court-result-unavailable"
    case unableToProceed = "unable-to-proceed"
    case localResolution = "local-resolution"
    case noFurtheAction = "no-further-action"
    case deprivedOfProperty = "deprived-of-property"
    case fined = "fined"
    case absoluteDischarged = "absolute-discharge"
    case cautioned = "cautioned"
    case drugPossessionWarning = "drugs-possession-warning"
    case penaltNoticeIssued = "penalty-notice-issued"
    case communityPenalty = "community-penalty"
    case conditionalDischarge = "conditional-discharge"
    case suspendedSentence = "suspended-sentence"
    case imprisoned = "imprisoned"
    case otherCourtDisposal = "other-court-disposal"
    case compensation = "compensation"
    case sentencedInAnotherCase = "sentenced-in-another-case"
    case charged = "charged"
    case notGuilty = "not-guilty"
    case sentToCrownCourt = "sent-to-crown-court"
    case unableToPersecute = "unable-to-prosecute"
    case formalActionNotInPublicInterest = "formal-action-not-in-public-interest"
    case actionTakenByAnotherInvestigation = "action-taken-by-another-organisation"
    case furtherInvestigationNotInPublicInterest = "further-investigation-not-in-public-interest"
    case underInvestigation = "under-investigation"
    case statusUnavailable = "status-update-unavailable"
    
    var description: String {
        
        switch self {
        case .awaiting:
            return "Awaiting court outcome"
        case .resultUnavailable:
            return "Court result unavailable"
        case .unableToProceed:
            return "Court case unable to proceed"
        case .localResolution:
            return "Local resolution"
        case .noFurtheAction:
            return "Investigation complete; no suspect identified"
        case .deprivedOfProperty:
            return "Offender deprived of property"
        case .fined:
            return "Offender fined"
        case .absoluteDischarged:
            return "Offender given absolute discharge"
        case .cautioned:
            return "Offender given a caution"
        case .drugPossessionWarning:
            return "Offender given a drugs possession warning"
        case .penaltNoticeIssued:
            return "Offender given a penalty notice"
        case .communityPenalty:
            return "Offender given community sentence"
        case .conditionalDischarge:
            return "Offender given conditional discharge"
        case .suspendedSentence:
            return "Offender given suspended prison sentence"
        case .imprisoned:
            return "Offender sent to prison"
        case .otherCourtDisposal:
            return "Offender otherwise dealt with"
        case .compensation:
            return "Offender ordered to pay compensation"
        case .sentencedInAnotherCase:
            return "Suspect charged as part of another case"
        case .charged:
            return "Suspect charged"
        case .notGuilty:
            return "Defendant found not guilty"
        case .sentToCrownCourt:
            return "Defendant sent to Crown Court"
        case .unableToPersecute:
            return "Unable to prosecute suspect"
        case .formalActionNotInPublicInterest:
            return "Formal action is not in the public interest"
        case .actionTakenByAnotherInvestigation:
            return "Action to be taken by another organisation"
        case .furtherInvestigationNotInPublicInterest:
            return "Further investigation is not in the public interest"
        case .underInvestigation:
            return "Under investigation"
        case .statusUnavailable:
            return "Status update unavailable"
        }
    }
}

enum stopAndSearchCrimeCategory: String {
    
    case theft = "Article for use in theft"
    case damage = "Articles for use in criminal damage"
    case drugs = "Controlled drugs"
    case firearms = "Firearms"
    case weapon = "Offensive weapons"
    case stolenGoods = "Stolen goods"
    case generalOffence = "Evidence of offences under the Act"
    case threat = "Anything to threaten or harm anyone"
    case firework = "Fireworks"
    
    var image: UIImage {
        return UIImage(named: "crime-selected")!
    }
    
}

enum StopAndSearchOutcomeCategory: String {
    
    case arrest = "Arrest"
    case caution = "Caution (simple or conditional)"
    case community = "Community resolution"
    case penalty = "Penalty Notice for Disorder"
    case summon = "Summons / charged by post"
    case noFurtherAction = "A no further action disposal"
    
    var colour: UIColor {
        switch self {
        case .arrest:
            return .red
        case .caution, .community, .penalty, .summon:
            return .orange
        case .noFurtherAction:
            return UIColor(red: 255/255, green: 254/255, blue: 244/255, alpha: 1)
        }
    }
}

enum Etnicity: String {
    
    case asianOther = "Asian/Asian British - Any other Asian background"
    case asianBangladeshi = "Asian/Asian British - Bangladeshi"
    case asianChinese = "Asian/Asian British - Chinese"
    case asianIndian = "Asian/Asian British - Indian"
    case asianPakistani = "Asian/Asian British - Pakistani"
    case blackAfrican = "Black/African/Caribbean/Black British - African"
    case blackOther = "Black/African/Caribbean/Black British - Any other Black/African/Caribbean background"
    case blackCarribean = "Black/African/Caribbean/Black British - Caribbean"
    case mixedOther = "Mixed/Multiple ethnic groups - Any other Mixed/Multiple ethnic background"
    case mixedWhiteAsian = "Mixed/Multiple ethnic groups - White and Asian"
    case mixedWhiteAfrican = "Mixed/Multiple ethnic groups - White and Black African"
    case mixedWhiteCaribbean = "Mixed/Multiple ethnic groups - White and Black Caribbean"
    case other = "Other ethnic group - Any other ethnic group"
    case notStated = "Other ethnic group - Not stated"
    case whiteOther = "White - Any other White background"
    case whiteBritish = "White - English/Welsh/Scottish/Northern Irish/British"
    case whiteIrish = "White - Irish"
    
    var description: String {
        
        switch self {
        case .asianOther:           return "Asian"
        case .asianBangladeshi:     return "Asian Bangladeshi"
        case .asianChinese:         return "Asian Chinese"
        case .asianIndian:          return "Asian Indian"
        case .asianPakistani:       return "Asian Pakistani"
        case .blackAfrican:         return "Black African"
        case .blackOther:           return "Black"
        case .blackCarribean:       return "Black Caribbean"
        case .mixedOther:           return "Mixed"
        case .mixedWhiteAsian:      return "Mixed White Asian"
        case .mixedWhiteAfrican:    return "Mixed White African"
        case .mixedWhiteCaribbean:  return "Mixed White Caribbean"
        case .other:                return "Not defined"
        case .notStated:            return "Not stated"
        case .whiteOther:           return "White"
        case .whiteBritish:         return "White British"
        case .whiteIrish:           return "White Irish"

        }
    }
}
