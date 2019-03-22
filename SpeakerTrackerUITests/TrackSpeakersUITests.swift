//
//  TrackSpeakersTests.swift
//  SpeakerTrackerUITests
//
//  Created by Warwick McNaughton on 17/03/19.
//  Copyright © 2019 Warwick McNaughton. All rights reserved.
//

import XCTest


class TrackSpeakersUITests: XCTestCase {
    var app = XCUIApplication()
    
    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    
    /*
     Given:  Name held in first cell in first table
     When: Cell button on right is tapped
     Then: That name is now held by end cell in second table
     */
    func testRightTapShouldMoveNameRight() {
        let textOfFirstCellInFirstTable = app.tables.allElementsBoundByIndex[0].cells.firstMatch.children(matching: .staticText).allElementsBoundByIndex[0].label
        app.tables.firstMatch.cells.firstMatch.buttons[">"].tap()
        let countOfCellsInSecondTable = app.tables.allElementsBoundByIndex[1].cells.count
        let textOfFirstCellInSecondTable = app.tables.allElementsBoundByIndex[1].cells.firstMatch.children(matching: .staticText).allElementsBoundByIndex[countOfCellsInSecondTable - 1].label
        XCTAssert(textOfFirstCellInFirstTable == textOfFirstCellInSecondTable)
    }

    
    /*
     Given: Timer play button in speaking table cell (third table)
     When: Play button is tapped & wait 2 seconds
     Then: Play button label should start with "00:"
     When: Button is tapped again & wait 4 seconds
     Then: Timer button label should not change its display after waiting 4 seconds
     */
    func testShouldStartAndStopTimerWhenTapCellButton() {
        var buttonText: String?
        app.tables.firstMatch.cells.firstMatch.buttons[">"].tap()
        app.tables.allElementsBoundByIndex[1].cells.firstMatch.buttons[">"].tap()
        app.tables.allElementsBoundByIndex[2].cells.firstMatch.buttons.allElementsBoundByIndex[1].tap()
        let promise = expectation(description: "Wait for timer")
        promise.expectedFulfillmentCount = 2
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { timer in
            timer.invalidate()
            promise.fulfill()
            buttonText = self.app.tables.allElementsBoundByIndex[2].cells.firstMatch.buttons.allElementsBoundByIndex[1].label
            XCTAssert(buttonText!.prefix(3) == "00:")
            self.app.tables.allElementsBoundByIndex[2].cells.firstMatch.buttons.allElementsBoundByIndex[1].tap()
            let buttonTextOnStop =  self.app.tables.allElementsBoundByIndex[2].cells.firstMatch.buttons.allElementsBoundByIndex[1].label
            print("******buttonTextOnStop: \(buttonTextOnStop)")
            Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: { timer in
                timer.invalidate()
                let buttonTextAfterWait = self.app.tables.allElementsBoundByIndex[2].cells.firstMatch.buttons.allElementsBoundByIndex[1].label
                print("*****buttonTextAfterWait: \(buttonTextAfterWait)")
                XCTAssert(buttonTextOnStop == buttonTextAfterWait)
                promise.fulfill()
            })
        })
        waitForExpectations(timeout: 10, handler: nil)
    }

    
    /*
     Given: Timer play button in speaking table cell (third table) is counting down
     When: Stop button on large timer is tapped
     Then: Display on table cell should stop counting (does not change after 4 seconds)
     */
    func testShouldStopTimerInCellWhenTapLargeStopButton() {
        app.tables.firstMatch.cells.firstMatch.buttons[">"].tap()
        app.tables.allElementsBoundByIndex[1].cells.firstMatch.buttons[">"].tap()
        app.tables.allElementsBoundByIndex[2].cells.firstMatch.buttons.allElementsBoundByIndex[1].tap()
        let promise = expectation(description: "Wait for timer")
        promise.expectedFulfillmentCount = 2
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: { timer in
            timer.invalidate()
            promise.fulfill()
            let buttonText = self.app.tables.allElementsBoundByIndex[2].cells.firstMatch.buttons.allElementsBoundByIndex[1].label
            XCTAssert(buttonText.prefix(3) == "00:")
            // Stop counting down
            self.app.buttons["■"].tap()
            let buttonTextOnStop =  self.app.tables.allElementsBoundByIndex[2].cells.firstMatch.buttons.allElementsBoundByIndex[1].label
            print("******buttonTextOnStop: \(buttonTextOnStop)")
            Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: { timer in
                timer.invalidate()
                let buttonTextAfterWait = self.app.tables.allElementsBoundByIndex[2].cells.firstMatch.buttons.allElementsBoundByIndex[1].label
                print("*****buttonTextAfterWait: \(buttonTextAfterWait)")
                XCTAssert(buttonTextOnStop == buttonTextAfterWait)
                promise.fulfill()
            })
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    /*
     Given: First speaker timed and timer stopped
     When: Second speaker commences and is timed
     Then: First speaker's time remains
     */
    func testShouldRetainPreviousSpeakerTimeWhenNewSpeakerTimeStarts() {
        app.tables.firstMatch.cells.firstMatch.buttons[">"].tap()
        app.tables.allElementsBoundByIndex[1].cells.firstMatch.buttons[">"].tap()
        app.tables.allElementsBoundByIndex[2].cells.firstMatch.buttons.allElementsBoundByIndex[1].tap()
        app.tables.allElementsBoundByIndex[2].cells.firstMatch.buttons.allElementsBoundByIndex[1].tap()
        app.tables.firstMatch.cells.firstMatch.buttons[">"].tap()
        app.tables.allElementsBoundByIndex[1].cells.firstMatch.buttons[">"].tap()
        app.tables.allElementsBoundByIndex[2].cells.allElementsBoundByIndex[1].buttons.allElementsBoundByIndex[1].tap()
        let buttonText = app.tables.allElementsBoundByIndex[2].cells.firstMatch.buttons.allElementsBoundByIndex[1].label
        print("******buttonText: \(buttonText)")
        XCTAssert(buttonText.prefix(3) == "00:" )
        app.tables.allElementsBoundByIndex[2].cells.allElementsBoundByIndex[1].buttons.allElementsBoundByIndex[1].tap()
    }
    
    /*
     Given: First speaker timed and timer stopped by pressing large stop button
     When: Second speaker commences and is timed
     Then: First speaker's time remains
     */
    func testShouldRetainPreviousSpeakerTimeWhenStoppedByLargeStopButton() {
        app.tables.firstMatch.cells.firstMatch.buttons[">"].tap()
        app.tables.allElementsBoundByIndex[1].cells.firstMatch.buttons[">"].tap()
        app.tables.allElementsBoundByIndex[2].cells.firstMatch.buttons.allElementsBoundByIndex[1].tap()
        let promise = expectation(description: "Waiting for timer")
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: { timer in
            self.app.buttons["■"].tap()
            self.app.tables.firstMatch.cells.firstMatch.buttons[">"].tap()
            self.app.tables.allElementsBoundByIndex[1].cells.firstMatch.buttons[">"].tap()
            self.app.tables.allElementsBoundByIndex[2].cells.allElementsBoundByIndex[1].buttons.allElementsBoundByIndex[1].tap()
            let buttonText = self.app.tables.allElementsBoundByIndex[2].cells.firstMatch.buttons.allElementsBoundByIndex[1].label
            print("******buttonText: \(buttonText)")
            XCTAssert(buttonText.prefix(3) == "00:" )
            self.app.tables.allElementsBoundByIndex[2].cells.allElementsBoundByIndex[1].buttons.allElementsBoundByIndex[1].tap()
            promise.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}
