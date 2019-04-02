//
//  DisplayMeetingGroupsTests.swift
//  SpeakerTrackerTests
//
//  Created by Warwick McNaughton on 1/04/19.
//  Copyright © 2019 Warwick McNaughton. All rights reserved.
//

import XCTest
@testable import SpeakerTracker


class DisplayMeetingGroupsTests: XCTestCase {
    var storedEntities = [Entity]()
    var sut: DisplayMeetingGroupsViewController?
    
    
    override func setUp() {
        super.setUp()
        // Populate storedEntities property with entities from stored entity documents
        let promise = expectation(description: "Wait for retrieval of stored entities")
        TestingUtilities.getStoredEntities(callback: { entities in
            self.storedEntities = entities
            // Continue with setup
            self.setupSUT()
            promise.fulfill()
        })
        waitForExpectations(timeout: 3, handler: nil)
    }

    override func tearDown() {
        storedEntities = [Entity]()
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
        // Load Meeting groups tab
        setupTabBarC.selectedIndex = 2
        sut =  (setupTabBarC.viewControllers![2] as! UINavigationController).viewControllers[0] as? DisplayMeetingGroupsViewController
        // Wait, when sut loads it fetches asynchronously
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 2))
    }

    
    /*
     Given: sut
     When: sut fetches meeting group names for entity
     Then: the number of fetched meeting group names should equal the number of meeting groups stored with entity
     */
    func testShouldFetchAllMeetingGroupsInEntity() {
        // Meeeting groups in stored entity
        let entity = storedEntities[0]
        let meetingGroupsInEntity = entity.meetingGroups
        print("Meeting groups in entity: \(meetingGroupsInEntity!)")
        // Fetch meeting group names for this entity
        sut!.fetchMeetingGroups(entity: entity)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 2))
        let fetchedNames = sut!.meetingGroupNames
        print("Fetched meeting group names: \(fetchedNames)")
        XCTAssert(fetchedNames.count == meetingGroupsInEntity?.count)
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
