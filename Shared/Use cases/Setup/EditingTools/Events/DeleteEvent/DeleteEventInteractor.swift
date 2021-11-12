//
//  DeleteEventInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 30/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation
import CoreData


class DeleteEventInteractor {
    
    static func displaySelectedEvent(eventState: EventState, presenter: DeleteEventPresenter) {
        guard let event = EventState.meetingEventWithIndex(index: eventState.currentMeetingEventIndex!) else {return}
        presenter.presentViewModel(selectedEvent: event)
    }
    
    static func deleteSelectedEvent(eventState: EventState) {
        guard let event = EventState.meetingEventWithIndex(index: eventState.currentMeetingEventIndex!) else {return}
        
        let viewContext = PersistenceController.shared.container.viewContext
        viewContext.delete(event as NSManagedObject)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        eventState.eventsHaveChanged = true
        eventState.currentMeetingEventIndex = nil
    }
}
