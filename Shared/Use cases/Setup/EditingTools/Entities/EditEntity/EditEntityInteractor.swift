//
//  EditEntityInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 6/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine
import CoreData


class EditEntityInteractor {
    
    class func displaySelectedEntity(entityState: EntityState, presenter: EditEntityPresenter) {
        guard let entity = entityState.currentEntity else {return}
        presenter.presentViewModel(selectedEntity:entity)
    }
    
    /**
     Saves entity being edited.  With an entity name change, create a new entity and replace edited entity.
     */
    
    class func saveChangedEntityToStore(entityState: EntityState, entityName: String) {
        
        let viewContext = PersistenceController.shared.container.viewContext
        let currentEntity = entityState.currentEntity
        currentEntity?.name = entityName
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        entityState.entitiesHaveChanged = true
    }
}
