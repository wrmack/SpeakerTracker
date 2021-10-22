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
    class func fetchEntityForRow(entityState: EntityState, trackSpeakersState: TrackSpeakersState, row: Int) -> (String, [String]) {
        let currentEntity = EntityState.sortedEntities![row]
        trackSpeakersState.currentEntity = currentEntity
        let entityName = currentEntity.name!
        
        let meetingGroups = EntityState.sortedMeetingGroups(entityIndex: currentEntity.idx!)
        var meetingGroupNames = [String]()
        meetingGroups?.forEach({ meetingGroup in
            meetingGroupNames.append(meetingGroup.name!)
        })
        return (entityName, meetingGroupNames)
    }
    
    class func fetchMeetingGroupForRow(trackSpeakersState: TrackSpeakersState, row: Int) -> (String, [String]) {

        let currentMeetingGroup = trackSpeakersState.sortedMeetingGroups()[row]
        trackSpeakersState.currentMeetingGroup = currentMeetingGroup
        
        // Save currentEntity and currentMeetingGroup to CoreData
        RestorationState.saveTrackSpeakerState(entityIndex: trackSpeakersState.currentEntity!.idx!, meetingGroupIndex: currentMeetingGroup.idx!)
        
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
        
        return (currentMeetingGroup.name!, meetingEventNames)
    }
    
    class func setCurrentMeetingEvent(eventState: EventState, trackSpeakersState: TrackSpeakersState, row: Int)  {
        let event = EventState.sortedMeetingEvents(meetingGroupIndex: trackSpeakersState.currentMeetingGroup!.idx!)![row]
        
        let speakerEvents = Set<SpeechEvent>()
        
        let debateSection = EventState.createDebateSection()
        debateSection.sectionNumber = 0
        debateSection.sectionName = "section name??"
        debateSection.speeches = speakerEvents as NSSet
        
        let debate = EventState.createDebate()
        debate.debateNumber = 0
        debate.note = nil
        debate.debateSections = Set<DebateSection>() as NSSet
        
        event.debates = Set<Debate>() as NSSet
        event.debates = event.debates?.adding(debate) as NSSet?
        
        EventState.saveManagedObjectContext()
        
        trackSpeakersState.currentMeetingEvent = event
        trackSpeakersState.currentDebate = debate
    }
    
    class func fetchEntityNames(entityState: EntityState, trackSpeakersState: TrackSpeakersState, presenter: MeetingSetupPresenter) -> [String] {
        let currentEntity = trackSpeakersState.currentEntity
        let currentMeetingGroup = trackSpeakersState.currentMeetingGroup
        presenter.presentSetup(currentEntity: currentEntity, currentMeetingGroup:  currentMeetingGroup)
        
        var entityNames = [String]()
        EntityState.sortedEntities?.forEach({entity in
            entityNames.append(entity.name!)
        })
        return entityNames
    }
    
}
