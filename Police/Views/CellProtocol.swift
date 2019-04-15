//
//  CellProtocol.swift
//  Police
//
//  Created by Riccardo on 15/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

protocol Loadable {
    
    static var identifier: String { get }
    static var nib: UINib { get }
}

extension Loadable {
    
    static var identifier: String {
        
        return String(describing: self)
    }
    
    static var nib: UINib {
        
        return UINib(nibName: identifier, bundle: nil)
    }
}
