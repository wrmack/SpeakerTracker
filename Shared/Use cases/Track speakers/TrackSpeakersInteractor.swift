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
    var presenter: TrackSpeakersPresenter?
    var remainingList: SpeakerListWithSections?
    var waitingList: SpeakerListWithSections?
    var speakingList: SpeakerListWithSections?
    private var speakingListNumberOfSections = 1
    
    func fetchMembers(presenter: TrackSpeakersPresenter, tableCollection: TableCollection) {
        presenter.presentMemberNames(tableCollection: tableCollection)
    }
    
    // Fetch members for remaining table after meeting group changes.
    func fetchMembers(presenter: TrackSpeakersPresenter, trackSpeakersState: TrackSpeakersState, meetingGroupForRemainingTable: MeetingGroup?) {
//        guard let meetingGroupForRemainingTable = meetingGroupForRemainingTable else { return}
//        let entity = trackSpeakersState.currentEntity
//        var members = [Member]()
//
//        meetingGroupForRemainingTable.members?.forEach({ id in
//            entity?.members?.forEach({ member in
////                if member.id == id {
//                    members.append(member)
////                }
//            })
//        })
//        var tempArray = [ListMember]()
//        var count = 0
//        members.forEach { member in
//            tempArray.append(ListMember(row: count, member: member))
//            count += 1
//        }
//        var tableCollection = TableCollection()
//        tableCollection.remainingTable = SpeakerListWithSections(table: 0, sectionLists: [SectionList(sectionNumber: 0, sectionType: .off, sectionMembers: tempArray)])
//        tableCollection.waitingTable = SpeakerListWithSections(table: 1, sectionLists: [SectionList(sectionNumber: 0, sectionType: .off, sectionMembers: [ListMember]())])
//        tableCollection.speakingTable = SpeakerListWithSections(table: 2, sectionLists: [SectionList(sectionNumber: 0, sectionType: .mainDebate, sectionMembers: [ListMember]())])
//        trackSpeakersState.tableCollection = tableCollection
//
//        presenter.presentMemberNames(tableCollection: trackSpeakersState.tableCollection)
    }
    
    // Initial presentation uses the currentMeetingGroup property in TrackSpeakersState
    func fetchMembers(presenter: TrackSpeakersPresenter, entityState: EntityState, eventState: EventState, trackSpeakersState: TrackSpeakersState) {
//        if entityState.entities.count == 0 {
//            fetchEntities(presenter: presenter, entityState: entityState, eventState: eventState,trackSpeakersState: trackSpeakersState)
//        }
//        else {
//            guard let currentMeetingGroup = trackSpeakersState.currentMeetingGroup else {return}
//            fetchMembers(presenter: presenter, trackSpeakersState: trackSpeakersState, meetingGroupForRemainingTable: currentMeetingGroup)
//        }

    }
    
    
    func fetchEntities(presenter: TrackSpeakersPresenter, entityState: EntityState, eventState: EventState, trackSpeakersState: TrackSpeakersState) {
//        let entityState = entityState
//        var entities = [Entity]()
//
//        let fileManager = FileManager.default
//        guard let docDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            print("DisplayEntitiesInteractor: fetchEntities: error: Document directory not found")
//            return
//        }
//        do {
//            var entityUrls = [URL]()
//            let fileURLs = try fileManager.contentsOfDirectory(at: docDirectory, includingPropertiesForKeys: nil)
//            for url in fileURLs {
//                if url.pathExtension == "ent" {
//                    entityUrls.append(url)
//                }
//            }
//            if entityUrls.count == 0 {
//                print("count == 0")
//            }
//            else {
//                for entityUrl in entityUrls {
//                    let entityDoc = EntityDocument(fileURL: entityUrl)
//                    entityDoc.open(completionHandler: { success in
//                        if !success {
//                            print("DisplayEntitiesInteractor: fetchEntities: error opening EntityDocument")
//                        }
//                        else {
//                            entityDoc.close(completionHandler: { [self] success in
//                                guard let entity = entityDoc.entity else {
//                                    print("DisplayEntitiesInteractor: fetchEntities: entity is nil")
//                                    return
//                                }
//                                entities.append(entity)
//                                if entities.count == entityUrls.count {
//                                    entities.sort(by: {
//                                        if $0.name! < $1.name! {
//                                            return true
//                                        }
//                                        return false
//                                    })
//                                    entityState.entities = entities
//                                    let entity = entityState.entities[0] // Choose first entity for time being
//                                    trackSpeakersState.currentEntity = entity
//                                    guard let members = entity.members else { print("TrackSpeakersInteractor: no members"); return }
//                                    var tempArray = [ListMember]()
//                                    var count = 0
//                                    members.forEach { member in
//                                        tempArray.append(ListMember(row: count, member: member))
//                                        count += 1
//                                    }
//                                    trackSpeakersState.tableCollection.remainingTable = SpeakerListWithSections(table: 0, sectionLists: [SectionList(sectionNumber: 0, sectionType: .off, sectionMembers: tempArray)])
//                                    presenter.presentMemberNames(members: members)
//                                    self.fetchEvents(eventState: eventState)
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

    
    /// Called when user presses a speaking table member's play button or stop button
    /// - Parameters:
    ///   - trackSpeakersState: The EnvironmentObject: TrackSpeakersState
    ///   - memberTimerAction: Instance of MemberTimerActions
//    func setCurrentMemberTimerState(trackSpeakersState: TrackSpeakersState, memberTimerAction: MemberTimerActions) {
//        
//        if trackSpeakersState.currentEvent != nil && memberTimerAction.timerButtonPressed == .stop {
//            var debate = trackSpeakersState.currentDebate
//            let speakerEvent = SpeakerEvent(
//                member: memberTimerAction.listMember.member,
//                elapsedMinutes: Int(memberTimerAction.speakingTime / 60),
//                elapsedSeconds: Int(memberTimerAction.speakingTime % 60),
//                startTime: nil
//            )
//            var currentSection = debate!.debateSections!.removeLast()
//            currentSection.speakerEvents!.append(speakerEvent)
//            debate!.debateSections!.append(currentSection)
//            trackSpeakersState.currentDebate = debate
//        }
//        if memberTimerAction.timerButtonPressed == .stop {
//            trackSpeakersState.timerString = "00:00"
//        }
//        self.remainingList = trackSpeakersState.tableCollection.remainingTable
//        self.waitingList = trackSpeakersState.tableCollection.waitingTable
//        self.speakingList = trackSpeakersState.tableCollection.speakingTable
//        
//        let listMember = memberTimerAction.listMember
//        let mode = memberTimerAction.timerButtonMode
//        let timerIsActive = memberTimerAction.timerIsActive
//        
//        var newSectionLists = [SectionList]()
//        
//        speakingList?.sectionLists.forEach({ sectionList in
//            if sectionList != speakingList?.sectionLists.last {
//                newSectionLists.append(sectionList)
//            }
//            else {
//                
//                var newSectionListMembers = [ListMember]()
//                let currentSpeakingListMembers = speakingList!.sectionLists.last!.sectionMembers
//                
//                currentSpeakingListMembers.forEach({ listMbr in
//                    var newListMember = listMbr
//                    if newListMember.member!.id  == listMember.member!.id {
//                        newListMember.timerButtonMode = mode
//                        newListMember.timerIsActive = timerIsActive
//                        if memberTimerAction.speakingTime != 0 {
//                            newListMember.speakingTime = memberTimerAction.speakingTime
//                        }
//                    }
//                    newSectionListMembers.append(newListMember)
//                })
//                let newSectionList = SectionList(sectionNumber: sectionList.sectionNumber, sectionType: sectionList.sectionType, sectionMembers: newSectionListMembers)
//                newSectionLists.append(newSectionList)
//            }
//            
//        })
//        
//        speakingList = SpeakerListWithSections(table: 2, sectionLists: newSectionLists)
//        trackSpeakersState.tableCollection = TableCollection(remainingTable: remainingList, waitingTable: waitingList, speakingTable: speakingList)
//    }
    
    func addAmendment(trackSpeakersState: TrackSpeakersState, action: LongPressAction) {
//        self.remainingList = trackSpeakersState.tableCollection.remainingTable
//        self.waitingList = trackSpeakersState.tableCollection.waitingTable
//        self.speakingList = trackSpeakersState.tableCollection.speakingTable
//
//        let mbrs = trackSpeakersState.currentEntity?.members
//        var newRemMbrList = [ListMember]()
//        var count = 0
//        mbrs?.forEach({ member in
//            newRemMbrList.append(ListMember(row: count, member: member))
//            count += 1
//        })
//        let membersNotIncluding = newRemMbrList.filter {$0 != action.member}
//        remainingList = SpeakerListWithSections(table:0, sectionLists: [SectionList(sectionNumber: 0, sectionType: .off, sectionMembers: membersNotIncluding)])
//        waitingList = SpeakerListWithSections(table: 1, sectionLists:  [SectionList(sectionNumber: 0, sectionType: .off,  sectionMembers: [ListMember]())])
//        var currentSpeakingSectionLists = speakingList!.sectionLists
//        let sectionNumberLast = currentSpeakingSectionLists.last!.sectionNumber
//        let newSectionList = SectionList(sectionNumber: sectionNumberLast + 1, sectionType: .amendment, sectionMembers: [ListMember]())
//        currentSpeakingSectionLists.append(newSectionList)
//        speakingList = SpeakerListWithSections(table: 2, sectionLists: currentSpeakingSectionLists)
//        trackSpeakersState.tableCollection = TableCollection(remainingTable: remainingList, waitingTable: waitingList, speakingTable: speakingList)
    }
    
    func finaliseAmendment(trackSpeakersState: TrackSpeakersState, action: LongPressAction) {
//        self.remainingList = trackSpeakersState.tableCollection.remainingTable
//        self.waitingList = trackSpeakersState.tableCollection.waitingTable
//        self.speakingList = trackSpeakersState.tableCollection.speakingTable
//
//        let mbrs = trackSpeakersState.currentEntity?.members
//        var newRemMbrList = [ListMember]()
//        var count = 0
//        mbrs?.forEach({ member in
//            newRemMbrList.append(ListMember(row: count, member: member))
//            count += 1
//        })
//        speakingList?.sectionLists.forEach({ sectionList in
//            if sectionList.sectionType == .mainDebate {
//                sectionList.sectionMembers.forEach({ listMember in
//                    newRemMbrList.removeAll(where: {
//                        listMember == $0
//                    })
//                })
//            }
//        })
//        remainingList = SpeakerListWithSections(table:0, sectionLists: [SectionList(sectionNumber: 0, sectionType: .off, sectionMembers: newRemMbrList)])
//        waitingList = SpeakerListWithSections(table: 1, sectionLists:  [SectionList(sectionNumber: 0, sectionType: .off,  sectionMembers: [ListMember]())])
//        var currentSpeakingSectionLists = speakingList!.sectionLists
//        let sectionNumberLast = currentSpeakingSectionLists.last!.sectionNumber
//        let newSectionList = SectionList(sectionNumber: sectionNumberLast + 1, sectionType: .mainDebate, sectionMembers: [ListMember]())
//        currentSpeakingSectionLists.append(newSectionList)
//        speakingList = SpeakerListWithSections(table: 2, sectionLists: currentSpeakingSectionLists)
//        trackSpeakersState.tableCollection = TableCollection(remainingTable: remainingList, waitingTable: waitingList, speakingTable: speakingList)
//
        
    }
    
    func reset(trackSpeakersState: TrackSpeakersState) {
//        let mbrs = trackSpeakersState.currentEntity?.members
//        var newRemMbrList = [ListMember]()
//        var count = 0
//        mbrs?.forEach({ member in
//            newRemMbrList.append(ListMember(row: count, member: member))
//            count += 1
//        })
//        let sectionLists = [SectionList(sectionNumber: 0,  sectionType: .off, sectionMembers: newRemMbrList)]
//        remainingList = SpeakerListWithSections(table:0, sectionLists: sectionLists )
//        waitingList = SpeakerListWithSections(table: 1, sectionLists: [SectionList(sectionNumber: 0,  sectionType: .off, sectionMembers: [ListMember]())])
//        speakingList = SpeakerListWithSections(table: 2, sectionLists: [SectionList(sectionNumber: 0,  sectionType: .mainDebate, sectionMembers: [ListMember]())])
//        trackSpeakersState.tableCollection = TableCollection(remainingTable: remainingList, waitingTable: waitingList, speakingTable: speakingList)
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
    
}

