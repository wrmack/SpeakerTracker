//
//  DisplayMeetingEventsTests.swift
//  SpeakerTrackerTests
//
//  Created by Warwick McNaughton on 1/04/19.
//  Copyright © 2019 Warwick McNaughton. All rights reserved.
//

import XCTest
@testable import SpeakerTracker


class DisplayMeetingEventsTests: XCTestCase {
    var storedEvents = [Event]()
    var sut: DisplayEventsViewController?
    
    
    override func setUp() {
        super.setUp()
        // Populate storedEvents property with events from stored event documents
        let promise = expectation(description: "Wait for retrieval of stored events")
        TestingUtilities.getStoredEvents(callback: { events in
            self.storedEvents = events
            // Continue with setup
            self.setupSUT()
            promise.fulfill()
        })
        waitForExpectations(timeout: 3, handler: nil)
    }

    override func tearDown() {
        storedEvents = [Event]()
        sut = nil
        super.tearDown()
    }

    
    func setupSUT() {
        // Setup app from storyboard
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        // Load rootviewcontroller
        let initialTabBarCon = storyboard.instantiateInitialViewController() as! UITabBarController
        UIApplication.shared.keyWindow?.rootViewController = initialTabBarCon
        // Load setup tab
        initialTabBarCon.selectedIndex = 1
        // Get sut
        let splitVC = initialTabBarCon.viewControllers![1] as! UISplitViewController
        let setupTabBarC = splitVC.viewControllers[0] as! UITabBarController
        // Load Meeting events tab
        setupTabBarC.selectedIndex = 3
        sut =  (setupTabBarC.viewControllers![2] as! UINavigationController).viewControllers[0] as? DisplayEventsViewController
        // Wait, when sut loads it fetches asynchronously
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 2))
    }
    
    
    /*
     Given: sut
     When: sut fetches meeting group names for entity
     Then: the number of fetched meeting group names should equal the number of meeting groups stored with entity
     */
    func testShouldFetchAllEvents() {
        
        print("Stored events \(storedEvents)")
        
        // Meeeting groups in stored entity
//        let entity = storedEvents[0]
//        let meetingGroupsInEntity = entity.meetingGroups
//        print("Meeting groups in entity: \(meetingGroupsInEntity!)")
//        // Fetch meeting group names for this entity
//        sut!.fetchMeetingGroups(entity: entity)
//        RunLoop.current.run(until: Date(timeIntervalSinceNow: 2))
//        let fetchedNames = sut!.meetingGroupNames
//        print("Fetched meeting group names: \(fetchedNames)")
//        XCTAssert(fetchedNames.count == meetingGroupsInEntity?.count)
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
