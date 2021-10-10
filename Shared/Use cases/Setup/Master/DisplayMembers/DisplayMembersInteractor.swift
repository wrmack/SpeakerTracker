//
//  DisplayMembersInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 29/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine
import CoreData


/// `DisplayMembersInteractor` is responsible for interacting with the data model.
class DisplayMembersInteractor {
    
    // Track initialisation for debugging purposes
    init() {
        print("++++++ DisplayMembersInteractor initialized")
    }
    
    deinit {
        print("++++++ DisplayMembersInteractor de-initialized")
    }
    
    /// If `currentEntityIndex` is not set, sets it to first entity.
    ///
    func initialiseEntities(entityState: EntityState) {
        if entityState.currentEntityIndex == nil {
            let entities = entityState.sortedEntities!
            entityState.currentEntityIndex = entities[0].idx
        }
    }
    
    /// Fetches members for selected entity and passes these to the presenter.
    ///
    /// 
    func fetchMembers(presenter: DisplayMembersPresenter, entityState: EntityState) {

        guard let currentEntity = entityState.currentEntity else {return}
        print("------ fetchMembers currentEntity \(currentEntity)")
        let fetchedMembersForEntity = entityState.sortedMembers(entity: currentEntity)!
        var members = [Member]()
        if fetchedMembersForEntity.count > 0 {
            fetchedMembersForEntity.forEach({ member in
                members.append(member)
            })
        }
        
        presenter.presentMembers(members: members)
    }
    
    /// Returns all entities, sorted by name
    func getEntities(entityState: EntityState) -> [Entity]? {
        return entityState.sortedEntities
    }
    
    /// Sets and returns the `currentMemberIndex` of EntityState
    ///
    /// Called when user selects a member, to store the selected index as `currentMemberIndex`.
    /// If the passed-in idx is nil then sets `currentMemberIndex` to the first member.
    /// - Parameters:
    ///    - idx: the UUID for the selected member; if nil then selected member is set to the first member
    ///    - entityState: The EntityState environment object

    func setSelectedMemberIndex(idx: UUID?, entityState: EntityState) {
        
        // Get the entity then the members for that entity
        // Return nil if result is nil or there are none
        let entity = entityState.currentEntity
        guard let fetchedMembersForEntity = entityState.sortedMembers(entity: entity!) else {return }
        if fetchedMembersForEntity.count == 0 {return }
        
        var memberIdx = idx
        
        // If idx is nil then select the first member
        if memberIdx == nil {
            let firstMember = fetchedMembersForEntity[0]
            memberIdx = firstMember.idx
        }
        
        // Set currentMemberIndex property of EntityState
        for member in fetchedMembersForEntity {
            if member.idx == memberIdx  {
                entityState.currentMemberIndex = member.idx
            }
        }

    }
    
    
    /// Fetches members for published currentEntityIndex
    ///
    /// The published currentEntityIndex has to be used rather than currentEntityIndex.
    func fetchMembersOnEntityChange(entityIndex: UUID, presenter: DisplayMembersPresenter, entityState: EntityState) {

        guard let currentEntity = entityState.entityWithIndex(index: entityIndex) else {return}

        let fetchedMembersForEntity = entityState.sortedMembers(entity: currentEntity)!
        var members = [Member]()
        if fetchedMembersForEntity.count > 0 {
            fetchedMembersForEntity.forEach({ member in
                members.append(member)
            })
            let firstMember = members[0]
            entityState.currentMemberIndex = firstMember.idx
            
            presenter.presentMembers(members: members)
        }

    }
    
}
