//
//  InfoText.swift
//  Police
//
//  Created by Riccardo on 22/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation
import SwiftRichString

struct InfoText {
    
    static var bullet: String {
        return "\u{2022}  "
    }
    
    static let normal = Style {
        
        $0.font = SystemFonts.GillSans.font(size: 17.0)
    }
    
    static let title = Style {
        
        $0.font = SystemFonts.GillSans.font(size: 25.0)
    }
    
    static let subtitle = Style {
        
        $0.font = SystemFonts.GillSans.font(size: 21.0)
    }
    
    
    static let group = StyleGroup(base: InfoText.normal, ["title": title,
                                                   "subtitle": subtitle])
    
    static let lastUpdate = CoreDataProvider.lastPeriod()?.stringDescription.dateDescription ?? "N/A"
    
    
    
    static let infoString = """
    <title>General</title>
        
    \u{2022} Frequency: Monthly
        
    \u{2022} Time Period Covered: March 2016 to \(lastUpdate)
        
    \u{2022} Geographic Coverage: England, Wales, Northern Ireland
        
    \u{2022} Issued: \(lastUpdate)
        
    \u{2022} Publisher: Home Office
        
    \u{2022} licence: Open Government Licence v3.0

    <title>Data Provenance</title>
    
    The data on this app is published by the Home Office, and is provided to the Police by the 43 geographic police forces in England and Wales, the British Transport Police, the Police Service of Northern Ireland and the Ministry of Justice
    All data is then anonymised before being published to this app.
    
    <title>Known Issues</title>
    
    There are some major, difficult to fix, issues with the data published on this site.
    
    \u{2022} Location accuracy. Inconsistent geocoding policies in police forces mean we cannot be confident that the location data provided is fully accurate or consistent. This is especially true of crimes where the exact location is not known, which could be because it happened somewhere not included in the force gazetteer system or because the victim is not sure where it happened. Differences in the quality of gazetteer systems is also a big factor. Estimates of geocoding accuracy in different forces range from 60% to 97%.
        
    \u{2022} Court Result matching. There is no unique identifier for crimes that runs from the police service to the CPS and onwards to the Courts. This makes trying to track a crime through the whole Criminal Justice Service automatically almost impossible. The Police uses a 'fuzzy matching' process to try and achieve this, with success rates between 19% and 97% depending on where in the country the crime happened.
        
    \u{2022} Double counting of ASB and Crime. The Police suspect that there may be six police forces who are duplicating certain types of ASB incidents in their uploads. They are working with them to resolve this and will make sure that any incorrect data is fixed.
        
    \u{2022} Constantly changing data. The data that forces upload to this site is a snapshot in time at the end of a particular month. For the crimes that are uploaded, some may be reclassified as a different type of crime in future months, or confirmed as a false report after investigation. Similarly, a crime may have its location changed in the source IT system as more information becomes available. In most cases, the Police would never find out about these later changes unless the force decides to do a complete data refresh. This is fairly rare.
        
    \u{2022} Missing outcome data. Neither the British Transport Police nor the Police Service of Northern Ireland provide the Home Office with outcome data.
    
    """.set(style: InfoText.group)
}
