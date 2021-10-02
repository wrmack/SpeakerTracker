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

class EntityState : ObservableObject {
    
    // MARK: - Initialisation
    
    init() {
        print("++++++ EntityState intialized")
    }
    
    deinit {
        print("++++++ EntityState de-initialized")
    }
    
    // MARK: - Published properties
    
    @Published var currentEntity: Entity?
    @Published var currentMeetingGroup: MeetingGroup?
    @Published var meetingGroupMembers: Set<Member>?
    @Published var entityModelChanged = false
    
    // MARK: - Stored properties
    
    var entities = [Entity]() {
        didSet {
            print("++++++ EntityState entities: [Entity]() didSet for \(entities.count) entities")
        }
    }
    
    // MARK: - Computed properties
    
    var sortedEntities: [Entity] {
        get {
            let sortedEntities = entities.sorted(by: {
                if $0.name! < $1.name! {
                    return true
                }
                return false
            })
            return sortedEntities
        }
    }
    
    var sortedMembers: [Member] {
        get {
            var sortedMbrs = [Member]()
            if currentEntity!.members != nil {
                let members = currentEntity!.members!.allObjects as! [Member]
                sortedMbrs = members.sorted(by: {
                  if $0.lastName! < $1.lastName! {
                     return true
                  }
                  return false
               })
            }
            return sortedMbrs
        }
    }
    
    var sortedMeetingGroups: [MeetingGroup] {
        get {
            var meetingGroups = [MeetingGroup]()
            if currentEntity!.meetingGroups != nil {
                meetingGroups = currentEntity!.meetingGroups!.allObjects as! [MeetingGroup]
                meetingGroups.sort(by: {
                    if $0.name! < $1.name! {
                       return true
                    }
                    return false
                })
            }
            return meetingGroups
        }
    }
    
}

