//
//  EditEventInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 30/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation


class EditEventInteractor {
    
    static func displaySelectedEvent(eventState: EventState, presenter: EditEventPresenter) {
        guard let event = EventState.meetingEventWithIndex(index: eventState.currentMeetingEventIndex!) else {return}
        presenter.presentViewModel(selectedEvent: event)
    }

    
    static func saveEvent(eventState: EventState, entityState: EntityState, date: Date, time: Date) {

        let cal = Calendar.current
        let dateComponents = cal.dateComponents(Set([Calendar.Component.day,Calendar.Component.month, Calendar.Component.year]), from: date)
        let newDate = cal.date(from: dateComponents)
        let timeComponents = cal.dateComponents(Set([Calendar.Component.hour,Calendar.Component.minute]), from: time)
        let newDateWithTime = cal.date(byAdding: timeComponents, to: newDate!)
        
        let event = EventState.createMeetingEvent()
        event.idx = UUID()
        event.date = newDateWithTime
        event.note = nil
        event.debates = nil
        let meetingsSet = entityState.currentMeetingGroup?.meetings
        entityState.currentMeetingGroup!.meetings = meetingsSet!.adding(event) as NSSet
        
        EventState.saveManagedObjectContext()
        
    }
}
