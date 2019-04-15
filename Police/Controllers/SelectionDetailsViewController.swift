//
//  SelectionDetailsControllerViewController.swift
//  Police
//
//  Created by Riccardo on 13/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit


protocol Displayable: UITableViewDelegate, UITableViewDataSource {}

protocol Dismissable {
    func dismiss(_ viewController: SelectionDetailsViewController)
}

class SelectionDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: Dismissable?
    
    var viewModel: Displayable? {
        didSet {
            if tableView != nil {
                setDelegates()
                tableView.reloadData()
            }
        }
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        
        delegate?.dismiss(self)
    }
    override func viewDidLoad() {

        super.viewDidLoad()

        tableView.register(CrimeDescriptionCell.nib, forCellReuseIdentifier: CrimeDescriptionCell.identifier)
        tableView.register(PeriodCell.nib, forCellReuseIdentifier: PeriodCell.identifier)
        tableView.register(LocationCell.nib, forCellReuseIdentifier: LocationCell.identifier)
        tableView.register(OutcomeCell.nib, forCellReuseIdentifier: OutcomeCell.identifier)
    }
    
    func setDelegates() {
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
    }
    
    
    
}


