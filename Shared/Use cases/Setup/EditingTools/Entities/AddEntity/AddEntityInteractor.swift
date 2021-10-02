//
//  AddEntityInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 6/09/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine


class AddEntityInteractor {
   var entityName = ""
   var entityState: EntityState?
   
    var viewContext = PersistenceController.shared.container.viewContext
   
   func setupInteractor(entityState: EntityState) {
      self.entityState = entityState
   }
   
   
//   func saveEntityToDisk(entityName: String) {
//      self.entityName = entityName
//      let newEntity = Entity(name: entityName, members: nil, meetingGroups: nil)
//      guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//          print("Error: Document directory not found")
//          return
//      }
//      print(documentsDirectory)
//      let docFileURL =  documentsDirectory.appendingPathComponent(newEntity.id.uuidString + ".ent")
//      let entityDoc = EntityDocument(fileURL: docFileURL, name: newEntity.name, entity: newEntity)
//      entityDoc.save(to: docFileURL, for: .forCreating, completionHandler: { success in
//          if !success {
//              print("AddEntityInteractor: saveEntityToDisk: Error saving")
//          }
//          else{
//            self.entityState!.entities.append(newEntity)
//            self.entityState!.currentEntity = newEntity
//            self.entityState!.entityModelChanged = true
//          }
//      })
//   }
    
    func saveEntityToStore(entityName: String) {
        let newEntity = Entity(context: viewContext)
        newEntity.name = entityName

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        self.entityState!.currentEntity = newEntity
        self.entityState?.entityModelChanged = true
    }
}
