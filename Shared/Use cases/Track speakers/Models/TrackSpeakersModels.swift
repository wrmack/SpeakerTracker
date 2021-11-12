//
//  TrackingModels.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 14/08/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine


/*
 Requirements
 
 - there are three tables
 - first table: members are sorted alphabetically
 - second table: members are added to end of list
 - third table:
 - comprises one debate
 - a debate might have amendments
 - a member might speak in main debate and any amendments
 - divide table into sections
 - each section is either part of the main debate or an amendment debate
 - each section has its own members
 - each member tracks speaking time
 
 */




//enum SpeakingStatus {
//   case notYetSpoken
//   case isSpeaking
//   case hasSpoken
//}



// MARK: - Movement of speakers
enum MoveDirection {
    case left
    case right
}

struct MoveMemberAction : Equatable {
    var sourceTable = 0
    var sourceSectionListNumber = 0
    var listMember = ListMember()
    var direction = MoveDirection.right
}


// MARK: - Timer related

/**
 Which button to display next to speaker name.
 */
enum TimerButtonMode: Int {
    case play
    case pause_stop
    case play_stop
    case off
}

enum TimerButton {
    case play
    case pause
    case stop
    case none
}


struct MemberTimerActions: Equatable {
    var listMember = ListMember()
    var timerButtonMode = TimerButtonMode.off
    var timerIsActive = false
    var speakingTime = 0
    var timerButtonPressed = TimerButton.none
    //   var playPressed = false
    //   var pausePressed = false
    //   var stopPressed = false
}


// MARK: - Gesture related

enum LongPressType {
    case amendmentMover
    case amendmentFinal
}

struct LongPressAction: Equatable {
    var type: LongPressType = .amendmentMover
    var listMember = ListMember()
}

// MARK: - Tables and speakers

struct TableCollection {
    var remainingTable: TableWithSectionLists?
    var waitingTable: TableWithSectionLists?
    var speakingTable: TableWithSectionLists?
}

struct TableWithSectionLists : Hashable {
    var table = 2
    var sectionLists = [SectionList]()
}

struct SectionList : Hashable {
    var sectionNumber = 0
    var sectionType: SectionType = .mainDebate
    var sectionHeader = "Main debate"
    var sectionMembers = [ListMember]()
    
    init(sectionNumber: Int, sectionType: SectionType, sectionMembers: [ListMember]) {
        self.sectionNumber = sectionNumber
        self.sectionType = sectionType
        switch sectionType {
        case .mainDebate:
            self.sectionHeader = "Main debate"
        case .amendment:
            self.sectionHeader = "Amendment"
        case .off:
            self.sectionHeader = ""
        }
        self.sectionMembers = sectionMembers
    }
}

struct ListMember : Hashable {
    var row: Int?
    var member: Member?
    var startTime: Date?
    var speakingTime = 0
    var timerButtonMode: TimerButtonMode = .play
    var timerIsActive = false
}

enum SectionType {
    case mainDebate
    case amendment
    case off
}











