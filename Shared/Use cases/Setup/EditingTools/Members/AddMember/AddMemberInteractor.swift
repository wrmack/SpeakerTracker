//
//  AddMemberInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 29/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine

class AddMemberInteractor: ObservableObject {
    
    
    // MARK: Model management
    
    /*
     Saves member to model and persistent storage.
     Called when user decides to save new member.
     tempMemberList is an array that is updated when user presses the "Add another" button, but is not saved until this is called.
     Also updates currenty entity in user defaults.
     */
    func saveMemberToEntity(entityState: EntityState, setupState: SetupState, title: String, first: String, last: String) {
        let entityState = entityState
        let setupState = setupState
        var currentEntity = entityState.currentEntity!
        let memberTitle = title
        let memberFirstName = first
        let memberLastName = last
        
        if currentEntity.members == nil {
            currentEntity.members = [Member]()
        }
        
        //      if tempMemberList != nil && tempMemberList!.count > 0 {
        //         self.entity?.members!.append(contentsOf: tempMemberList!)
        //         tempMemberList = nil
        //      }
        
        let newMember = Member(title: memberTitle, firstName: memberFirstName, lastName: memberLastName)
        if newMember.title != "" || newMember.firstName != "" || newMember.lastName != "" {
            currentEntity.members!.append(newMember)
        }
        let savedEntity = UserDefaultsManager.getCurrentEntity()
        if savedEntity == currentEntity {
            UserDefaultsManager.saveCurrentEntity(entity: currentEntity)
        }
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("AddMemberInteractor: saveMemberToEntity: error: Document directory not found")
            return
        }
        let docFileURL = docDirectory.appendingPathComponent(currentEntity.id.uuidString + ".ent")
        let entityDoc = EntityDocument(fileURL: docFileURL)
        entityDoc.open(completionHandler: { success in
            if !success {
                print("AddMemberInteractor: saveMemberToEntity: error opening EntityDocument")
            }
            else {
                entityDoc.entity = currentEntity
                entityDoc.updateChangeCount(.done)
                entityDoc.close(completionHandler: { success in
                    if !success {
                        print("AddMemberInteractor: saveMemberToEntity: Error saving")
                    }
                    else{
                        print("entityDoc: \(entityDoc)")
                        var newEntities = [Entity]()
                        entityState.entities.forEach({ entity in
                            if entity.id == currentEntity.id {
                                newEntities.append(currentEntity)
                            }
                            else {
                                newEntities.append(entity)
                            }
                        })
                        entityState.entities = newEntities
                        entityState.currentEntity = currentEntity
                        setupState.numberOfRows += 1
                    }
                    
                })
            }
        })
    }
    
}
