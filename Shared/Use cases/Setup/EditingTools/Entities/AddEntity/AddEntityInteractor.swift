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
   
   
   func setupInteractor(entityState: EntityState) {
      self.entityState = entityState
   }
   
   
   func saveEntityToDisk(entityName: String) {
      self.entityName = entityName
      let newEntity = Entity(name: entityName, members: nil, meetingGroups: nil)
      guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
          print("Error: Document directory not found")
          return
      }
      print(documentsDirectory)
      let docFileURL =  documentsDirectory.appendingPathComponent(newEntity.id.uuidString + ".ent")
      let entityDoc = EntityDocument(fileURL: docFileURL, name: newEntity.name, entity: newEntity)
      entityDoc.save(to: docFileURL, for: .forCreating, completionHandler: { success in
          if !success {
              print("AddEntityInteractor: saveEntityToDisk: Error saving")
          }
          else{
            self.entityState!.entities.append(newEntity)
            self.entityState!.currentEntity = newEntity
            self.entityState!.entityModelChanged = true
          }
      })
   }
}
