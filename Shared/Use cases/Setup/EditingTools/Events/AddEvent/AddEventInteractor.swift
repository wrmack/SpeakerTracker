//
//  AddEventInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 15/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation


class AddEventInteractor {
    
//    func fetchEntityForRow(entityState: EntityState, row: Int) -> Entity {
//        return entityState.entities[row]
//    }
//    
//    func fetchMeetingGroupForRow(entityState: EntityState, selectedEntityIndex: Int, row: Int) -> MeetingGroup {
//        let entity = entityState.entities[selectedEntityIndex]
//        return entity.meetingGroups![row]
//    }
    
    
    static func saveEvent(eventState: EventState, entityState: EntityState, date: Date, time: Date) {

        let cal = Calendar.current
        let dateComponents = cal.dateComponents(Set([Calendar.Component.day,Calendar.Component.month, Calendar.Component.year]), from: date)
        let newDate = cal.date(from: dateComponents)
        let timeComponents = cal.dateComponents(Set([Calendar.Component.hour,Calendar.Component.minute]), from: time)
        let newDateWithTime = cal.date(byAdding: timeComponents, to: newDate!)
        
        let event = EventState.createMeetingEvent()
        event.idx = UUID()
        event.date = newDateWithTime
        event.meetingOfGroup = entityState.currentMeetingGroup
        event.note = nil
        event.debates = nil
        EntityState.saveManagedObjectContext()
        
    }
}
