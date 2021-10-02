//
//  SpeakerTrackerState.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 15/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine

/**
 Holds state relating to the Speakers tab.
 
 Publishes:
 - changes to the table collection
 
 */
class TrackSpeakersState : ObservableObject {
    @Published var currentEntity: Entity?
    @Published var currentMeetingGroup: MeetingGroup?
    @Published var tableCollection: TableCollection
    @Published var timerString = "00:00"
    @Published var amendmentModeSet = false
    var timerSeconds = 0
//    var currentEvent: Event?
//    var currentDebate: Debate?
    
    
    init() {
        let remainingList = SpeakerListWithSections(table: 0, sectionLists: [SectionList(sectionNumber: 0, sectionType: .off, sectionMembers: [ListMember]())])
        let waitingList = SpeakerListWithSections(table: 1, sectionLists: [SectionList(sectionNumber: 0,  sectionType: .off, sectionMembers: [ListMember]())])
        let speakingList = SpeakerListWithSections(table: 2, sectionLists: [SectionList(sectionNumber: 0,  sectionType: .mainDebate, sectionMembers: [ListMember]())])
        tableCollection = TableCollection(remainingTable: remainingList, waitingTable: waitingList, speakingTable: speakingList)
        print("++++++ TrackSpeakersState initialised")
    }
    
    deinit {
        print("++++++ TrackSpeakersState de-initialised")
    }
    
}
