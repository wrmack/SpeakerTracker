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
    class func setCurrentEntityIndex(entityState: EntityState) {
        if entityState.currentEntityIndex == nil {
            let entities = EntityState.sortedEntities!
            if entities.count > 0  {
                entityState.currentEntityIndex = entities[0].idx
            }
        }
    }
    
    /// Returns all entities, sorted by name
    class func getEntities() -> [Entity]? {
        return EntityState.sortedEntities
    }
    
    /// Fetches members for selected entity and passes these to the presenter.
    ///
    /// 
    class func fetchMembers(presenter: DisplayMembersPresenter, entityState: EntityState) {

        guard let currentEntityIndex = entityState.currentEntityIndex else {return}
        print("------ fetchMembers currentEntity \(currentEntityIndex)")
        let fetchedMembersForEntity = EntityState.sortedMembers(entityIndex: currentEntityIndex)!
        var members = [Member]()
        if fetchedMembersForEntity.count > 0 {
            fetchedMembersForEntity.forEach({ member in
                members.append(member)
            })
        }
        
        presenter.presentMembers(members: members)
    }
    
    
    /// Sets and returns the `currentMemberIndex` of EntityState
    ///
    /// Called when user selects a member, to store the selected index as `currentMemberIndex`.
    /// If the passed-in idx is nil then sets `currentMemberIndex` to the first member.
    /// - Parameters:
    ///    - idx: the UUID for the selected member; if nil then selected member is set to the first member
    ///    - entityState: The EntityState environment object

    class func setCurrentMemberIndex(idx: UUID?, entityState: EntityState) {
        
        // Get the entity then the members for that entity
        // Return nil if result is nil or there are none
        guard let entityIndex = entityState.currentEntityIndex else {return }
        guard let fetchedMembersForEntity = EntityState.sortedMembers(entityIndex: entityIndex) else {return }
        if fetchedMembersForEntity.count == 0 {return }
        
        var memberIdx = idx
        
        // If idx is nil then select the first member
        if memberIdx == nil {
            let firstMember = fetchedMembersForEntity[0]
            memberIdx = firstMember.idx
        }
        
        // Set currentMemberIndex property of EntityState
        entityState.currentMemberIndex = memberIdx

    }
    
    
    /// Fetches members for published currentEntityIndex
    ///
    /// The published currentEntityIndex has to be used rather than currentEntityIndex.
    class func fetchMembersOnEntityChange(entityIndex: UUID, presenter: DisplayMembersPresenter, entityState: EntityState) {

        let fetchedMembersForEntity = EntityState.sortedMembers(entityIndex: entityIndex)!
        var members = [Member]()
        if fetchedMembersForEntity.count > 0 {
            fetchedMembersForEntity.forEach({ member in
                members.append(member)
            })
            let firstMember = members[0]
            entityState.currentMemberIndex = firstMember.idx
        }
        else {
            entityState.currentMemberIndex = nil
        }
        presenter.presentMembers(members: members)

    }
    
}
