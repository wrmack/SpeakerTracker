//
//  EditEntityInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 6/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine


class EditEntityInteractor {
    
    func displaySelectedEntity(entityState: EntityState, presenter: EditEntityPresenter, indexOfEntityToFetch: Int) {
        let entity = entityState.sortedEntities[indexOfEntityToFetch]
        presenter.presentViewModel(selectedEntity: entity)
    }
    
    /**
     Saves entity being edited.  With an entity name change, create a new entity and replace edited entity.
     */
    
    func saveEntityToDisk(entityState: EntityState, entityName: String, indexOfEntityToSave: Int) {
//        let entityState = entityState
//        let currentEntity = entityState.sortedEntities[indexOfEntityToSave]
//        var editedEntity = Entity(name: entityName, members: currentEntity.members, meetingGroups: currentEntity.meetingGroups)
//        editedEntity.id = currentEntity.id
//
//        
//        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            print("EditEntityInteractor: saveEntity: error: Document directory not found")
//            return
//        }
//        let docFileURL = docDirectory.appendingPathComponent(currentEntity.id.uuidString + ".ent")
//        let entityDoc = EntityDocument(fileURL: docFileURL)
//        entityDoc.open(completionHandler: { success in
//            if !success {
//                print("EditEntityInteractor: saveEntity: error opening EntityDocument")
//            }
//            else {
//                entityDoc.entity = editedEntity
//                entityDoc.updateChangeCount(.done)
//                entityDoc.close(completionHandler: { success in
//                    print("EditEntityInteractor: saveEntity: success")
//                    var newEntities = [Entity]()
//                    entityState.entities.forEach({ entity in
//                        if entity.id == currentEntity.id {
//                            newEntities.append(editedEntity)
//                        }
//                        else {
//                            newEntities.append(entity)
//                        }
//                    })
//                    entityState.entities = newEntities
//                    entityState.entityModelChanged = true
//                })
//            }
//        })
    }
}
