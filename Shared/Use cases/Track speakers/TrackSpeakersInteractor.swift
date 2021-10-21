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
    var remainingList: SpeakerListWithSections?
    var waitingList: SpeakerListWithSections?
    var speakingList: SpeakerListWithSections?
    private var speakingListNumberOfSections = 1
    
    // MARK: - Class methods
    class func fetchMembers(presenter: TrackSpeakersPresenter, tableCollection: TableCollection) {
        presenter.presentMemberNames(tableCollection: tableCollection)
    }
    
    
    /// Fetches members for initial presentation if saved in `RestorationState`.
    ///
    /// Called by `.onAppear`.
    ///
    /// If `TrackSpeakersState` does not hold a `currentEntity` or `currentMeetingGroup`, checks if a `MeetingGroup` is saved in `RestorationState`
    /// and, if so, sends to `fetchMembers(presenter:, trackSpeakersState:, meetingGroupForRemainingTable:)`. Otherwise
    /// does nothing.
    class func fetchMembers(presenter: TrackSpeakersPresenter, eventState: EventState, trackSpeakersState: TrackSpeakersState) {
        if trackSpeakersState.currentEntity == nil || trackSpeakersState.currentMeetingGroup == nil {
            let savedStateIndices = RestorationState.getSpeakerTrackerState()
            if savedStateIndices.0 != nil && savedStateIndices.1 != nil {
                let entity = EntityState.entityWithIndex(index: savedStateIndices.0!)
                trackSpeakersState.currentEntity = entity
                let meetingGroup = EntityState.meetingGroupWithIndex(index: savedStateIndices.1!)
                trackSpeakersState.currentMeetingGroup = meetingGroup
                fetchMembers(presenter: presenter, trackSpeakersState: trackSpeakersState, meetingGroupForRemainingTable: meetingGroup)
            }
        }
    }
    
    
    // Fetch members for remaining table after meeting group changes.
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
        tableCollection.remainingTable = SpeakerListWithSections(table: 0, sectionLists: [SectionList(sectionNumber: 0, sectionType: .off, sectionMembers: tempArray)])
        tableCollection.waitingTable = SpeakerListWithSections(table: 1, sectionLists: [SectionList(sectionNumber: 0, sectionType: .off, sectionMembers: [ListMember]())])
        tableCollection.speakingTable = SpeakerListWithSections(table: 2, sectionLists: [SectionList(sectionNumber: 0, sectionType: .mainDebate, sectionMembers: [ListMember]())])
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
    class func setCurrentMemberTimerState(trackSpeakersState: TrackSpeakersState, memberTimerAction: MemberTimerActions) {
        
        if trackSpeakersState.currentEvent != nil && memberTimerAction.timerButtonPressed == .stop {
            let debate = trackSpeakersState.currentDebate
            let speakerEvent = EventState.createSpeechEvent()
            speakerEvent.member = memberTimerAction.listMember.member
            speakerEvent.elapsedMinutes = Int16(memberTimerAction.speakingTime / 60)
            speakerEvent.elapsedSeconds = Int16(memberTimerAction.speakingTime % 60)
            speakerEvent.startTime = nil
            
            var debateSections = debate?.debateSections?.allObjects as? [DebateSection]
            let currentSection = debateSections!.removeLast()
            
            var speeches = currentSection.speeches!.allObjects as! [SpeechEvent]
            speeches.append(speakerEvent)
            //            debate!.debateSections!.append(currentSection)
            //            trackSpeakersState.currentDebate = debate
        }
        if memberTimerAction.timerButtonPressed == .stop {
            trackSpeakersState.timerString = "00:00"
        }
        let remainingList = trackSpeakersState.tableCollection.remainingTable
        let waitingList = trackSpeakersState.tableCollection.waitingTable
        var speakingList = trackSpeakersState.tableCollection.speakingTable
        
        let listMember = memberTimerAction.listMember
        let mode = memberTimerAction.timerButtonMode
        let timerIsActive = memberTimerAction.timerIsActive
        
        var newSectionLists = [SectionList]()
        
        speakingList?.sectionLists.forEach({ sectionList in
            if sectionList != speakingList?.sectionLists.last {
                newSectionLists.append(sectionList)
            }
            else {
                
                var newSectionListMembers = [ListMember]()
                let currentSpeakingListMembers = speakingList!.sectionLists.last!.sectionMembers
                
                currentSpeakingListMembers.forEach({ listMbr in
                    var newListMember = listMbr
                    if newListMember.member!.id  == listMember.member!.id {
                        newListMember.timerButtonMode = mode
                        newListMember.timerIsActive = timerIsActive
                        if memberTimerAction.speakingTime != 0 {
                            newListMember.speakingTime = memberTimerAction.speakingTime
                        }
                    }
                    newSectionListMembers.append(newListMember)
                })
                let newSectionList = SectionList(sectionNumber: sectionList.sectionNumber, sectionType: sectionList.sectionType, sectionMembers: newSectionListMembers)
                newSectionLists.append(newSectionList)
            }
            
        })
        
        speakingList = SpeakerListWithSections(table: 2, sectionLists: newSectionLists)
        trackSpeakersState.tableCollection = TableCollection(remainingTable: remainingList, waitingTable: waitingList, speakingTable: speakingList)
    }
    
    class func addAmendment(trackSpeakersState: TrackSpeakersState, action: LongPressAction) {
        var remainingList = trackSpeakersState.tableCollection.remainingTable
        var waitingList = trackSpeakersState.tableCollection.waitingTable
        var speakingList = trackSpeakersState.tableCollection.speakingTable
        
        //        let mbrs = trackSpeakersState.currentEntity?.members
        let mbrs = trackSpeakersState.currentMeetingGroup?.groupMembers
        var newRemMbrList = [ListMember]()
        var count = 0
        mbrs!.forEach({ element in
            let member = element as! Member
            newRemMbrList.append(ListMember(row: count, member: member))
            count += 1
        })
        let membersNotIncluding = newRemMbrList.filter {$0 != action.member}
        remainingList = SpeakerListWithSections(table:0, sectionLists: [SectionList(sectionNumber: 0, sectionType: .off, sectionMembers: membersNotIncluding)])
        waitingList = SpeakerListWithSections(table: 1, sectionLists:  [SectionList(sectionNumber: 0, sectionType: .off,  sectionMembers: [ListMember]())])
        var currentSpeakingSectionLists = speakingList!.sectionLists
        let sectionNumberLast = currentSpeakingSectionLists.last!.sectionNumber
        let newSectionList = SectionList(sectionNumber: sectionNumberLast + 1, sectionType: .amendment, sectionMembers: [ListMember]())
        currentSpeakingSectionLists.append(newSectionList)
        speakingList = SpeakerListWithSections(table: 2, sectionLists: currentSpeakingSectionLists)
        trackSpeakersState.tableCollection = TableCollection(remainingTable: remainingList, waitingTable: waitingList, speakingTable: speakingList)
    }
    
    
    class func finaliseAmendment(trackSpeakersState: TrackSpeakersState, action: LongPressAction) {
        var remainingList = trackSpeakersState.tableCollection.remainingTable
        var waitingList = trackSpeakersState.tableCollection.waitingTable
        var speakingList = trackSpeakersState.tableCollection.speakingTable
        
        let mbrs = trackSpeakersState.currentMeetingGroup?.groupMembers
        var newRemMbrList = [ListMember]()
        var count = 0
        mbrs?.forEach({ element in
            let member = element as! Member
            newRemMbrList.append(ListMember(row: count, member: member))
            count += 1
        })
        speakingList?.sectionLists.forEach({ sectionList in
            if sectionList.sectionType == .mainDebate {
                sectionList.sectionMembers.forEach({ listMember in
                    newRemMbrList.removeAll(where: {
                        listMember == $0
                    })
                })
            }
        })
        remainingList = SpeakerListWithSections(table:0, sectionLists: [SectionList(sectionNumber: 0, sectionType: .off, sectionMembers: newRemMbrList)])
        waitingList = SpeakerListWithSections(table: 1, sectionLists:  [SectionList(sectionNumber: 0, sectionType: .off,  sectionMembers: [ListMember]())])
        var currentSpeakingSectionLists = speakingList!.sectionLists
        let sectionNumberLast = currentSpeakingSectionLists.last!.sectionNumber
        let newSectionList = SectionList(sectionNumber: sectionNumberLast + 1, sectionType: .mainDebate, sectionMembers: [ListMember]())
        currentSpeakingSectionLists.append(newSectionList)
        speakingList = SpeakerListWithSections(table: 2, sectionLists: currentSpeakingSectionLists)
        trackSpeakersState.tableCollection = TableCollection(remainingTable: remainingList, waitingTable: waitingList, speakingTable: speakingList)
    }
    
    
    class func reset(trackSpeakersState: TrackSpeakersState) {
        var mbrs = trackSpeakersState.currentMeetingGroup?.groupMembers?.allObjects as! [Member]
        mbrs.sort(by: {
            if $0.lastName! < $1.lastName! {return true}
            return false
        })
        var newRemMbrList = [ListMember]()
        var count = 0
        mbrs.forEach({ member in
            newRemMbrList.append(ListMember(row: count, member: member))
            count += 1
        })
        let sectionLists = [SectionList(sectionNumber: 0,  sectionType: .off, sectionMembers: newRemMbrList)]
        let remainingList = SpeakerListWithSections(table:0, sectionLists: sectionLists )
        let waitingList = SpeakerListWithSections(table: 1, sectionLists: [SectionList(sectionNumber: 0,  sectionType: .off, sectionMembers: [ListMember]())])
        let speakingList = SpeakerListWithSections(table: 2, sectionLists: [SectionList(sectionNumber: 0,  sectionType: .mainDebate, sectionMembers: [ListMember]())])
        trackSpeakersState.tableCollection = TableCollection(remainingTable: remainingList, waitingTable: waitingList, speakingTable: speakingList)
    }
    
    
    /// Saves current debate to TrackSpeakersState current event.
    ///
    /// Note that speaker events are saved when Stop is pressed by setCurrentMemberTimerState.
    /// - Parameter trackSpeakersState: TrackSpeakersState
    func saveDebateToTrackSpeakersState(trackSpeakersState: TrackSpeakersState) {
        //        let debate = trackSpeakersState.currentDebate!
        //        trackSpeakersState.currentEvent?.debates?.append(debate)
        //        // Initialise for next debate
        //        trackSpeakersState.currentDebate = Debate(debateNumber: debate.debateNumber! + 1, note: nil, debateSections: [DebateSection(sectionNumber: 0, sectionName: "Main debate", speakerEvents: [SpeakerEvent]())])
        //        reset(trackSpeakersState: trackSpeakersState)
    }
    
    func saveEventToDisk(trackSpeakersState: TrackSpeakersState) {
        //        let event = trackSpeakersState.currentEvent!
        //        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        //            print("Error: Document directory not found")
        //            return
        //        }
        //
        //        let docFileURL =  documentsDirectory.appendingPathComponent(event.filename! + ".evt")
        //        let eventDoc = EventDocument(fileURL: docFileURL, name: event.filename, event: event)
        //        eventDoc.save(to: docFileURL, for: .forCreating, completionHandler: { success in
        //            if !success {
        //                print("TrackSpeakersInteractor: saveEventToDisk: Error saving")
        //            }
        //            else{
        //                print("TrackSpeakersInteractor: saveEventToDisk: Saving successful")
        //            }
        //        })
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
    
    func removeMember(from: SpeakerListWithSections, listMember: ListMember, fromSectionNumber: Int) -> SpeakerListWithSections {
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
        
        return SpeakerListWithSections(table: from.table, sectionLists: newSectionLists)
    }
    
    
    func addMember(to: SpeakerListWithSections, listMember: ListMember, toSectionNumber: Int) -> SpeakerListWithSections {
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
        return SpeakerListWithSections(table: to.table, sectionLists: newSectionLists)
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

