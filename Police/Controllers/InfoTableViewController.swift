//
//  InfoTableViewController.swift
//  Police
//
//  Created by Riccardo on 19/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit

protocol PeriodSelectorDelegate {
    
    func periodSelectorUpdated()
}


class InfoTableViewController: UITableViewController {
    
    
    @IBOutlet weak var periodCell: UITableViewCell!
    @IBOutlet weak var periodLabel: UILabel!
    
    @IBOutlet weak var pickerCell: UITableViewCell!
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var infoTextView: UITextView!
    
    let periodCellIndexPath = IndexPath(row: 0, section: 0)
    var pickerIsShowing = false
    let periods = CoreDataProvider.allPeriods()
    
    var delegate: PeriodSelectorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePicker()
        configurePeriodLabel()
        configureDelegate()
    }

    private func configurePeriodLabel() {
        
        if let periodDescription = CoreDataProvider.selectedPeriod()?.stringDescription.dateDescription {
            periodLabel.updateWithText(periodDescription)
        }
    }
    
    private func configureDelegate() {
        
         if let navigationController = tabBarController?.viewControllers?.first as? UINavigationController,
            let mapViewController = navigationController.viewControllers.first as? MapViewController {
            delegate = mapViewController.viewModel
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if indexPath == periodCellIndexPath {
            
            animatePicker()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func animatePicker() {
        
        pickerIsShowing ? hidePicker() : showPicker()
    }
    
    private func showPicker() {
        
        pickerIsShowing.toggle()
        updateTableView()
        picker.isHidden = false
        UIView.animate(withDuration: 0.15) {
            
            self.picker.alpha = 1.0
        }
    }
    
    
    private func hidePicker() {
        
        pickerIsShowing.toggle()
        updateTableView()
        UIView.animate(withDuration: 0.15, animations: {
            
            self.picker.alpha = 0.0
            
        }) { (finished) in
            
            self.picker.isHidden = true
        }
    }
    
    private func updateTableView() {
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath == IndexPath(row: 1, section: 0) {
            
            return pickerIsShowing ? 168.0 : 0.0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}

extension InfoTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return periods?.count ?? 0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let period = periods?[row] {
            
            period.setToSelected()
            configurePeriodLabel()
            delegate?.periodSelectorUpdated()
            animatePicker()
        }
    }
    
    func configurePicker() {
        
        picker.delegate = self
        picker.dataSource = self
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return periods?[row].stringDescription.dateDescription
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if let period = periods?[row] {
            let pickerLabel = UILabel()
            let myTitle = NSAttributedString(string: period.stringDescription.dateDescription!, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.regular),NSAttributedString.Key.foregroundColor:UIColor.black])
            pickerLabel.attributedText = myTitle
            pickerLabel.textAlignment = .center
            pickerLabel.backgroundColor = UIColor.white
            pickerView.backgroundColor = UIColor.white
            return pickerLabel
        }
        
        return UIView()
    }
    
    
    
    
}
