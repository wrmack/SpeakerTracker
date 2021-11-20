//
//  DisplaySelectedEventInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 16/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation


class DisplaySelectedEventInteractor {
    
    static func fetchEvent(presenter: DisplaySelectedEventPresenter, eventState: EventState, entityState: EntityState, setupSheetState:SetupSheetState, newIndex: UUID?) {
        
        print("------ DisplaySelectedEventInteractor.fetchEvent newIndex \(String(describing: newIndex))")
        
        var eventIndex: UUID?

        // newIndex is nil when method called by .onAppear
        if newIndex == nil {
            // Get entity name from currentEntity
            var entityName = ""
            if let entity = entityState.currentEntity {
                entityName = entity.name!
            }
            // Get meeting group name from currentMeetingGroup
            var groupName = ""
            if let group = entityState.currentMeetingGroup {
                groupName = group.name!
                setupSheetState.addDisabled = false
            }
            // Get event from currentMeetingEventIndex
            var event: MeetingEvent?
            if let eventIdx = eventState.currentMeetingEventIndex {
                event = EventState.meetingEventWithIndex(index: eventIdx)
            } else {
                if entityState.currentEntityIndex == nil { setupSheetState.addDisabled = true }
                if entityState.currentMeetingGroupIndex == nil { setupSheetState.addDisabled = true } else { setupSheetState.addDisabled = false}
                setupSheetState.editDisabled = true
                setupSheetState.deleteDisabled = true
                event = nil
            }
            presenter.presentMeetingEventDetail(event: event, entityName: entityName, meetingGroupName: groupName)
            return
        }
        else {
            eventIndex = newIndex
        }
        let selectedMeetingEvent = EventState.meetingEventWithIndex(index: eventIndex!)
        setupSheetState.deleteDisabled = false
        setupSheetState.editDisabled = false
        presenter.presentMeetingEventDetail(event: selectedMeetingEvent, entityName: entityState.currentEntity!.name!, meetingGroupName: entityState.currentMeetingGroup!.name!)
        
    }
}
