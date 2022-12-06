//
//  SpeakerTrackerState.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 15/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine


/// Holds state associated with the TrackSpeakers use case
///
/// Publishes changes to:
/// -  the table collection
/// - meeting groups
/// - the timer string
/// - amendment mode
///
class TrackSpeakersState : ObservableObject {
    
    @Published var meetingGroupHasChanged = false
    @Published var tableCollection: TableCollection
    @Published var showMemberTimer = UserDefaults.standard.bool(forKey: "showIndividualTime")
    @Published var memberTimerIsActive = false
    @Published var timerString = "00:00"
    @Published var amendmentModeSet = false
    var timerSeconds = 0
    var hasMeetingEvent = false
    var tsSortedMembers = [Member]()
    
    
    init() {
        let remainingList = TableWithSectionLists(table: 0, sectionLists: [SectionList(sectionNumber: 0, sectionType: .off, sectionMembers: [ListMember]())])
        let waitingList = TableWithSectionLists(table: 1, sectionLists: [SectionList(sectionNumber: 0,  sectionType: .off, sectionMembers: [ListMember]())])
        let speakingList = TableWithSectionLists(table: 2, sectionLists: [SectionList(sectionNumber: 0,  sectionType: .mainDebate, sectionMembers: [ListMember]())])
        tableCollection = TableCollection(remainingTable: remainingList, waitingTable: waitingList, speakingTable: speakingList)
        print("++++++ TrackSpeakersState initialised")
    }
    
    deinit {
        print("++++++ TrackSpeakersState de-initialised")
    }
    
}
