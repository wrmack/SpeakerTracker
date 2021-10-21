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
    
    class func fetchMeetingGroupForRow(trackSpeakersState: TrackSpeakersState, row: Int) -> String {
//        let entity = entityState.sortedEntities![selectedEntityIndex]
//        trackSpeakersState.currentEntity = entity
        let currentMeetingGroup = trackSpeakersState.sortedMeetingGroups()[row]
        trackSpeakersState.currentMeetingGroup = currentMeetingGroup
        
        // Save currentEntity and currentMeetingGroup to CoreData
        RestorationState.saveTrackSpeakerState(entityIndex: trackSpeakersState.currentEntity!.idx!, meetingGroupIndex: currentMeetingGroup.idx!)
        
        return currentMeetingGroup.name!
    }
    
//    func fetchMeetingEventForRow(eventState: EventState, trackSpeakersState: TrackSpeakersState, row: Int) -> Event {
//        var event = eventState.events[row]
//        let speakerEvents = [SpeakerEvent]()
//        let debateSection = DebateSection(sectionNumber: 0, sectionName: "section name??", speakerEvents: speakerEvents)
//        let debate = Debate(debateNumber: 0, note: nil, debateSections: [debateSection])
//        event.debates = [Debate]()
//        event.debates?.append(debate)
//        trackSpeakersState.currentEvent = event
//        trackSpeakersState.currentDebate = debate
//        return event
//    }
    
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
