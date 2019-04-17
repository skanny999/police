//
//  ContactModelTest.swift
//  PoliceTests
//
//  Created by Riccardo on 17/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import XCTest
import CoreData
import SwiftyJSON
@testable import Police

class ContactModelTest: XCTestCase {
    
    var mockContainer: NSPersistentContainer?
    
    override func setUp() {
        
        if mockContainer == nil {
            mockContainer = CoreDataManager.shared.container
        }
    }
    
    override func tearDown() {
        
        mockContainer = nil
    }
    
    // MARK: - Contacts
    
    func testContactObject() {
        
        let partionaContactsJson = try! JSON(data: dataFromFile(JSONFile.Contacts.partialContacts))
        let contact = Contact.newContacts(from: partionaContactsJson, in: mockContainer!.viewContext)
        
        XCTAssertTrue(contact?.twitter == "http://www.twitter.com/centralleicsNPA")
        XCTAssertTrue(contact?.facebook == "http://www.facebook.com/leicspolice")
        XCTAssertTrue(contact?.telephone == "101")
        XCTAssertTrue(contact?.email == "centralleicester.npa@leicestershire.pnn.police.uk")
        XCTAssertTrue(contact?.address == "indirizzo")
        XCTAssertTrue(contact?.blog == "diario")
        XCTAssertTrue(contact?.eMessaging == nil)
        XCTAssertTrue(contact?.fax == nil)
        XCTAssertTrue(contact?.flickr == nil)
        XCTAssertTrue(contact?.forum == nil)
        XCTAssertTrue(contact?.googlePlus == nil)
        XCTAssertTrue(contact?.mobile == "telefonino")
        XCTAssertTrue(contact?.rss == "notizie")
        XCTAssertTrue(contact?.website == "ilSito")
        XCTAssertTrue(contact?.youtube == "iutubbe")
        XCTAssertTrue(contact?.allContacts.count == 15)
        
        let emptyDict: [String: Any] = [:]
        let emptyJson = JSON(arrayLiteral: emptyDict)
        let emptyContact = Contact.newContacts(from: emptyJson, in: mockContainer!.viewContext)
        XCTAssertTrue(emptyContact!.isEmpty)
        
        
        let allContactsJson = try! JSON(data: dataFromFile(JSONFile.Contacts.allContacts))
        contact?.updateContacts(fromContactDetails: allContactsJson)
        
        XCTAssertTrue(contact?.twitter == "http://www.twitter.com/centralleicsNPA")
        XCTAssertTrue(contact?.facebook == "http://www.facebook.com/leicspolice")
        XCTAssertTrue(contact?.telephone == "101")
        XCTAssertTrue(contact?.email == "centralleicester.npa@leicestershire.pnn.police.uk")
        XCTAssertTrue(contact?.address == "indirizzo")
        XCTAssertTrue(contact?.blog == "diario")
        XCTAssertTrue(contact?.eMessaging == "messaggio")
        XCTAssertTrue(contact?.fax == "ilFax")
        XCTAssertTrue(contact?.flickr == "leFoto")
        XCTAssertTrue(contact?.forum == "ilForum")
        XCTAssertTrue(contact?.googlePlus == "googleSocial")
        XCTAssertTrue(contact?.mobile == "telefonino")
        XCTAssertTrue(contact?.rss == "notizie")
        XCTAssertTrue(contact?.website == "ilSito")
        XCTAssertTrue(contact?.youtube == "iutubbe")
    }
    
    
    
    // MARK: - Generic helpers

    
    func savedObject<T: Updatable>(ofType objectClass: T.Type, withData data: Data) -> T where T: NSManagedObject {
        
        if let json = try? JSON(data: data),
            let objectId = json[objectClass.dataIdentifier].number?.stringValue ?? json[objectClass.dataIdentifier].string,
            let object = objectClass.object(withId: objectId, in: CoreDataManager.shared.container.viewContext) {
            
            return object
        }
        fatalError("Couldn't parse neighbourhood")
    }
    
    func dataFromFile(_ fileName: String) -> Data {
        
        return FileExtractor.extractJsonFile(withName: fileName, forClass: type(of: self))
    }
}
