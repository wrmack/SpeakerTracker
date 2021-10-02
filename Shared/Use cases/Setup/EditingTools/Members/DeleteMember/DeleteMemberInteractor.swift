//
//  DeleteMemberInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 11/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine


class DeleteMemberInteractor {

    init() {
        print("DeleteMemberInteractor initialised")
    }

    deinit {
        print("DeleteMemberInteractor de-initialised")
    }
   
    
    func displaySelectedMember(entityState: EntityState, presenter: DeleteMemberPresenter, selectedMasterRow: Int) {
        let member = entityState.sortedMembers[selectedMasterRow]
        presenter.presentViewModel(selectedMember: member)
    }
    
    
    func deleteSelectedMemberFromEntity(entityState: EntityState, setupState: SetupState, selectedMasterRow: Int) {
//        let entityState = entityState
//        let setupState = setupState
//        var currentEntity = entityState.currentEntity!
//        let currentMembers = currentEntity.members
//        let memberToDelete = entityState.sortedMembers[selectedMasterRow]
//        var newMembers = [Member]()
//        
//        currentMembers?.forEach({ member in
//            if member.id != memberToDelete.id {
//                newMembers.append(member)
//            }
//        })
//
//        currentEntity.members = newMembers
//        
//        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            print("DeleteMemberInteractor: deleteMember: error: Document directory not found")
//            return
//        }
//        let file = currentEntity.id.uuidString 
//        let docFileURL = docDirectory.appendingPathComponent(file + ".ent")
//        let entityDoc = EntityDocument(fileURL: docFileURL)
//        entityDoc.open(completionHandler: { success in
//           if !success {
//              print("DeleteMemberInteractor: deleteSelectedMemberFromEntity: error opening EntityDocument")
//           }
//           else {
//              entityDoc.entity = currentEntity
//              entityDoc.updateChangeCount(.done)
//              entityDoc.close(completionHandler: { success in
//                 if !success {
//                    print("DeleteMemberInteractor: deleteSelectedMemberFromEntity: Error saving")
//                 }
//                 else{
//                    print("entityDoc: \(entityDoc)")
//                    var newEntities = [Entity]()
//                    entityState.entities.forEach({ entity in
//                        if entity.id == currentEntity.id {
//                            newEntities.append(currentEntity)
//                        }
//                        else {
//                            newEntities.append(entity)
//                        }
//                    })
//                    entityState.entities = newEntities
//                    entityState.currentEntity = currentEntity
//                    setupState.numberOfRows -= 1
//                 }
//
//              })
//           }
//        })
   }
}
