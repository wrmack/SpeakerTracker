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


/// Holds state associated with the Event model.
///
/// 
class EventState : ObservableObject {

    // Hold indexes only.  The objects are in CoreData.
    // Use the indices for retrieving the objects from CoreData.
    @Published var currentMeetingEventIndex: UUID?
    
    // Additions, deletions, edits
    @Published var eventsHaveChanged = false
    
    var currentDebateIndex: UUID?
    var currentDebateSectionIndex: UUID?
    

    init() {
        print("++++++ EventState intialized")
    }
    
    deinit {
        print("++++++ EventState de-initialized")
    }

    // MARK: - Meeting events
    
    class func createMeetingEvent() -> MeetingEvent {
        
        let viewContext = PersistenceController.shared.container.viewContext
        let newEvent = MeetingEvent(context: viewContext)
        EventState.saveManagedObjectContext()
        
        return newEvent
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
        
        if fetchedEvents!.count > 0 {
            let event = fetchedEvents![0] as! MeetingEvent
            return event
        }
        else {
            return nil
        }
        
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
    
    // MARK: - Debates
    
    class func createDebate() -> Debate {
        let viewContext = PersistenceController.shared.container.viewContext
        let newDebate = Debate(context: viewContext)
        EventState.saveManagedObjectContext()

        return newDebate
    }
    
    static func debateWithIndex(index: UUID) -> Debate {
        
        // Setup fetch request
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<Debate>(entityName: "Debate")
        
        // Predicate
        let pred = NSPredicate(format: "%K == %@", "idx", index as CVarArg)
        fetchRequest.predicate = pred
        
        // Fetch
        var fetchedDebates: [Debate]?
        do {
            fetchedDebates = try viewContext.fetch(fetchRequest)
        }
        catch {
            print(error)
        }
        
        let debate = fetchedDebates![0]
        
        return debate
        
    }
    
    
    static func deleteDebateFromCurrentMeeting(meetingIndex: UUID, debateIndex: UUID) {
        
        let currentMeeting = EventState.meetingEventWithIndex(index: meetingIndex)!
        
        // Debugging
        print("Debate index to remove: \(debateIndex)")
        currentMeeting.debates!.forEach({ element in
            let debate = element as! Debate
            print("Debate index in current meeting: \(debate.idx!)")
        })
        
        let pred = NSPredicate(format: "%K != %@", "idx", debateIndex as CVarArg)
        let debates = currentMeeting.debates!.filtered(using: pred)
        currentMeeting.debates = debates as NSSet
        
        let viewContext = PersistenceController.shared.container.viewContext
        viewContext.delete(EventState.debateWithIndex(index: debateIndex))
        EventState.saveManagedObjectContext()
    }
    
    // MARK: - Debate sections

    class func createDebateSection() -> DebateSection {
        let viewContext = PersistenceController.shared.container.viewContext
        let newDebateSection = DebateSection(context: viewContext)
        EventState.saveManagedObjectContext()
        
        return newDebateSection
    }
    
    static func debateSectionWithIndex(index: UUID) -> DebateSection {
        
        // Setup fetch request
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<DebateSection>(entityName: "DebateSection")
        
        // Predicate
        let pred = NSPredicate(format: "%K == %@", "idx", index as CVarArg)
        fetchRequest.predicate = pred
        
        // Fetch
        var fetchedDebateSections: [DebateSection]?
        do {
            fetchedDebateSections = try viewContext.fetch(fetchRequest)
        }
        catch {
            print(error)
        }
        
        let debateSection = fetchedDebateSections![0]
        
        return debateSection
        
    }
    
    
    // MARK: - Speech events
    
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
    
    
    // MARK: - Managed Object Context
    
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
    
    // MARK: - Debugging
    
    static func getMeetingEventIndices() -> [UUID] {
        // Setup fetch request
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<MeetingEvent>(entityName: "MeetingEvent")
        
        // Fetch
        var fetchedEvents: [MeetingEvent]?
        do {
            fetchedEvents = try viewContext.fetch(fetchRequest)
        }
        catch {
            print(error)
        }

        var indices = [UUID]()
        fetchedEvents!.forEach({ event in
            indices.append(event.idx!)
        })
        
        return indices
    }
}
