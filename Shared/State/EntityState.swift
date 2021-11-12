//
//  EntityState.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 17/07/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

/*
 An Environment Object
 
 
 
 */

import Foundation
import Combine
import CoreData

/// Holds state of organisational entities, members and meeting groups
///
/// Organisational entities, members and meeting groups are CoreData managed objects
/// setup in Main.xcdatmodeld.  Each has a unique UUID index (idx) property which is used
/// for identifying the current entity, member or meeting group.
///
class EntityState : ObservableObject {
    
    // MARK: - Initialisation
    
    init() {
        print("++++++ EntityState intialized")
    }
    
    deinit {
        print("++++++ EntityState de-initialized")
    }
    
    // MARK: - Published properties
    
    @Published var currentEntityIndex: UUID?
    @Published var currentMemberIndex: UUID?
    @Published var currentMeetingGroupIndex: UUID?
    
    // Additions, deletions, edits
    @Published var entitiesHaveChanged = false
    @Published var membersHaveChanged = false
    @Published var meetingGroupsHaveChanged = false
    
    
    // MARK: - Computed properties
    
    var currentEntity: Entity? {
        get {
            // Setup fetch request
            let viewContext = PersistenceController.shared.container.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
            
            // Predicate
            guard let idx = currentEntityIndex else {return nil}
            let pred = NSPredicate(format: "idx == %@", idx as CVarArg)
            fetchRequest.predicate = pred
            
            // Fetch
            var fetchedEntities: [NSFetchRequestResult]?
            do {
                fetchedEntities = try viewContext.fetch(fetchRequest)
            }
            catch {
                print(error)
            }
            
            let currentEntity = fetchedEntities![0] as! Entity
            
            return currentEntity
        }
    }
    
    var currentMember: Member? {
        get {
            // Setup fetch request
            let viewContext = PersistenceController.shared.container.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Member")
            
            // Predicate
            guard let idx = currentMemberIndex else {return nil}
            let pred = NSPredicate(format: "idx == %@", idx as CVarArg)
            fetchRequest.predicate = pred
            
            // Fetch
            var fetchedMembers: [NSFetchRequestResult]?
            do {
                fetchedMembers = try viewContext.fetch(fetchRequest)
            }
            catch {
                print(error)
            }
            
            let currentMember = fetchedMembers![0] as! Member
            
            return currentMember
        }
    }
    
    var currentMeetingGroup: MeetingGroup? {
        get {
            // Setup fetch request
            let viewContext = PersistenceController.shared.container.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MeetingGroup")
            
            // Predicate
            guard let idx = currentMeetingGroupIndex else {return nil}
            let pred = NSPredicate(format: "idx == %@", idx as CVarArg)
            fetchRequest.predicate = pred
            
            // Fetch
            var fetchedMeetingGroups: [NSFetchRequestResult]?
            do {
                fetchedMeetingGroups = try viewContext.fetch(fetchRequest)
            }
            catch {
                print(error)
            }
            
            let currentMeetingGroup = fetchedMeetingGroups![0] as! MeetingGroup
            
            return currentMeetingGroup
        }
    }
    
    static var sortedEntities: [Entity]? {
        get {
            // Setup fetch request
            let viewContext = PersistenceController.shared.container.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
            
            // Sort descriptor
            let desc = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [desc]
            
            // Fetch
            var fetchedEntities: [NSFetchRequestResult]?
            do {
                fetchedEntities = try viewContext.fetch(fetchRequest)
            }
            catch {
                print(error)
            }
            
            if fetchedEntities == nil { return nil }
            var entities = [Entity]()
            fetchedEntities!.forEach({ entity in
                entities.append(entity as! Entity)
            })
            
            return entities
        }
        
    }
    
    // MARK: - Methods
    
    static func createEntity() -> Entity {
        let viewContext = PersistenceController.shared.container.viewContext
        let newEntity = Entity(context: viewContext)
        saveManagedObjectContext()

        return newEntity
    }
    
    static func createMember() -> Member {
        let viewContext = PersistenceController.shared.container.viewContext
        let newMember = Member(context: viewContext)
        saveManagedObjectContext()
        return newMember
    }
    
    static func createMeetingGroup() -> MeetingGroup {
        let viewContext = PersistenceController.shared.container.viewContext
        let newMeetingGroup = MeetingGroup(context: viewContext)
        saveManagedObjectContext()
        return newMeetingGroup
    }
    
    static func entityWithIndex(index: UUID) -> Entity? {
        
        // Setup fetch request
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        
        // Predicate
        let pred = NSPredicate(format: "idx == %@", index as CVarArg)
        fetchRequest.predicate = pred
        
        // Fetch
        var fetchedEntities: [NSFetchRequestResult]?
        do {
            fetchedEntities = try viewContext.fetch(fetchRequest)
        }
        catch {
            print(error)
        }
        
        let entity = fetchedEntities![0] as! Entity
        
        return entity
        
    }
    
    static func memberWithIndex(index: UUID) -> Member? {
        
        // Setup fetch request
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Member")
        
        // Predicate
        let pred = NSPredicate(format: "idx == %@", index as CVarArg)
        fetchRequest.predicate = pred
        
        // Fetch
        var fetchedMembers: [NSFetchRequestResult]?
        do {
            fetchedMembers = try viewContext.fetch(fetchRequest)
        }
        catch {
            print(error)
        }
        
        let member = fetchedMembers![0] as! Member
        
        return member
        
    }
    
    
    static func sortedMembers(entityIndex: UUID) -> [Member]? {
        
        // Setup fetch request
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<Member>(entityName: "Member")
        
        // Predicate
        let pred = NSPredicate(format: "%K == %@", "memberOfEntity.idx", entityIndex as CVarArg)
        fetchRequest.predicate = pred
        
        // Sort descriptor
        let desc = NSSortDescriptor(key: "lastName", ascending: true)
        fetchRequest.sortDescriptors = [desc]
        
        // Fetch
        var fetchedMembers: [NSFetchRequestResult]?
        do {
            fetchedMembers = try viewContext.fetch(fetchRequest)
        }
        catch {
            print(error)
        }
        
        if fetchedMembers == nil { return nil }
        var members = [Member]()
        fetchedMembers!.forEach({ member in
            members.append(member as! Member)
        })
        
        return members
    }
    
    
    static func meetingGroupWithIndex(index: UUID) -> MeetingGroup? {
        
        // Setup fetch request
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MeetingGroup")
        
        // Predicate
        let pred = NSPredicate(format: "idx == %@", index as CVarArg)
        fetchRequest.predicate = pred
        
        // Fetch
        var fetchedMeetingGroups: [NSFetchRequestResult]?
        do {
            fetchedMeetingGroups = try viewContext.fetch(fetchRequest)
        }
        catch {
            print(error)
        }
        
        let meetingGroup = fetchedMeetingGroups![0] as! MeetingGroup
        
        return meetingGroup
        
    }
    

    static func sortedMeetingGroups(entityIndex: UUID) -> [MeetingGroup]? {
        
        // Setup fetch request
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<MeetingGroup>(entityName: "MeetingGroup")
        
        // Predicate
        //        guard let idx = entity.idx else {return nil}
        let pred = NSPredicate(format: "%K == %@", "groupOfEntity.idx", entityIndex as CVarArg)
        fetchRequest.predicate = pred
        
        // Sort descriptor
        let desc = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [desc]
        
        // Fetch
        var fetchedMeetingGroups: [NSFetchRequestResult]?
        do {
            fetchedMeetingGroups = try viewContext.fetch(fetchRequest)
        }
        catch {
            print(error)
        }
        
        if fetchedMeetingGroups == nil { return nil }
        var meetingGroups = [MeetingGroup]()
        fetchedMeetingGroups!.forEach({ meetingGroup in
            meetingGroups.append(meetingGroup as! MeetingGroup)
        })
        
        return meetingGroups
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
    
    // MARK: - Debugging
    
    /// Deletes any members who are not members of an entity
    func purgeFloatingMembers() {
        
        // Setup fetch request
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<Member>(entityName: "Member")
        
        // Fetch
        var fetchedMembers: [Member]?
        do {
            fetchedMembers = try viewContext.fetch(fetchRequest)
        }
        catch {
            print(error)
        }
        
        fetchedMembers?.forEach({member in
            if member.memberOfEntity == nil {
                print("\(String(describing: member.lastName)) is nil")
                viewContext.delete(member)
            }
        })
        
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

