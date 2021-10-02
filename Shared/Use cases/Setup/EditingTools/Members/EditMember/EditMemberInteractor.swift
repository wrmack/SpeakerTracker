//
//  EditMemberInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 11/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine


class EditMemberInteractor {

    func displaySelectedMember(entityState: EntityState, presenter: EditMemberPresenter, selectedMasterRow: Int) {
        let member = entityState.sortedMembers[selectedMasterRow]
        presenter.presentViewModel(selectedMember: member)
    }
    
    
    /**
     Saves member being edited.  
     */
    func saveMemberToEntity(entityState: EntityState, setupState: SetupState, title: String, first: String, last: String, selectedMasterRow: Int) {
        let entityState = entityState
        let setupState = setupState
        
        var currentEntity = entityState.currentEntity!
        let memberTitle = title
        let memberFirstName = first
        let memberLastName = last
        
        var memberToEdit = entityState.sortedMembers[selectedMasterRow]
        memberToEdit.title = memberTitle
        memberToEdit.firstName = memberFirstName
        memberToEdit.lastName = memberLastName
        
        var newMembers = [Member]()
        currentEntity.members!.forEach({ member in
            var newMbr = member
            if member.id == memberToEdit.id {
                newMbr.title = memberToEdit.title
                newMbr.firstName = memberToEdit.firstName
                newMbr.lastName = memberToEdit.lastName
            }
            newMembers.append(newMbr)
        })
        
        currentEntity.members = newMembers
        
        let savedEntity = UserDefaultsManager.getCurrentEntity()
        if savedEntity == currentEntity {
            UserDefaultsManager.saveCurrentEntity(entity: currentEntity)
        }
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("EditMemberInteractor: saveMemberToEntity: error: Document directory not found")
            return
        }
        let docFileURL = docDirectory.appendingPathComponent(currentEntity.id.uuidString + ".ent")
        let entityDoc = EntityDocument(fileURL: docFileURL)
        entityDoc.open(completionHandler: { success in
            if !success {
                print("EditMemberInteractor: saveMemberToEntity: error opening EntityDocument")
            }
            else {
                entityDoc.entity = currentEntity
                entityDoc.updateChangeCount(.done)
                entityDoc.close(completionHandler: { success in
                    if !success {
                        print("EditMemberInteractor: saveMemberToEntity: Error saving")
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
                    }
                    
                })
            }
        })
    }
}
