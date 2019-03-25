//
//  AnnotationsProvider.swift
//  Police
//
//  Created by Riccardo on 24/03/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

class AnnotationsProvider {
    
    static func crimes(from annotations: [Annotation]) -> [Crime] {
        
        return annotations.compactMap { $0.origin as? Crime }
    }
    
    
    
    
}
