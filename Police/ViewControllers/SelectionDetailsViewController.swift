//
//  SelectionDetailsControllerViewController.swift
//  Police
//
//  Created by Riccardo on 13/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit


protocol Displayable {
    
    func numberOfSections() -> Int
    func numberOfRows(inSection section: Int) -> Int
}


class SelectionDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: Displayable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDelegate()
    }
    
    private func configureDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func loadTableView(with viewModel: Displayable) {
        
        self.viewModel = viewModel
        tableView.reloadData()
    }
    
    
}

extension SelectionDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(inSection: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
    
    
}
