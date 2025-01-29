//
//  MeetingSetupInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 18/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation


class MeetingSetupInteractor {
    
    /// Returns a tuple of `entityName`and an array of `meetingGroupNames`
    ///
//    class func fetchEntityForRow(entityState: EntityState, trackSpeakersState: TrackSpeakersState, row: Int) -> (String, [String]) {
    class func fetchEntityForRow(entityState: EntityState, trackSpeakersState: TrackSpeakersState, row: Int) -> (String, [(String,UUID)]) {
        let currentEntity = EntityState.sortedEntities![row]
        entityState.currentEntityIndex = currentEntity.idx
        let entityName = currentEntity.name!
        
        let meetingGroups = EntityState.sortedMeetingGroups(entityIndex: currentEntity.idx!)
//        var meetingGroupNames = [String]()
//        meetingGroups?.forEach({ meetingGroup in
//            meetingGroupNames.append(meetingGroup.name!)
//        })
//        
        // New
        var meetingGroupNamesWithId = [(String,UUID)]()
        meetingGroups?.forEach({ meetingGroup in
            meetingGroupNamesWithId.append((meetingGroup.name!,meetingGroup.idx!))
        })
        
        
//        return (entityName, meetingGroupNames)
        return (entityName, meetingGroupNamesWithId)
    }
    
    class func fetchMeetingGroupForRow(entityState: EntityState, trackSpeakersState: TrackSpeakersState, row: Int) -> (String, [String]) {

        // Set the current meeting group in EntityState
        let currentEntityIndex = entityState.currentEntityIndex!
        let currentMeetingGroup = EntityState.sortedMeetingGroups(entityIndex: currentEntityIndex)![row]
        entityState.currentMeetingGroupIndex = currentMeetingGroup.idx
        
        // Set TrackSpeakerState tsSortedMembers property
        var members = currentMeetingGroup.groupMembers?.allObjects as! [Member]
        members.sort(by: {
            if $0.lastName! < $1.lastName! {return true}
            return false
        })
        trackSpeakersState.tsSortedMembers = members
       
        // Save currentEntity and currentMeetingGroup to CoreData
        RestorationState.saveSpeakerTrackerState(entityIndex: currentEntityIndex, meetingGroupIndex: currentMeetingGroup.idx!)
        
        // Get meeting events for returning names
        let meetingEvents = EventState.sortedMeetingEvents(meetingGroupIndex: currentMeetingGroup.idx!)
        var meetingEventNames = [String]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
       
        meetingEvents?.forEach({ meetingEvent in
            let dateString = dateFormatter.string(from: meetingEvent.date!)
            let timeString = timeFormatter.string(from: meetingEvent.date!)
            meetingEventNames.append("\(dateString), \(timeString)")
        })
        
        trackSpeakersState.meetingGroupHasChanged = true
        
        return (currentMeetingGroup.name!, meetingEventNames)
    }
    
    class func setCurrentMeetingEvent(entityState: EntityState, trackSpeakersState: TrackSpeakersState, eventState: EventState, row: Int)  {
        
        // Get the event from those that have been setup
        let event = EventState.sortedMeetingEvents(meetingGroupIndex: entityState.currentMeetingGroupIndex!)![row]
        
        // Create a new debate
        let debate = EventState.createDebate()
        debate.idx = UUID()
        debate.debateNumber = 0
        debate.note = nil
        debate.debateSections = Set<DebateSection>() as NSSet
        
        // Create a new debate section and add it to the debate
        let debateSection = EventState.createDebateSection()
        debateSection.idx = UUID()
        debateSection.sectionNumber = 0
        debateSection.sectionName = "Main debate"
        let speechEvents = Set<SpeechEvent>()
        debateSection.speeches = speechEvents as NSSet
        debate.debateSections = debate.debateSections!.adding(debateSection) as NSSet

        // Add the whole debate to the meeting event
        event.debates = Set<Debate>() as NSSet
        event.debates = event.debates?.adding(debate) as NSSet?
        
        EventState.saveManagedObjectContext()
        
        eventState.currentMeetingEventIndex = event.idx
        eventState.currentDebateIndex = debate.idx
        eventState.currentDebateSectionIndex = debateSection.idx
        trackSpeakersState.hasMeetingEvent = true
    }
    
    class func fetchEntityNames(entityState: EntityState, presenter: MeetingSetupPresenter) -> [String] {
        let currentEntity = entityState.currentEntity
        let currentMeetingGroup = entityState.currentMeetingGroup
        presenter.presentSetup(currentEntity: currentEntity, currentMeetingGroup:  currentMeetingGroup)
        
        var entityNames = [String]()
        EntityState.sortedEntities?.forEach({entity in
            entityNames.append(entity.name!)
        })
        return entityNames
    }
    
}
