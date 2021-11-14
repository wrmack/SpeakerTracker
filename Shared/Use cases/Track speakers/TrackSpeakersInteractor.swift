//
//  TrackSpeakersInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 15/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine


class TrackSpeakersInteractor {
    //    var presenter: TrackSpeakersPresenter?
    var remainingList: TableWithSectionLists?
    var waitingList: TableWithSectionLists?
    var speakingList: TableWithSectionLists?
    private var speakingListNumberOfSections = 1
    
    // MARK: - Class methods
    class func fetchMembers(presenter: TrackSpeakersPresenter, tableCollection: TableCollection) {
        presenter.presentMemberNames(tableCollection: tableCollection)
    }
    
    
    /// Fetches members for initial presentation if saved in `RestorationState`.
    ///
    /// Called by `.onAppear`.
    ///
    /// If `TrackSpeakersState` `tableCollection` does not contain members, checks if a `MeetingGroup` is saved in `RestorationState`
    /// and, if so, sends to `fetchMembers(presenter:, trackSpeakersState:, meetingGroupForRemainingTable:)`. Otherwise
    /// does nothing.
    class func fetchMembers(presenter: TrackSpeakersPresenter, entityState: EntityState, eventState: EventState, trackSpeakersState: TrackSpeakersState) {
        if trackSpeakersState.tableCollection.remainingTable?.sectionLists[0].sectionMembers.count == 0 &&
            trackSpeakersState.tableCollection.waitingTable?.sectionLists[0].sectionMembers.count == 0 &&
            trackSpeakersState.tableCollection.speakingTable?.sectionLists[0].sectionMembers.count == 0  {
            
            let savedStateIndices = RestorationState.getSpeakerTrackerState()
            if savedStateIndices.0 != nil && savedStateIndices.1 != nil {
                entityState.currentEntityIndex = savedStateIndices.0
                entityState.currentMeetingGroupIndex = savedStateIndices.1
                let meetingGroup = EntityState.meetingGroupWithIndex(index: savedStateIndices.1!)
                
                // Set TrackSpeakerState tsSortedMembers property
                var members = meetingGroup!.groupMembers?.allObjects as! [Member]
                members.sort(by: {
                    if $0.lastName! < $1.lastName! {return true}
                    return false
                })
                trackSpeakersState.tsSortedMembers = members
                
                fetchMembers(presenter: presenter, trackSpeakersState: trackSpeakersState, meetingGroupForRemainingTable: meetingGroup)
            }
        }
    }
    
    
    // Fetch members for remaining table after meeting group changes and after getting from restoration.
    class func fetchMembers(presenter: TrackSpeakersPresenter, trackSpeakersState: TrackSpeakersState, meetingGroupForRemainingTable: MeetingGroup?) {
        guard let meetingGroupForRemainingTable = meetingGroupForRemainingTable else { return}
        var members = meetingGroupForRemainingTable.groupMembers?.allObjects as! [Member]
        members.sort(by: {
            if $0.lastName! < $1.lastName! {
                return true
            }
            return false
        })
        
        var tempArray = [ListMember]()
        var count = 0
        members.forEach { member in
            tempArray.append(ListMember(row: count, member: member))
            count += 1
        }
        
        var tableCollection = TableCollection()
        tableCollection.remainingTable = TableWithSectionLists(table: 0, sectionLists: [SectionList(sectionNumber: 0, sectionType: .off, sectionMembers: tempArray)])
        tableCollection.waitingTable = TableWithSectionLists(table: 1, sectionLists: [SectionList(sectionNumber: 0, sectionType: .off, sectionMembers: [ListMember]())])
        tableCollection.speakingTable = TableWithSectionLists(table: 2, sectionLists: [SectionList(sectionNumber: 0, sectionType: .mainDebate, sectionMembers: [ListMember]())])
        trackSpeakersState.tableCollection = tableCollection
        
        presenter.presentMemberNames(tableCollection: trackSpeakersState.tableCollection)
    }
    
    
    class func fetchEntities(presenter: TrackSpeakersPresenter, entityState: EntityState, eventState: EventState, trackSpeakersState: TrackSpeakersState) {
        
    }
    
    func fetchEvents(eventState: EventState) {
        //        let eventState = eventState
        //        var events = [Event]()
        //        let fileManager = FileManager.default
        //        guard let docDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        //            print("TrackSpeakersInteractor: fetchEvents: error: Document directory not found")
        //            return
        //        }
        //        do {
        //            var eventUrls = [URL]()
        //            let fileURLs = try fileManager.contentsOfDirectory(at: docDirectory, includingPropertiesForKeys: nil)
        //            for url in fileURLs {
        //                if url.pathExtension == "evt" {
        //                    eventUrls.append(url)
        //                }
        //            }
        //            if eventUrls.count == 0 {
        //                print("count == 0")
        //                eventState.events = events
        //            }
        //            else {
        //                for eventUrl in eventUrls {
        //                    let eventDoc = EventDocument(fileURL: eventUrl)
        //                    eventDoc.open(completionHandler: { success in
        //                        if !success {
        //                            print("TrackSpeakersInteractor: fetchEvents: error opening EntityDocument")
        //                        }
        //                        else {
        //                            eventDoc.close(completionHandler: { success in
        //                                guard let event = eventDoc.event else {
        //                                    print("TrackSpeakersInteractor: fetchEvents: event is nil")
        //                                    return
        //                                }
        //                                events.append(event)
        //                                if events.count == eventUrls.count {
        //                                    //                                    self.events!.sort(by: {
        //                                    //                                        if $0.name! < $1.name! {
        //                                    //                                            return true
        //                                    //                                        }
        //                                    //                                        return false
        //                                    //                                    })
        //                                    eventState.events = events
        //                                }
        //                            })
        //                        }
        //                    })
        //                }
        //            }
        //        } catch {
        //            print("Error while enumerating files \(docDirectory.path): \(error.localizedDescription)")
        //        }
    }
    
    
    
    
    
    /// Called when user presses a speaking table member's play button or stop button
    /// - Parameters:
    ///   - trackSpeakersState: The EnvironmentObject: TrackSpeakersState
    ///   - memberTimerAction: Instance of MemberTimerActions
    class func setCurrentMemberTimerState(eventState: EventState, trackSpeakersState: TrackSpeakersState, memberTimerAction: MemberTimerActions) {
        
        if memberTimerAction.timerButtonPressed == .stop {
            trackSpeakersState.timerString = "00:00"
        }
        
        // Reconstruct TableCollection, adding
        
        let remainingList = trackSpeakersState.tableCollection.remainingTable
        let waitingList = trackSpeakersState.tableCollection.waitingTable
        var speakingList = trackSpeakersState.tableCollection.speakingTable
        
        let listMember = memberTimerAction.listMember
        let mode = memberTimerAction.timerButtonMode
        let timerIsActive = memberTimerAction.timerIsActive
        
        var newSectionLists = [SectionList]()
        
        // Iterate through all sectionLists in the Speaking table
        speakingList?.sectionLists.forEach({ sectionList in
            // If not the last section, simply use as is
            if sectionList != speakingList?.sectionLists.last {
                newSectionLists.append(sectionList)
            }
            else {
                
                // Get all members of the current (last) sectionList
                var newSectionListMembers = [ListMember]()
                let currentSpeakingListMembers = speakingList!.sectionLists.last!.sectionMembers
                
                // Iterate through them and update current member's timer
                currentSpeakingListMembers.forEach({ listMbr in
                    var newListMember = listMbr
                    if newListMember.member!.id == listMember.member!.id {
                        newListMember.timerButtonMode = mode
                        newListMember.timerIsActive = timerIsActive
                        if memberTimerAction.speakingTime != 0 {
                            newListMember.speakingTime = memberTimerAction.speakingTime
                        }
                        newListMember.startTime = memberTimerAction.listMember.startTime
                    }
                    newSectionListMembers.append(newListMember)
                })
                let newSectionList = SectionList(sectionNumber: sectionList.sectionNumber, sectionType: sectionList.sectionType, sectionMembers: newSectionListMembers)
                newSectionLists.append(newSectionList)
            }
        })
        
        // If recording a meeting event and the Stop button was pressed, handle recording the speech
        if trackSpeakersState.hasMeetingEvent == true && memberTimerAction.timerButtonPressed == .stop {
            
            // Get current debate
            let debate = EventState.debateWithIndex(index: eventState.currentDebateIndex!)
            
            // Get current debate section and compare with speaking table section number.
            // If different, create new debate section.
            var currentDebateSection = EventState.debateSectionWithIndex(index: eventState.currentDebateSectionIndex!)
            
            if currentDebateSection.sectionNumber < newSectionLists.last!.sectionNumber {
                // Create a new debate section
                let debateSection = EventState.createDebateSection()
                debateSection.idx = UUID()
                debateSection.sectionNumber = Int16(newSectionLists.last!.sectionNumber)
                debateSection.sectionName = newSectionLists.last!.sectionHeader
                currentDebateSection = debateSection
                eventState.currentDebateSectionIndex = debateSection.idx
            }
            
            // Create a speech event
            let speechEvent = EventState.createSpeechEvent()
            speechEvent.member = memberTimerAction.listMember.member
            speechEvent.elapsedMinutes = Int16(memberTimerAction.speakingTime / 60)
            speechEvent.elapsedSeconds = Int16(memberTimerAction.speakingTime % 60)
            speechEvent.startTime = listMember.startTime

            // Add speech event to current debate section speeches
            let speechSet = currentDebateSection.speeches!
            currentDebateSection.speeches = speechSet.adding(speechEvent) as NSSet
            
            // Add back the current debate section, now containing the new speech event
            debate.debateSections = debate.debateSections!.adding(currentDebateSection) as NSSet
            
            // Update current event
            let event = EventState.meetingEventWithIndex(index: eventState.currentMeetingEventIndex!)!
            event.debates = event.debates!.adding(debate) as NSSet
            
            EventState.saveManagedObjectContext()
        }
        
        speakingList = TableWithSectionLists(table: 2, sectionLists: newSectionLists)
        trackSpeakersState.tableCollection = TableCollection(remainingTable: remainingList, waitingTable: waitingList, speakingTable: speakingList)
    }
    
    class func addAmendment(trackSpeakersState: TrackSpeakersState, action: LongPressAction) {
        
        // Get tables
        var remainingList = trackSpeakersState.tableCollection.remainingTable
        var waitingList = trackSpeakersState.tableCollection.waitingTable
        var speakingList = trackSpeakersState.tableCollection.speakingTable
        
        // Build list of members for remaining table, not including the mover
        let mbrs = trackSpeakersState.tsSortedMembers
        var newRemMbrList = [ListMember]()
        var count = 0
        mbrs.forEach({ member in
            newRemMbrList.append(ListMember(row: count, member: member))
            count += 1
        })
        let membersNotIncluding = newRemMbrList.filter {$0.member!.idx != action.listMember.member!.idx}
        remainingList = TableWithSectionLists(table:0, sectionLists: [SectionList(sectionNumber: 0, sectionType: .off, sectionMembers: membersNotIncluding)])
        
        // Reset Waiting list
        waitingList = TableWithSectionLists(table: 1, sectionLists:  [SectionList(sectionNumber: 0, sectionType: .off,  sectionMembers: [ListMember]())])
        
        // Create new list for the amendment, for Speaking table
        var currentSpeakingSectionLists = speakingList!.sectionLists
        let sectionNumberLast = currentSpeakingSectionLists.last!.sectionNumber
        let newSectionList = SectionList(sectionNumber: sectionNumberLast + 1, sectionType: .amendment, sectionMembers: [ListMember]())
        currentSpeakingSectionLists.append(newSectionList)
        speakingList = TableWithSectionLists(table: 2, sectionLists: currentSpeakingSectionLists)
        
        // Add all lists to tableCollection
        trackSpeakersState.tableCollection = TableCollection(remainingTable: remainingList, waitingTable: waitingList, speakingTable: speakingList)
    }
    
    
    class func finaliseAmendment(trackSpeakersState: TrackSpeakersState, action: LongPressAction) {
        
        // Get tables
        var remainingList = trackSpeakersState.tableCollection.remainingTable
        var waitingList = trackSpeakersState.tableCollection.waitingTable
        var speakingList = trackSpeakersState.tableCollection.speakingTable
        
        // Build list of members for remaining table not including any who have spoken in main debate
        let mbrs = trackSpeakersState.tsSortedMembers
        var newRemMbrList = [ListMember]()
        var count = 0
        mbrs.forEach({ member in
            newRemMbrList.append(ListMember(row: count, member: member))
            count += 1
        })
        speakingList?.sectionLists.forEach({ sectionList in
            if sectionList.sectionType == .mainDebate {
                sectionList.sectionMembers.forEach({ listMember in
                    newRemMbrList.removeAll(where: {
                        listMember.member!.idx == $0.member!.idx
                    })
                })
            }
        })
        remainingList = TableWithSectionLists(table:0, sectionLists: [SectionList(sectionNumber: 0, sectionType: .off, sectionMembers: newRemMbrList)])
        
        // Reset waiting table list
        waitingList = TableWithSectionLists(table: 1, sectionLists:  [SectionList(sectionNumber: 0, sectionType: .off,  sectionMembers: [ListMember]())])
        var currentSpeakingSectionLists = speakingList!.sectionLists
        let sectionNumberLast = currentSpeakingSectionLists.last!.sectionNumber
        let newSectionList = SectionList(sectionNumber: sectionNumberLast + 1, sectionType: .mainDebate, sectionMembers: [ListMember]())
        currentSpeakingSectionLists.append(newSectionList)
        speakingList = TableWithSectionLists(table: 2, sectionLists: currentSpeakingSectionLists)
        trackSpeakersState.tableCollection = TableCollection(remainingTable: remainingList, waitingTable: waitingList, speakingTable: speakingList)
    }
    
    
    class func reset(trackSpeakersState: TrackSpeakersState) {
        let mbrs = trackSpeakersState.tsSortedMembers
        
        var newRemMbrList = [ListMember]()
        var count = 0
        mbrs.forEach({ member in
            newRemMbrList.append(ListMember(row: count, member: member))
            count += 1
        })
        let sectionLists = [SectionList(sectionNumber: 0,  sectionType: .off, sectionMembers: newRemMbrList)]
        let remainingList = TableWithSectionLists(table:0, sectionLists: sectionLists )
        let waitingList = TableWithSectionLists(table: 1, sectionLists: [SectionList(sectionNumber: 0,  sectionType: .off, sectionMembers: [ListMember]())])
        let speakingList = TableWithSectionLists(table: 2, sectionLists: [SectionList(sectionNumber: 0,  sectionType: .mainDebate, sectionMembers: [ListMember]())])
        trackSpeakersState.tableCollection = TableCollection(remainingTable: remainingList, waitingTable: waitingList, speakingTable: speakingList)
    }
    
    
    /// Saves current debate to TrackSpeakersState current event.
    ///
    /// Note that speaker events are saved when Stop is pressed by setCurrentMemberTimerState.
    /// - Parameter trackSpeakersState: TrackSpeakersState
    static func saveDebate(eventState: EventState, trackSpeakersState: TrackSpeakersState) {
        
        // Add debate to meeting event and save to CoreData
        let debate = EventState.debateWithIndex(index: eventState.currentDebateIndex!)
        let currentEvent = EventState.meetingEventWithIndex(index: eventState.currentMeetingEventIndex!)!
        currentEvent.debates = currentEvent.debates!.adding(debate) as NSSet
        
        // Create a new debate
        let newDebate = EventState.createDebate()
        newDebate.idx = UUID()
        newDebate.debateNumber = debate.debateNumber + 1
        newDebate.note = nil
        newDebate.debateSections = Set<DebateSection>() as NSSet
        
        // Create a new debate section
        let debateSection = EventState.createDebateSection()
        debateSection.idx = UUID()
        debateSection.sectionNumber = 0
        debateSection.sectionName = "Main debate"
//        debateSection.sectionOfDebate = newDebate
        
        // Initialise speech events
        let speechEvents = Set<SpeechEvent>()
        debateSection.speeches = speechEvents as NSSet
        
        // Add new debate section to the debate
        newDebate.debateSections = newDebate.debateSections!.adding(debateSection) as NSSet
     
        // Add the debate to the meeting event
        currentEvent.debates = currentEvent.debates?.adding(newDebate) as NSSet?
        
        EventState.saveManagedObjectContext()
        
        eventState.currentDebateIndex = newDebate.idx
        print("currentDebateIndex: \(newDebate.idx!)")
        eventState.currentDebateSectionIndex = debateSection.idx
        
        TrackSpeakersInteractor.reset(trackSpeakersState: trackSpeakersState)
    }
    
    static func saveMeetingEvent(eventState: EventState) {
        
        // Check if have a hanging new debate with one section and no speeches
        let currentDebateSection = EventState.debateSectionWithIndex(index: eventState.currentDebateSectionIndex!)
        if currentDebateSection.speeches?.count == 0 {
            EventState.deleteDebateFromCurrentMeeting(meetingIndex: eventState.currentMeetingEventIndex!, debateIndex: eventState.currentDebateIndex!)
        }

    }
    
    
    
    // MARK: - Instance methods
    
    func moveMember(moveAction: MoveMemberAction, trackSpeakersState: TrackSpeakersState) {
        self.remainingList = trackSpeakersState.tableCollection.remainingTable
        self.waitingList = trackSpeakersState.tableCollection.waitingTable
        self.speakingList = trackSpeakersState.tableCollection.speakingTable
        
        switch moveAction.direction {
        case .right :
            moveMemberRight(sourceTable: moveAction.sourceTable, listMember: moveAction.listMember, fromSectionListNumber: moveAction.sourceSectionListNumber)
        case .left :
            moveMemberLeft(sourceTable: moveAction.sourceTable, listMember: moveAction.listMember, fromSectionListNumber: moveAction.sourceSectionListNumber)
        }
        trackSpeakersState.tableCollection = TableCollection(remainingTable: remainingList, waitingTable: waitingList, speakingTable: speakingList)
        
    }
    
    
    // MARK: Helper methods
    
    func moveMemberRight(sourceTable: Int, listMember: ListMember, fromSectionListNumber: Int) {
        switch sourceTable {
        case 0:
            self.remainingList = removeMember(from: remainingList!, listMember: listMember, fromSectionNumber: fromSectionListNumber)
            self.waitingList = addMember(to: waitingList!, listMember: listMember, toSectionNumber: fromSectionListNumber)
        case 1:
            self.waitingList = removeMember(from: waitingList!, listMember: listMember, fromSectionNumber: fromSectionListNumber)
            self.speakingList = addMember(to: speakingList!, listMember: listMember, toSectionNumber: (speakingList?.sectionLists.last!.sectionNumber)!)
        default:
            return
        }
    }
    
    func moveMemberLeft(sourceTable: Int, listMember: ListMember, fromSectionListNumber: Int) {
        switch sourceTable {
        case 1:
            self.waitingList = removeMember(from: waitingList!, listMember: listMember, fromSectionNumber: fromSectionListNumber)
            self.remainingList = addMember(to: remainingList!, listMember: listMember, toSectionNumber: 0)
            sortRemainingList()
        case 2:
            self.speakingList = removeMember(from: speakingList!, listMember: listMember, fromSectionNumber: fromSectionListNumber)
            self.waitingList = addMember(to: waitingList!, listMember: listMember, toSectionNumber: 0)
        default:
            return
        }
    }
    
    func removeMember(from: TableWithSectionLists, listMember: ListMember, fromSectionNumber: Int) -> TableWithSectionLists {
        let memberToRemove = listMember
        let currentSectionLists = from.sectionLists
        var newSectionListMembers = [ListMember]()
        let currentSectionListMembers = from.sectionLists[fromSectionNumber].sectionMembers
        currentSectionListMembers.forEach { listMember in
            if listMember.member?.id != memberToRemove.member?.id {
                newSectionListMembers.append(listMember)
            }
        }
        var newSectionLists = [SectionList]()
        currentSectionLists.forEach({ sectionList in
            if sectionList.sectionNumber == fromSectionNumber {
                newSectionLists.append(SectionList(sectionNumber: fromSectionNumber,  sectionType: sectionList.sectionType, sectionMembers: newSectionListMembers))
            }
        })
        
        return TableWithSectionLists(table: from.table, sectionLists: newSectionLists)
    }
    
    
    func addMember(to: TableWithSectionLists, listMember: ListMember, toSectionNumber: Int) -> TableWithSectionLists {
        let memberToAdd = listMember
        let currentSectionLists = to.sectionLists
        var newSectionLists = [SectionList]()
        currentSectionLists.forEach({ sectionList in
            if sectionList.sectionNumber == toSectionNumber {
                var newSectionList = sectionList
                newSectionList.sectionMembers.append(memberToAdd)
                newSectionLists.append(SectionList(sectionNumber: toSectionNumber, sectionType: sectionList.sectionType, sectionMembers: newSectionList.sectionMembers))
            }
            else {
                newSectionLists.append(sectionList)
            }
        })
        return TableWithSectionLists(table: to.table, sectionLists: newSectionLists)
    }
    
    func sortRemainingList() {
        var remList = self.remainingList
        remList?.sectionLists[0].sectionMembers.sort(by: {
            if $0.member!.lastName! < $1.member!.lastName! {return true}
            return false
        })
        self.remainingList = remList
    }
}

