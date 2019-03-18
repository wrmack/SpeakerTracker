//
//  TrackSpeakersTests.swift
//  SpeakerTrackerTests
//
//  Created by Warwick McNaughton on 17/03/19.
//  Copyright © 2019 Warwick McNaughton. All rights reserved.
//

import XCTest
@testable import SpeakerTracker

class TrackSpeakersTests: XCTestCase {
    var controllerUnderTest: TrackSpeakersViewController?
    
    override func setUp() {
        super.setUp()
        controllerUnderTest = (UIApplication.shared.keyWindow?.rootViewController as! UITabBarController).childViewControllers[0] as? TrackSpeakersViewController
    }

    override func tearDown() {
        controllerUnderTest = nil
        super.tearDown()
    }

    func testInitialisation() {
        XCTAssert(controllerUnderTest!.tableCollection.count > 0)
        XCTAssert(controllerUnderTest!.speakingTableNumberOfSections > 0)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
