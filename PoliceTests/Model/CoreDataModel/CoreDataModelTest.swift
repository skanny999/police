//
//  CoreDataModelTest.swift
//  PoliceTests
//
//  Created by Riccardo on 03/02/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import XCTest
import CoreData
import SwiftyJSON
@testable import Police

class CoreDataModelTest: XCTestCase {
    
    var mockContainer: NSPersistentContainer?

    override func setUp() {
        
        if mockContainer == nil {
           mockContainer = CoreDataManager.shared().container
        }
    }

    override func tearDown() {
        
        mockContainer = nil
    }
    
    // MARK: - Crime
    
    func testCrimeObject() {
        
       var data = dataFromFile(JSONFile.Crimes.crime)
        
        updateObject(type: Crime.self, withData: data) { [weak self] in
            
            let crime = self?.savedObject(ofType: Crime.self, withData: data)
            XCTAssertTrue(crime?.locationTypeCode == "Force")
            XCTAssertTrue(crime?.category == .antiSocialBehaviour)
            XCTAssertTrue(crime?.extraContent == "")
            XCTAssertTrue(crime?.identifier == "54164419")
            XCTAssertTrue(crime?.locationId == 0)
            XCTAssertTrue(crime?.locationSubtypeCode == "")
            XCTAssertTrue(crime?.month == "01")
            XCTAssertTrue(crime?.persistentId == "fsdfskdjfslkdjfsldkfsdlskd")
            XCTAssertTrue(crime?.streetName == "On or near Wharf Street North")
            XCTAssertTrue(crime?.year == "2017")
            XCTAssertTrue(crime?.latitude == "52.640961")
            XCTAssertTrue(crime?.longitude == "-1.126371")
            XCTAssertTrue(crime?.outcomes?.first?.category == .underInvestigation)
            XCTAssertTrue(crime?.outcomes?.first?.date == "2017-05")
            XCTAssertTrue(crime?.outcomes?.first?.personId == nil)
        }
        
        data = dataFromFile(JSONFile.Crimes.crimeEdited)
        
        updateObject(type: Crime.self, withData: data) { [weak self] in
            
            let crime = self?.savedObject(ofType: Crime.self, withData: data)
            XCTAssertTrue(crime?.locationTypeCode == "Travel")
            XCTAssertTrue(crime?.category == .antiSocialBehaviour)
            XCTAssertTrue(crime?.extraContent == "")
            XCTAssertTrue(crime?.identifier == "54164419")
            XCTAssertTrue(crime?.locationId == 0)
            XCTAssertTrue(crime?.locationSubtypeCode == "")
            XCTAssertTrue(crime?.month == "01")
            XCTAssertTrue(crime?.persistentId == "fsdfskdjfslkdjfsldkfsdlskd")
            XCTAssertTrue(crime?.streetName == "On or near Wharf Street North")
            XCTAssertTrue(crime?.year == "2017")
            XCTAssertTrue(crime?.latitude == "52.640961")
            XCTAssertTrue(crime?.longitude == "-1.126371")
            
            let outcomes = crime?.outcomes?.sorted {$0.date! < $1.date!}

            XCTAssertTrue(outcomes?.first?.category == .underInvestigation)
            XCTAssertTrue(outcomes?.first?.date == "2017-05")
            XCTAssertTrue(outcomes?.first?.personId == nil)
            XCTAssertTrue(outcomes?.last?.category == .formalActionNotInPublicInterest)
            XCTAssertTrue(outcomes?.last?.date == "2017-06")
            XCTAssertTrue(outcomes?.last?.personId == nil)
            
        }
    }

    // MARK: - Neighbourhood
    
    func testNeighbourhoodObject() {
        
        let longDescription = "<p>The Castle neighbourhood is a diverse covering all of the City Centre. In addition it covers De Montfort University, the University of Leicester, Leicester Royal Infirmary, the Leicester Tigers rugby ground and the Clarendon Park and Riverside communities.</p>\n<p>The Highcross and Haymarket shopping centres and Leicester's famous Market are all covered by this neighbourhood.</p>"
        
        // Original data
        let data = dataFromFile(JSONFile.Neighbourhood.specificNeighbourhood)
        
        updateObject(type: Neighbourhood.self, withData: data) { [weak self] in
            
            let neighbourhood = self?.savedObject(ofType: Neighbourhood.self, withData: data)
            XCTAssertTrue(neighbourhood?.identifier == "NC04", neighbourhood?.identifier ?? "nil")
            XCTAssertTrue(neighbourhood?.longDescription == longDescription, neighbourhood?.longDescription ?? "nil")
            XCTAssertTrue(neighbourhood?.name == "City Centre",neighbourhood?.name ?? "nil")
            XCTAssertTrue(neighbourhood?.population == "0",neighbourhood?.population ?? "nil")
            XCTAssertTrue(neighbourhood?.coordinates?.lat == "52.6389", neighbourhood?.coordinates?.lat ?? "nil")
            XCTAssertTrue(neighbourhood?.coordinates?.long == "-1.13619", neighbourhood?.coordinates?.long ?? "nil")
            //Contact
            XCTAssertTrue(neighbourhood?.contact?.email == "centralleicester.npa@leicestershire.pnn.police.uk", neighbourhood?.contact?.email ?? "nil")
            XCTAssertTrue(neighbourhood?.contact?.telephone == "101", neighbourhood?.contact?.telephone ?? "nil")
            XCTAssertTrue(neighbourhood?.contact?.facebook == "http://www.facebook.com/leicspolice", neighbourhood?.contact?.facebook ?? "nil")
            XCTAssertTrue(neighbourhood?.contact?.twitter == "http://www.twitter.com/centralleicsNPA", neighbourhood?.contact?.twitter ?? "nil")
            XCTAssertTrue(neighbourhood?.contact?.forceUrl == "http://www.leics.police.uk/local-policing/city-centre", neighbourhood?.contact?.forceUrl ?? "nil")
            XCTAssertTrue(neighbourhood?.contact?.website == "http://www.leicester.gov.uk/", neighbourhood?.contact?.website ?? "nil")
            //Locations
            XCTAssertTrue(neighbourhood?.places?.first?.name == "Mansfield House", neighbourhood?.places?.first?.name ?? "nil")
            XCTAssertTrue(neighbourhood?.places?.first?.postcode == "LE1 3GG", neighbourhood?.places?.first?.postcode ?? "nil")
            XCTAssertTrue(neighbourhood?.places?.first?.address == "74 Belgrave Gate\n, Leicester", neighbourhood?.places?.first?.address ?? "nil")
            XCTAssertTrue(neighbourhood?.places?.first?.typeCode == "station", neighbourhood?.places?.first?.typeCode ?? "nil")
            XCTAssertTrue(neighbourhood?.places?.first?.longDescription == nil, neighbourhood?.places?.first?.longDescription ?? "nil")
            XCTAssertTrue(neighbourhood?.places?.first?.coordinates?.lat == nil, neighbourhood?.places?.first?.coordinates?.lat ?? "nil")
            XCTAssertTrue(neighbourhood?.places?.first?.coordinates?.long == nil, neighbourhood?.places?.first?.coordinates?.long ?? "nil")
        }
        
        // Edited data
        let editedData = dataFromFile(JSONFile.Neighbourhood.neighbourhoodEdited)
        
        updateObject(type: Neighbourhood.self, withData: editedData) { [weak self] in
            
            let neighbourhood = self?.savedObject(ofType: Neighbourhood.self, withData: data)
            XCTAssertTrue(neighbourhood?.identifier == "NC04", neighbourhood?.identifier ?? "nil")
            XCTAssertTrue(neighbourhood?.longDescription == longDescription, neighbourhood?.longDescription ?? "nil")
            XCTAssertTrue(neighbourhood?.name == "City Centre",neighbourhood?.name ?? "nil")
            XCTAssertTrue(neighbourhood?.population == "0",neighbourhood?.population ?? "nil")
            XCTAssertTrue(neighbourhood?.coordinates?.lat == "52.6389", neighbourhood?.coordinates?.lat ?? "nil")
            XCTAssertTrue(neighbourhood?.coordinates?.long == "-1.13619", neighbourhood?.coordinates?.long ?? "nil")
            //Contact
            XCTAssertTrue(neighbourhood?.contact?.email == "centralleicester.npa@leicestershire.pnn.police.uk", neighbourhood?.contact?.email ?? "nil")
            XCTAssertTrue(neighbourhood?.contact?.telephone == "010", neighbourhood?.contact?.telephone ?? "nil")
            XCTAssertTrue(neighbourhood?.contact?.facebook == "http://www.facebook.com/leicspolice", neighbourhood?.contact?.facebook ?? "nil")
            XCTAssertTrue(neighbourhood?.contact?.twitter == "http://www.twitter.com/centralleicsNPA", neighbourhood?.contact?.twitter ?? "nil")
            XCTAssertTrue(neighbourhood?.contact?.forceUrl == "http://www.leics.police.uk/local-policing", neighbourhood?.contact?.forceUrl ?? "nil")
            XCTAssertTrue(neighbourhood?.contact?.website == "http://www.leicester.gov", neighbourhood?.contact?.website ?? "nil")
            
            //Locations
            let locations = neighbourhood?.places?.sorted { $0.name! < $1.name! }
            XCTAssertTrue(locations?.first?.name == "Mansfield House", locations?.first?.name ?? "nil")
            XCTAssertTrue(locations?.first?.postcode == "LE1 3GG", locations?.first?.postcode ?? "nil")
            XCTAssertTrue(locations?.first?.address == "74 Belgrave Gate\n, Leicester", locations?.first?.address ?? "nil")
            XCTAssertTrue(locations?.first?.typeCode == "station", locations?.first?.typeCode ?? "nil")
            XCTAssertTrue(locations?.first?.longDescription == nil, locations?.first?.longDescription ?? "nil")
            XCTAssertTrue(locations?.first?.coordinates?.lat == nil, locations?.first?.coordinates?.lat ?? "nil")
            XCTAssertTrue(locations?.first?.coordinates?.long == nil, locations?.first?.coordinates?.long ?? "nil")
            XCTAssertTrue(locations?.last?.name == "Random House", locations?.last?.name ?? "nil")
            XCTAssertTrue(locations?.last?.postcode == "LE1 3GG", locations?.last?.postcode ?? "nil")
            XCTAssertTrue(locations?.last?.address == "74 Belgrave Gate\n, Leicester", locations?.last?.address ?? "nil")
            XCTAssertTrue(locations?.last?.typeCode == "station", locations?.last?.typeCode ?? "nil")
            XCTAssertTrue(locations?.last?.longDescription == "It's a random house", locations?.last?.longDescription ?? "nil")
            XCTAssertTrue(locations?.last?.coordinates?.lat == "-1.0967", locations?.last?.coordinates?.lat ?? "nil")
            XCTAssertTrue(locations?.last?.coordinates?.long == "53.214", locations?.last?.coordinates?.long ?? "nil")
        }
    }
    
    // MARK: - Events
    
    func testEventsObject() {
        
        let neigbourhoodData = dataFromFile(JSONFile.Neighbourhood.specificNeighbourhood)
        updateObject(type: Neighbourhood.self, withData: neigbourhoodData) { [weak self] in
            
            let neighbourhood = self?.savedObject(ofType: Neighbourhood.self, withData: neigbourhoodData)
            let eventsData = self!.dataFromFile(JSONFile.Events.events)
            let eventsJson = try! JSON(data: eventsData).array
            neighbourhood?.addEvents(from: eventsJson)
            
            let events = neighbourhood?.events?.sorted { $0.title! > $1.title! }
            
            XCTAssertTrue(events?.first?.title == "Crime Prevention Sale, Merlin Heights", events?.first?.title ?? "nil")
            XCTAssertTrue(events?.first?.longDescription == "Crime Prevention Sale\n", events?.first?.longDescription ?? "nil")
            XCTAssertTrue(events?.first?.address == "Merlin Heights Reception, Bath lane", events?.first?.address ?? "nil")
            XCTAssertTrue(events?.first?.typeCode == "meeting", events?.first?.typeCode ?? "nil")
            
            if let startDate = events?.first?.startDate, let endDate = events?.first?.endDate {
                
                XCTAssertTrue(self?.component(from: startDate).month == 2)
                XCTAssertTrue(self?.component(from: startDate).day == 18)
                XCTAssertTrue(self?.component(from: startDate).hour == 9)
                XCTAssertTrue(self?.component(from: endDate).month == 2)
                XCTAssertTrue(self?.component(from: endDate).day == 18)
                XCTAssertTrue(self?.component(from: endDate).hour == 10)
            } else {
                XCTFail("Event date is nil")
            }
            
            XCTAssertTrue(events?.last?.title == "Community Engagement, Guru Nanak Gurdwara", events?.last?.title ?? "nil")
            XCTAssertTrue(events?.last?.longDescription == nil, events?.last?.longDescription ?? "nil")
            XCTAssertTrue(events?.last?.address == "Guru Nanak Gurdwara,", events?.last?.address ?? "nil")
            XCTAssertTrue(events?.last?.typeCode == "meeting", events?.last?.typeCode ?? "nil")
            
            if let startDate = events?.last?.startDate, let endDate = events?.last?.endDate {
                
                XCTAssertTrue(self?.component(from: startDate).month == 2)
                XCTAssertTrue(self?.component(from: startDate).day == 19)
                XCTAssertTrue(self?.component(from: startDate).hour == 11)
                XCTAssertTrue(self?.component(from: endDate).month == 2)
                XCTAssertTrue(self?.component(from: endDate).day == 19)
                XCTAssertTrue(self?.component(from: endDate).hour == 12)
            } else {
                XCTFail("Event date is nil")
            }
        }
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
        XCTAssertTrue(contact?.activeContacts.count == 10)
        
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
    
    func updateObject<T: Updatable>(type: T.Type, withData data: Data, completion: @escaping () -> Void) {
        
        let expectation = self.expectation(description: T.entityName)
        
        UpdateProcessor.updateObject(ofType: T.self, fromData: data) { (completed) in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 3, handler: nil)
        completion()
    }
    
    
    func savedObject<T: Updatable>(ofType objectClass: T.Type, withData data: Data) -> T where T: NSManagedObject {
        
        if let json = try? JSON(data: data),
            let objectId = json[objectClass.dataIdentifier].number?.stringValue ?? json[objectClass.dataIdentifier].string,
            let object = objectClass.object(withId: objectId) {
            
            return object
        }
        fatalError("Couldn't parse neighbourhood")
    }
    
    func dataFromFile(_ fileName: String) -> Data {
        
        return FileExtractor.extractJsonFile(withName: fileName, forClass: type(of: self))
    }
    
    func component(from date: NSDate) -> (day: Int, month: Int, hour: Int) {
        
        let date = date as Date
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let hour = calendar.component(.hour, from: date)
        
        return (day: day, month: month, hour:hour)
    }

}
