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
    var currentEvent: MeetingEvent?
    var currentDebate: Debate?
    
    
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
    
    func sortedMeetingGroups() -> [MeetingGroup] {
        var meetingGroups = [MeetingGroup]()
        guard let entity = currentEntity else { return meetingGroups}
        guard let entityMeetingGroups = entity.meetingGroups else {return meetingGroups}
        if entityMeetingGroups.count == 0 {return meetingGroups}
        meetingGroups = entityMeetingGroups.allObjects as! [MeetingGroup]
        meetingGroups.sort(by: {
            if $0.name! < $1.name! { return true }
            return false
        })
        return meetingGroups
    }
    
}
