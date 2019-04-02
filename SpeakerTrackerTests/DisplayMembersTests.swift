//
//  DisplayMembersTests.swift
//  SpeakerTrackerTests
//
//  Created by Warwick McNaughton on 1/04/19.
//  Copyright © 2019 Warwick McNaughton. All rights reserved.
//

import XCTest
@testable import SpeakerTracker


class DisplayMembersTests: XCTestCase {
    var storedEntities = [Entity]()
    var sut: DisplayMembersViewController?
    
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
        // Load Members tab
        setupTabBarC.selectedIndex = 1
        sut =  (setupTabBarC.viewControllers![1] as! UINavigationController).viewControllers[0] as? DisplayMembersViewController
        // Wait, when sut loads it fetches asynchronously
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 2))
    }


    
    /*
     Given: sut
     When: sut fetches member names for entity
     Then: the number of fetched member names should equal the number of members stored with entity
     */
    func testShouldFetchAllMembersInEntity() {
        // Members in stored entity
        let entity = storedEntities[0]
        let membersInEntity = entity.members
        print("Members in entity: \(membersInEntity!)")
        // Fetch member names for this entity
        sut!.fetchMembers(entity: entity)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 2))
        let fetchedNames = sut!.memberNames
        print("Fetched member names: \(fetchedNames)")
        XCTAssert(fetchedNames.count == membersInEntity?.count)
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
