//
//  DeleteEntityInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 6/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine
import CoreData


class DeleteEntityInteractor {
    
    init() {
        print("DeleteEntityInteractor initialised")
    }
    
    deinit {
        print("DeleteEntityInteractor de-initialised")
    }
    
    class func displaySelectedEntity(entityState: EntityState, presenter: DeleteEntityPresenter) {
        guard let entity = entityState.currentEntity else {return}
        presenter.presentViewModel(selectedEntity:entity)
    }
    
    class func deleteEntity(entityState: EntityState) {
        
        let desc = NSSortDescriptor(key: "name", ascending: true)

        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<Entity>(entityName: "Entity")
       
        fetchRequest.sortDescriptors = [desc]
        
        if entityState.currentEntityIndex != nil {
            let pred = NSPredicate(format: "idx == %@", entityState.currentEntityIndex! as CVarArg)
            fetchRequest.predicate = pred
        }
        
        var fetchedEntities: [NSFetchRequestResult]?
        do {
            fetchedEntities = try viewContext.fetch(fetchRequest)
        }
        catch {
            print(error)
        }
        
        let selectedEntity = fetchedEntities![0]
        
        entityState.currentEntityIndex = nil
        
        viewContext.delete(selectedEntity as! NSManagedObject)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        entityState.currentEntityIndex = nil
        entityState.entitiesHaveChanged = true
    }
}
