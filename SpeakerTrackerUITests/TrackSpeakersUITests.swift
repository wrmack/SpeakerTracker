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
     Given: Timer play button in cell in third table
     When: Play button is tapped
     Then: Play button label should start with "00:"
     Wait
     When: Button is tapped again
     Then: Timer button label should not change its display after waiting two seconds
     */
    func testShouldStartTimerWhenTapCellPlayButton() {
        app.tables.firstMatch.cells.firstMatch.buttons[">"].tap()
        app.tables.allElementsBoundByIndex[1].cells.firstMatch.buttons[">"].tap()
        app.tables.allElementsBoundByIndex[2].cells.firstMatch.buttons.allElementsBoundByIndex[1].tap()
        let buttonText = app.tables.allElementsBoundByIndex[2].cells.firstMatch.buttons.allElementsBoundByIndex[1].label
        XCTAssert(buttonText.prefix(3) == "00:")
        app.tables.allElementsBoundByIndex[2].cells.firstMatch.buttons.allElementsBoundByIndex[1].tap()
        let buttonTextOnStop =  app.tables.allElementsBoundByIndex[2].cells.firstMatch.buttons.allElementsBoundByIndex[1].label
        sleep(2)
        let buttonTextAfterWait = app.tables.allElementsBoundByIndex[2].cells.firstMatch.buttons.allElementsBoundByIndex[1].label
        XCTAssert(buttonTextOnStop == buttonTextAfterWait)
    }
    


}
