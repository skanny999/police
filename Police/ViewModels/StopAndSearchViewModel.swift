//
//  StopAndSearchViewModel.swift
//  Police
//
//  Created by Riccardo on 17/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation


enum StopAndSearchItemType {
    case details
    case suspect
    case dataPlace
    case outcome
}

protocol StopAndSearchViewModelItem {
    var type: StopAndSearchItemType { get }
    var rowCount: Int { get }
    var sectionTitle: String { get }
}

extension StopAndSearchViewModelItem {
    
    var rowCount: Int {
        return 1
    }
}



class StopAndSearchViewModel: NSObject {
    
    var items = [StopAndSearchViewModelItem]()
    
    init(with stopAndSearch: StopAndSearch) {
        super.init()
        
        if let description = stopAndSearch.objectOfSearch,
            let legislation = stopAndSearch.legislation,
            let image = stopAndSearchCrimeCategory(rawValue: description)?.image {
            
            items.append(StopAndSearchViewModelDescription(description: description,
                                                           legislation: legislation,
                                                           image: image))
        }
        
        if let gender = stopAndSearch.genderCode,
            let age = stopAndSearch.ageRange,
            let ethnicity = stopAndSearch.suspectEthnicity {
            
            items.append(StopAndSearchViewModelSuspect(gender: gender, age: age, ethnicity: ethnicity))
        }
        
        if let dateTime = stopAndSearch.dateTime.longDescription,
            let place = stopAndSearch.streetName {
            
            items.append(StopAndSearchViewModelDatePlace(date: dateTime, place: place))
        }
        
        if let outcome = stopAndSearch.outCome {
            
            items.append(StopAndSearchViewModelOutcome(outcome: outcome))
        }
    }
}



struct StopAndSearchViewModelDescription: StopAndSearchViewModelItem {
    
    let description: String
    let legislation: String
    let image: UIImage
    
    var type: StopAndSearchItemType {
        return .details
    }
    
    var sectionTitle: String {
        return "Object of Search"
    }
}

struct StopAndSearchViewModelSuspect: StopAndSearchViewModelItem {
    
    let gender: String
    let age: String
    let ethnicity: String
    
    var type: StopAndSearchItemType {
        return .suspect
    }
    
    var sectionTitle: String {
        return "Suspect"
    }
}

struct StopAndSearchViewModelDatePlace: StopAndSearchViewModelItem {
    
    let date: String
    let place: String
    
    var type: StopAndSearchItemType {
        return .dataPlace
    }
    
    var sectionTitle: String {
        return "Location"
    }
}

struct StopAndSearchViewModelOutcome: StopAndSearchViewModelItem {
    
    let outcome: String
    
    var type: StopAndSearchItemType {
        return .outcome
    }
    
    var sectionTitle: String {
        return "Outcome"
    }
}
