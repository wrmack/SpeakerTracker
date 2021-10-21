//
//  DisplayEventsInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 15/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation


class DisplayEventsInteractor {

    init() {
        print("DisplayEventsInteractor initialized")
    }
    
    deinit {
        print("DisplayEventsInteractor de-initialized")
    }
    
    /// If `currentEntityIndex` is not set, sets it to first entity and sets
    /// `currentMeetingGroupIndex` to this entity's first meeting group.
    ///
    class func setCurrentEntityAndMeetingGroupIndices(entityState: EntityState) {
        if entityState.currentEntityIndex == nil {
            let entities = EntityState.sortedEntities
            if entities != nil && entities!.count > 0 {
                entityState.currentEntityIndex = entities![0].idx
            }
        }
        let meetingGroups = EntityState.sortedMeetingGroups(entityIndex: entityState.currentEntityIndex!)
        if meetingGroups != nil && meetingGroups!.count > 0 {
            entityState.currentMeetingGroupIndex = meetingGroups![0].idx
        }
    }
    
    
    /// Returns all entities, sorted by name
    class func getEntities() -> [Entity]? {
        return EntityState.sortedEntities
    }
    
    /// Sets and returns the `currentEventIndex` of EntityState
    ///
    /// Called when user selects a member, to store the selected index as `currentEventIndex`.
    /// If the passed-in idx is nil then sets `currentEventIndex` to the first member.
    /// - Parameters:
    ///    - idx: the UUID for the selected meeting group; if nil then selected meeting groups is set to the first meeting group
    ///    - entityState: The EntityState environment object

    class func setCurrentEventIndex(idx: UUID?, entityState: EntityState, eventState: EventState) {
        
        // Get the meeting group then the events for that meeting group
        guard let meetingGroupIndex = entityState.currentMeetingGroupIndex else {return}
        guard let fetchedEventsForMeetingGroup = EventState.sortedMeetingEvents(meetingGroupIndex: meetingGroupIndex) else {return }
        if fetchedEventsForMeetingGroup.count == 0 {return }
        
        var eventIdx = idx
        
        // If idx is nil then select the first member
        if eventIdx == nil {
            let firstEvent = fetchedEventsForMeetingGroup[0]
            eventIdx = firstEvent.idx
        }
        
        // Set currentEventIndex property of EventState
        eventState.currentMeetingEventIndex = eventIdx
    }
    
    static func fetchEvents(presenter: DisplayEventsPresenter, eventState: EventState, entityState: EntityState) {
        
        guard let currentMeetingGroupIndex = entityState.currentMeetingGroupIndex else {return}
        
        let fetchedMeetingEventsForMeetingGroup = EventState.sortedMeetingEvents(meetingGroupIndex: currentMeetingGroupIndex)!
        var meetingEvents = [MeetingEvent]()
        if fetchedMeetingEventsForMeetingGroup.count > 0 {
            fetchedMeetingEventsForMeetingGroup.forEach({ event in
                meetingEvents.append(event)
            })
        }
        presenter.presentEventSummaries(events: meetingEvents)
    }
    
    static func fetchEventsOnMeetingGroupChange(meetingGroupIndex: UUID, presenter: DisplayEventsPresenter, eventState: EventState) {
        
        let fetchedEventsForMeetingGroup = EventState.sortedMeetingEvents(meetingGroupIndex: meetingGroupIndex)!
        var events = [MeetingEvent]()
        if fetchedEventsForMeetingGroup.count > 0 {
            fetchedEventsForMeetingGroup.forEach({ event in
                events.append(event)
            })
            let firstEvent = events[0]
            eventState.currentMeetingEventIndex = firstEvent.idx
        }
        else {
            eventState.currentMeetingEventIndex = nil
        }
        
        presenter.presentEventSummaries(events: events)
        
        
        
    }
    
    func fetchMeetingGroupsForEntity(entity: Entity) {
        //       self.entity = entity
        //       fetchMeetingGroups()
    }
    
}
