//
//  RestorationState.swift
//  Speaker-tracker-multi
//
//  Created by Warwick McNaughton on 15/10/21.
//

import Foundation
import CoreData

/// Saves and fetches currentEntityIndex and currentMeetingGroupIndex to CoreData.
///
/// State is saved by MeetingSetupInteractor and fetched when TrackSpeakersView appears.
struct RestorationState {
    
    static func saveSpeakerTrackerState(entityIndex: UUID, meetingGroupIndex: UUID) {
       
        // Already have a record in CoreData?
        
        // Setup fetch request
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<Restoration>(entityName: "Restoration")

        let pred = NSPredicate(format: "name == %@", "currentEntityIndex" as CVarArg)
        fetchRequest.predicate = pred
        
        // Fetch
        var fetchedCurrentEntityRecords: [Restoration]?
        do {
            fetchedCurrentEntityRecords = try viewContext.fetch(fetchRequest)
        }
        catch {
            print(error)
        }
        
        // If no existing record, create one and save currentEntity index
        if fetchedCurrentEntityRecords == nil || fetchedCurrentEntityRecords!.count == 0 {
            let newEntityRecord = Restoration(context: viewContext)
            newEntityRecord.name = "currentEntityIndex"
            newEntityRecord.idx = entityIndex
            
            let newMeetingGroupRecord = Restoration(context: viewContext)
            newMeetingGroupRecord.name = "currentMeetingGroupIndex"
            newMeetingGroupRecord.idx = meetingGroupIndex
        }
        // If existing record, set idx to currentEntity index
        else {
            fetchedCurrentEntityRecords![0].idx = entityIndex
            let pred = NSPredicate(format: "name == %@", "currentMeetingGroupIndex" as CVarArg)
            fetchRequest.predicate = pred
            
            var fetchedCurrentMeetingGroupRecords: [Restoration]?
            do {
                fetchedCurrentMeetingGroupRecords = try viewContext.fetch(fetchRequest)
                fetchedCurrentMeetingGroupRecords![0].idx = meetingGroupIndex
            }
            catch {
                print(error)
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    static func getSpeakerTrackerState() -> (UUID?, UUID?) {
        // Setup fetch request
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<Restoration>(entityName: "Restoration")

        var pred = NSPredicate(format: "name == %@", "currentEntityIndex" as CVarArg)
        fetchRequest.predicate = pred
        
        // Fetch currentEntity from CoreData
        var fetchedCurrentEntityRecords: [Restoration]?
        do {
            fetchedCurrentEntityRecords = try viewContext.fetch(fetchRequest)
        }
        catch {
            print(error)
        }
        
        pred = NSPredicate(format: "name == %@", "currentMeetingGroupIndex" as CVarArg)
        fetchRequest.predicate = pred
        
        // Fetch currentMeetingGroup from CoreData
        var fetchedCurrentMeetingGroupRecords: [Restoration]?
        do {
            fetchedCurrentMeetingGroupRecords = try viewContext.fetch(fetchRequest)
        }
        catch {
            print(error)
        }
        
        if fetchedCurrentEntityRecords == nil || fetchedCurrentEntityRecords?.count == 0 { return (nil,nil)}
        let entityIdx = fetchedCurrentEntityRecords![0].idx
        
        if fetchedCurrentMeetingGroupRecords == nil || fetchedCurrentMeetingGroupRecords?.count == 0 { return (nil,nil)}
        let meetingGroupIdx = fetchedCurrentMeetingGroupRecords![0].idx
        
        return (entityIdx, meetingGroupIdx)
        
    }
}
