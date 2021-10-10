//
//  DisplayEntitiesInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 18/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine
import CoreData




/// `DisplayEntitiesInteractor` is responsible for interacting with the data model.
class DisplayEntitiesInteractor {
    
    // Track initialisation for debugging purposes
    init() {
        print("++++++ DisplayEntitiesInteractor initialized")
    }
    
    deinit {
        print("++++++ DisplayEntitiesInteractor de-initialized")
    }
    
    /// Fetches entities and passes these to the presenter.
    ///
    ///
    func fetchEntities(presenter: DisplayEntitiesPresenter, entityState: EntityState) {
        // For debugging
//        entityState.purgeFloatingMembers()
        
        let fetchedEntities = entityState.sortedEntities
        if fetchedEntities == nil { return }
        var entities = [Entity]()
        fetchedEntities!.forEach({ entity in
            entities.append(entity)
        })
        
        presenter.presentEntityNames(entities: entities)
        
    }
    
    /// Sets the `currentEntityIndex` of EntityState
    ///
    /// Called when user selects an entity, to store the selected index as `currentEntityIndex`.
    /// If the passed-in idx is nil then sets `currentEntityIndex` to the first entity.
    /// - Parameters:
    ///    - idx: A UUID
    ///    - entityState: The EntityState environment object
    /// - Returns: The index of the current entity
    func setSelectedEntityIndex(idx: UUID?, entityState: EntityState) {
        
        // Get all sorted entities and return nil if result is nil or there are none
        guard let fetchedEntities = entityState.sortedEntities else {return}
        if fetchedEntities.count == 0 {return }
        
        var entityIdx = idx
        
        // If idx is nil then select the first entity
        if entityIdx == nil {
            let firstEntity = fetchedEntities[0]
            entityIdx = firstEntity.idx
        }
        
        // Set currentEntityIndex property of EntityState
        for entity in fetchedEntities {
            if entity.idx == entityIdx  {
                entityState.currentEntityIndex = entity.idx
            }
        }
        
    }

}
