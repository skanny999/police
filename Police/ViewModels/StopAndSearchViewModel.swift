//
//  StopAndSearchViewModel.swift
//  Police
//
//  Created by Riccardo on 17/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation


enum StopAndSearchItemType {
    case summary
    case details
    case suspect
    case datePlace
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
            let legislation = stopAndSearch.legislation {
            items.append(StopAndSearchViewModelDescription(description: description,
                                                           legislation: legislation,
                                                           image: stopAndSearch.image,
                                                           colour: stopAndSearch.colour))
        }
        
        if let gender = stopAndSearch.genderCode,
            let age = stopAndSearch.ageRange,
            let ethnicity = stopAndSearch.suspectEthnicity,
            let etnicityDescription = Etnicity(rawValue: ethnicity)?.description {
            items.append(StopAndSearchViewModelSuspect(gender: gender,
                                                       age: age,
                                                       ethnicity: etnicityDescription))
        }
        
        if let dateTime = stopAndSearch.dateTime.longDescription,
            let place = stopAndSearch.streetName {
            items.append(StopAndSearchViewModelDatePlace(date: dateTime, place: place))
        }
        
        if let outcome = stopAndSearch.outCome {
            items.append(StopAndSearchViewModelOutcome(outcome: outcome))
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = Colour.blue
        }
    }
}

extension StopAndSearchViewModel: Displayable {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return items[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        
        switch item.type {
        case .details:
            if let description = item as? StopAndSearchViewModelDescription,
            let cell = tableView.dequeueReusableCell(withIdentifier: StopAndSearchDetailsCell.identifier, for: indexPath) as? StopAndSearchDetailsCell {
                cell.item = description
                return cell
            }
            
        case .suspect:
            if let suspect = item as? StopAndSearchViewModelSuspect,
            let cell = tableView.dequeueReusableCell(withIdentifier: StopAndSearchSuspectCell.identifier, for: indexPath) as? StopAndSearchSuspectCell {
                cell.item = suspect
                return cell
            }
            
        case .datePlace:
            if let dateplace = item as? StopAndSearchViewModelDatePlace,
            let cell = tableView.dequeueReusableCell(withIdentifier: StopAndSearchDatePlaceCell.identifier, for: indexPath) as? StopAndSearchDatePlaceCell {
                cell.item = dateplace
                return cell
            }
        case .outcome:
            if let outcome = item as? StopAndSearchViewModelOutcome,
            let cell = tableView.dequeueReusableCell(withIdentifier: StopAndSearchOutcomeCell.identifier, for: indexPath) as? StopAndSearchOutcomeCell {
                cell.item = outcome
                return cell
            }
        case .summary:
            break
        }
        return UITableViewCell()
    }
}



struct StopAndSearchViewModelDescription: StopAndSearchViewModelItem {
    
    let description: String
    let legislation: String
    let image: UIImage
    let colour: UIColor
    
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
        return .datePlace
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
