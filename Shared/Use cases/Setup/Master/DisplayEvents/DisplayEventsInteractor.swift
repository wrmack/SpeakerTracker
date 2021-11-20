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
            else {return}
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
    /// Called when user selects a meeting event, to store the selected index as `currentEventIndex`.
    /// If the passed-in idx is nil then sets `currentEventIndex` to the first meeting event.
    /// - Parameters:
    ///    - idx: the UUID for the selected meeting event; if nil then selected meeting event is set to the first meeting event
    ///    - entityState: The EntityState environment object

    class func setCurrentEventIndex(idx: UUID?, entityState: EntityState, eventState: EventState) {
    
        var eventIdx = idx
        
        // If idx is nil then select the first member
        // Get the meeting group then the events for that meeting group

        if eventIdx == nil {
            guard let meetingGroupIndex = entityState.currentMeetingGroupIndex else {return}
            guard let fetchedEventsForMeetingGroup = EventState.sortedMeetingEvents(meetingGroupIndex: meetingGroupIndex) else {return }
            if fetchedEventsForMeetingGroup.count == 0 {
                eventState.currentMeetingEventIndex = nil
                return
            }
            
            let firstEvent = fetchedEventsForMeetingGroup[0]
            eventIdx = firstEvent.idx
        }
        
        // Set currentEventIndex property of EventState
        eventState.currentMeetingEventIndex = eventIdx
    }
    
    static func fetchEvents(presenter: DisplayEventsPresenter, eventState: EventState, entityState: EntityState) {
        
        var meetingEvents = [MeetingEvent]()
        
        let currentMeetingGroupIndex = entityState.currentMeetingGroupIndex
        if currentMeetingGroupIndex != nil {
            let fetchedMeetingEventsForMeetingGroup = EventState.sortedMeetingEvents(meetingGroupIndex: currentMeetingGroupIndex!)!
            
            if fetchedMeetingEventsForMeetingGroup.count > 0 {
                fetchedMeetingEventsForMeetingGroup.forEach({ event in
                    meetingEvents.append(event)
                })
            }
        }
        presenter.presentEventSummaries(events: meetingEvents)
    }
    
    static func fetchEventsOnMeetingGroupChange(meetingGroupIndex: UUID?, presenter: DisplayEventsPresenter, eventState: EventState) {
        
        var events = [MeetingEvent]()
        
        if meetingGroupIndex != nil {
            let fetchedEventsForMeetingGroup = EventState.sortedMeetingEvents(meetingGroupIndex: meetingGroupIndex!)!

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
        }
        
        presenter.presentEventSummaries(events: events)
    }
    
    static func resetMeetingGroupIndex(entityState: EntityState) {
        entityState.currentMeetingGroupIndex = nil
    }
    
    func fetchMeetingGroupsForEntity(entity: Entity) {
        //       self.entity = entity
        //       fetchMeetingGroups()
    }
    
}
