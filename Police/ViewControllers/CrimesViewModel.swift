//
//  CrimesViewModel.swift
//  Police
//
//  Created by Riccardo on 13/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation


struct CrimesViewModel: Displayable {
    
    let crimes: [Crime]
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        return crimes.count
    }

}
