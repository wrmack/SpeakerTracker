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

    
    static func saveEvent(eventState: EventState, entityState: EntityState, date: Date, note: String) {

        let cal = Calendar.current
        let dateComponents = cal.dateComponents(Set([Calendar.Component.day,Calendar.Component.month, Calendar.Component.year]), from: date)
        let newDate = cal.date(from: dateComponents)
        let timeComponents = cal.dateComponents(Set([Calendar.Component.hour,Calendar.Component.minute]), from: date)
        let newDateWithTime = cal.date(byAdding: timeComponents, to: newDate!)
        
        let event = EventState.meetingEventWithIndex(index: eventState.currentMeetingEventIndex!)
        event!.date = newDateWithTime
        event!.note = note
        
        EventState.saveManagedObjectContext()
        eventState.eventsHaveChanged = true
        
    }
}
