//
//  EventState.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 17/07/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine
import CoreData



class EventState : ObservableObject {
    
    // MARK: - Initialisation

    init() {
        print("++++++ EventState intialized")
    }
    
    deinit {
        print("++++++ EventState de-initialized")
    }
    
    // MARK: - Published properties
//    @Published var currentMeetingGroupIndex: UUID?  // Only hold in one place - EntityState
    @Published var currentMeetingEventIndex: UUID?
    
    
    // MARK: - Methods
    
    
    class func createSpeechEvent() -> SpeechEvent {
        
        let viewContext = PersistenceController.shared.container.viewContext
        let newSpeech = SpeechEvent(context: viewContext)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return newSpeech
    }
    
    static func meetingEventWithIndex(index: UUID) -> MeetingEvent? {
        
        // Setup fetch request
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<MeetingEvent>(entityName: "MeetingEvent")
        
        // Predicate
        let pred = NSPredicate(format: "idx == %@", index as CVarArg)
        fetchRequest.predicate = pred
        
        // Fetch
        var fetchedEvents: [NSFetchRequestResult]?
        do {
            fetchedEvents = try viewContext.fetch(fetchRequest)
        }
        catch {
            print(error)
        }
        
        let event = fetchedEvents![0] as! MeetingEvent
        
        return event
        
    }
    
    class func sortedMeetingEvents(meetingGroupIndex: UUID) -> [MeetingEvent]? {
        
        // Setup fetch request
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<MeetingEvent>(entityName: "MeetingEvent")
        
        // Predicate
        let pred = NSPredicate(format: "%K == %@", "meetingOfGroup.idx", meetingGroupIndex as CVarArg)
        fetchRequest.predicate = pred
        
        // Sort descriptor
        let desc = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [desc]
        
        // Fetch
        var fetchedEvents: [NSFetchRequestResult]?
        do {
            fetchedEvents = try viewContext.fetch(fetchRequest)
        }
        catch {
            print(error)
        }
        
        if fetchedEvents == nil { return nil }
        var events = [MeetingEvent]()
        fetchedEvents!.forEach({ event in
            events.append(event as! MeetingEvent)
        })
        
        return events
        
    }
    
    class func createMeetingEvent() -> MeetingEvent {
        
        let viewContext = PersistenceController.shared.container.viewContext
        let newEvent = MeetingEvent(context: viewContext)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return newEvent
    }
    
    class func createDebateSection() -> DebateSection {
        let viewContext = PersistenceController.shared.container.viewContext
        let newDebateSection = DebateSection(context: viewContext)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return newDebateSection
    }
    
    class func createDebate() -> Debate {
        let viewContext = PersistenceController.shared.container.viewContext
        let newDebate = Debate(context: viewContext)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return newDebate
    }
    
    
    static func saveManagedObjectContext() {
        let viewContext = PersistenceController.shared.container.viewContext
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
}
