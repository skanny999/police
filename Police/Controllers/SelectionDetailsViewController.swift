//
//  SelectionDetailsControllerViewController.swift
//  Police
//
//  Created by Riccardo on 13/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit

protocol Displayable: UITableViewDataSource, UITableViewDelegate {}

protocol Dismissable {
    func dismiss(_ viewController: SelectionDetailsViewController)
}

class SelectionDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: Dismissable?
    
    var viewModel: Displayable? {
        didSet {
            if tableView != nil {
                DispatchQueue.main.async {
                    self.setDelegates()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        
        delegate?.dismiss(self)
    }
    override func viewDidLoad() {

        super.viewDidLoad()
        configureCells()
        registerCells()
        setDelegates()
    }
    
    private func configureCells() {
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableView.automaticDimension
    }
    
    private func registerCells() {
        tableView.register(CrimeDescriptionCell.nib,
                           forCellReuseIdentifier: CrimeDescriptionCell.identifier)
        tableView.register(PeriodCell.nib,
                           forCellReuseIdentifier: PeriodCell.identifier)
        tableView.register(LocationCell.nib,
                           forCellReuseIdentifier: LocationCell.identifier)
        tableView.register(OutcomeCell.nib,
                           forCellReuseIdentifier: OutcomeCell.identifier)
        tableView.register(StopAndSearchDetailsCell.nib,
                           forCellReuseIdentifier: StopAndSearchDetailsCell.identifier)
        tableView.register(StopAndSearchSuspectCell.nib,
                           forCellReuseIdentifier: StopAndSearchSuspectCell.identifier)
        tableView.register(StopAndSearchDatePlaceCell.nib,
                           forCellReuseIdentifier: StopAndSearchDatePlaceCell.identifier)
        tableView.register(StopAndSearchOutcomeCell.nib,
                           forCellReuseIdentifier: StopAndSearchOutcomeCell.identifier)
    }
    
    private func setDelegates() {
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
    }
        
    @objc func reloadTableView() {
            
        }
}



