//
//  CrimeViewModel.swift
//  Police
//
//  Created by Riccardo on 13/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

// MARK: - CellTypes

enum CrimeViewModelItemType {
    
    case summary
    case period
    case locationDetails
    case outcome
}

// MARK: - Cell protocol per section

protocol CrimeViewModelItem {
    
    var type: CrimeViewModelItemType { get }
    var rowCount: Int { get }
    var sectionTitle: String { get }
}


class CrimeViewModel: NSObject {
    
    var items = [CrimeViewModelItem]()
    
    init(with crime: Crime) {
        super.init()
        
        items.append(CrimeViewModelSummary(crimes: [crime]))
        items.append(CrimeViewModelPeriod(period: period(of: crime)))
        items.append(CrimeViewModelLocation(location: crime.place))
        if let outcomes = outcomes(for: crime), !outcomes.isEmpty{
            items.append(CrimeViewModelOutcome(outcomes: outcomes))
        }
    }
    
    // MARK: - helper
    
    func period(of crime: Crime) -> String {
        
        let month = crime.month?.monthDescription ?? ""
        return "\(month) \(crime.year ?? "")"
    }
    
    
    func outcomes(for crime: Crime) -> [Outcome]? {
        guard let outcomes = crime.outcomes, !outcomes.isEmpty else { return nil }
        return outcomes.sorted(by: {$0.date! > $1.date!})
    }
}

// MARK: - DataSource

extension CrimeViewModel: Displayable {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        
        switch item.type {
        case .summary:
            if let item = item as? CrimeViewModelSummary,
                let cell = tableView.dequeueReusableCell(withIdentifier: CrimeDescriptionCell.identifier, for: indexPath) as? CrimeDescriptionCell {
                cell.item = item.crimes.first
                return cell
            }
        case .period:
            if let cell = tableView.dequeueReusableCell(withIdentifier: PeriodCell.identifier, for: indexPath) as? PeriodCell {
                cell.item = item
                return cell
            }
        case .locationDetails:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.identifier, for: indexPath) as? LocationCell {
                cell.item = item
                return cell
            }
        case .outcome:
            if let item = item as? CrimeViewModelOutcome,
                let cell = tableView.dequeueReusableCell(withIdentifier: OutcomeCell.identifier, for: indexPath) as? OutcomeCell {
                cell.item = item.outcomes[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }
}

// MARK: - Cell ViewModels

struct CrimeViewModelDescription: CrimeViewModelItem {
    
    let crime: Crime
    
    var type: CrimeViewModelItemType {
        return .summary
    }
    
    var rowCount: Int {
        return 1
    }
    
    var sectionTitle: String {
        return "Description"
    }
}

struct CrimeViewModelPeriod: CrimeViewModelItem {
    
    let period: String
    
    var type: CrimeViewModelItemType {
        return .period
    }
    
    var rowCount: Int {
        return 1
    }
    
    var sectionTitle: String {
        return "Period"
    }
}

struct CrimeViewModelLocation: CrimeViewModelItem {
    
    let location: String
    
    var type: CrimeViewModelItemType {
        return .locationDetails
    }
    
    var rowCount: Int {
        return 1
    }
    
    var sectionTitle: String {
        return "Location"
    }
}

struct CrimeViewModelOutcome: CrimeViewModelItem {
    
    let outcomes: [Outcome]
    
    var type: CrimeViewModelItemType {
        return .outcome
    }
    
    var rowCount: Int {
        return outcomes.count
    }
    
    var sectionTitle: String {
        return "Outcome"
    }
}
