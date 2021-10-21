//
//  AddEntityInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 6/09/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine
import CoreData


class AddEntityInteractor {


    class func saveNewEntityToStore(entityName: String, entityState: EntityState) {
        
        let viewContext = PersistenceController.shared.container.viewContext
        let newEntity = Entity(context: viewContext)
        newEntity.name = entityName
        newEntity.idx = UUID()
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        entityState.currentEntityIndex = newEntity.idx 
        entityState.entitiesHaveChanged = true
    }
}
