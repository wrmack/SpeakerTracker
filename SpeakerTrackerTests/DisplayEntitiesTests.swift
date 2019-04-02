//
//  DisplayEntitiesTests.swift
//  SpeakerTrackerTests
//
//  Created by Warwick McNaughton on 31/03/19.
//  Copyright © 2019 Warwick McNaughton. All rights reserved.
//

import XCTest
@testable import SpeakerTracker


class DisplayEntitiesTests: XCTestCase {
    var storedEntities = [Entity]()
    var namesOfStoredEntities = [String]()
    var sut: DisplayEntitiesViewController?
    
    
    override func setUp() {
        super.setUp()
        
        // Populate storedEntities property with entities from stored entity documents
        let promise = expectation(description: "Wait for retrieval of stored entities")
        TestingUtilities.getStoredEntities(callback: { entities in
            self.storedEntities = entities
            self.getNamesOfStoredEntities()
            // Continue with setup
            self.setupSUT()
            promise.fulfill()
        })
        waitForExpectations(timeout: 3, handler: nil)
    }

    override func tearDown() {
        storedEntities = [Entity]()
        namesOfStoredEntities = [String]()
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
        sut =  (setupTabBarC.viewControllers![0] as! UINavigationController).viewControllers[0] as? DisplayEntitiesViewController
        // Wait, when sut loads it fetches asynchronously
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 2))
    }
    
    func getNamesOfStoredEntities() {
        for entity in storedEntities {
            namesOfStoredEntities.append(entity.name!)
        }
    }
    
    /*
     Given: sut
     When: sut loads
     Then: sut fetches all entity names
     */
    func testShouldFetchAllEntityNames() {
        let fetchedNames = sut!.entityNames
        XCTAssert(fetchedNames.count == storedEntities.count)
        for name in namesOfStoredEntities {
            XCTAssert(fetchedNames.contains(name))
        }
        print("Fetched names: \(fetchedNames)")
        print("Stored entity names: \(namesOfStoredEntities)")
    }

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
