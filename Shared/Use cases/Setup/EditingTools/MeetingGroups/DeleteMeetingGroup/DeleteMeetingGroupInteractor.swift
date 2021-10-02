//
//  DeleteMeetingGroupInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 15/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation


class DeleteMeetingGroupInteractor {

    init() {
        print("DeleteMeetingGroupInteractor initialised")
    }

    deinit {
        print("DeleteMeetingGroupInteractor de-initialised")
    }
   
    
    func displaySelectedMeetingGroup(entityState: EntityState, presenter:  DeleteMeetingGroupPresenter, selectedMasterRow: Int) {
//        let meetingGroup = entityState.sortedMeetingGroups[selectedMasterRow]
//        var members = [Member]()
//        meetingGroup.memberIDs?.forEach({ id in
//            entityState.currentEntity?.members?.forEach({ member in
//                if member.id == id {
//                    members.append(member)
//                }
//            })
//        })
//        presenter.presentViewModel(name: meetingGroup.name!, members: members)
    }
    
    
    func deleteSelectedMeetingGroupFromEntity(entityState: EntityState, setupState: SetupState, selectedMasterRow: Int) {
//        let entityState = entityState
//        let setupState = setupState
//        var currentEntity = entityState.currentEntity!
//        let meetingGroupToDelete = entityState.sortedMeetingGroups[selectedMasterRow]
//        
//        var newMeetingGroups = [MeetingGroup]()
//        
//        currentEntity.meetingGroups?.forEach({ meetingGroup in
//            if meetingGroup.id != meetingGroupToDelete.id {
//                newMeetingGroups.append(meetingGroup)
//            }
//        })
//        currentEntity.meetingGroups = newMeetingGroups
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
