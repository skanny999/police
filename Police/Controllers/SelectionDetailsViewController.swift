//
//  SelectionDetailsControllerViewController.swift
//  Police
//
//  Created by Riccardo on 13/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit

protocol Displayable: UITableViewDataSource, UITableViewDelegate {}

class SelectionDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: Displayable? {
        didSet {
            if let tableView = tableView {
                setDataSource()
            }
        }
    }

    
    @IBAction func didTapCancel(_ sender: Any) {
        
        let nc = NotificationCenter.default
        nc.post(name: NotificationName.dismissDetail, object: nil)
        navigationController?.popViewController(animated: true)
        viewModel = nil
    }
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        configureCells()
        registerCells()
        setDataSource()
    }
    
    
    private func setDataSource() {
        
        if viewModel == nil {
            setDataSourceForEmptyTableView()
            navigationController?.popViewController(animated: true)
        } else {
            setViewModelDelegates()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
    
    private func setViewModelDelegates() {
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
    }
    
    private func setDataSourceForEmptyTableView() {
        
        tableView.dataSource = self
    }
}


// MARK: - Data source for empty table view

extension SelectionDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}



