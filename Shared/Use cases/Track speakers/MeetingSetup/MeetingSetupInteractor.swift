//
//  MeetingSetupInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 18/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation


class MeetingSetupInteractor {
    
    func fetchEntityForRow(entityState: EntityState, trackSpeakersState: TrackSpeakersState, row: Int) -> Entity {
        trackSpeakersState.currentEntity = entityState.entities[row]
        return entityState.entities[row]
    }
    
//    func fetchMeetingGroupForRow(entityState: EntityState,  trackSpeakersState: TrackSpeakersState, selectedEntityIndex: Int, row: Int) -> MeetingGroup {
//        let entity = entityState.entities[selectedEntityIndex]
//        trackSpeakersState.currentEntity = entity
//        trackSpeakersState.currentMeetingGroup = entity.meetingGroups![row]
//        return entity.meetingGroups![row]
//    }
    
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
    
    func fetchMeetingSetup(trackSpeakersState: TrackSpeakersState, presenter: MeetingSetupPresenter) {
        let currentEntity = trackSpeakersState.currentEntity
        let currentMeetingGroup = trackSpeakersState.currentMeetingGroup
        
        presenter.presentSetup(currentEntity: currentEntity, currentMeetingGroup:  currentMeetingGroup)
    }
    
}
