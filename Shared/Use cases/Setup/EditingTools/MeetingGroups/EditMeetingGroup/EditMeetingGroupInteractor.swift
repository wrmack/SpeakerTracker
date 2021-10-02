//
//  EditMeetingGroupInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 14/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation


class EditMeetingGroupInteractor {
    
    func displaySelectedMeetingGroup(entityState: EntityState, presenter: EditMeetingGroupPresenter, selectedMasterRow: Int) {
        let meetingGroup = entityState.sortedMeetingGroups[selectedMasterRow]
        var members = [Member]()
//        meetingGroup.members!.forEach({ id in
//            entityState.currentEntity?.members?.forEach({ member in
//                if member.id == id {
//                    members.append(member)
//                }
//            })
//        })
        presenter.presentViewModel(name: meetingGroup.name!, members: members)
    }
    
    func saveMeetingGroupToEntity(entityState: EntityState, setupState: SetupState, meetingGroupName: String, members: Set<Member>?, selectedMasterRow: Int) {
//        let entityState = entityState
//        let setupState = setupState
//        var currentEntity = entityState.currentEntity!
//        var meetingGroupToEdit = entityState.sortedMeetingGroups[selectedMasterRow]
//        
//        let meetingGroupName = meetingGroupName
//        let members = members
//        var memberIDs = [UUID]()
//        members?.forEach({ member in
//            memberIDs.append(member.id!)
//        })
//        meetingGroupToEdit.name = meetingGroupName
//        meetingGroupToEdit.memberIDs = memberIDs
//        
//        var newMeetingGroups = [MeetingGroup]()
//        currentEntity.meetingGroups?.forEach({ meetingGroup in
//            var newGroup = meetingGroup
//            if meetingGroup.id == meetingGroupToEdit.id {
//                newGroup.name = meetingGroupName
//                newGroup.memberIDs = memberIDs
//            }
//            newMeetingGroups.append(newGroup)
//        })
//        currentEntity.meetingGroups = newMeetingGroups
//        
////        currentEntity.meetingGroups?.sort(by: {
////            if $0.name! < $1.name! {
////                return true
////            }
////            return false
////        })
//        
////        let savedEntity = UserDefaultsManager.getCurrentEntity()
////        if savedEntity == self.entity {
////            UserDefaultsManager.saveCurrentEntity(entity: currentEntity)
////        }
//        
//        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            print("EditMeetingGroupInteractor: saveMeetingGroupToEntity: error: Document directory not found")
//            return
//        }
//        let docFileURL = docDirectory.appendingPathComponent(currentEntity.id.uuidString + ".ent")
//        let entityDoc = EntityDocument(fileURL: docFileURL)
//        entityDoc.open(completionHandler: { success in
//            if !success {
//                print("EditMeetingGroupInteractor: saveMeetingGroupToEntity: error opening EntityDocument")
//            }
//            else {
//                print("entityDoc: \(entityDoc)")
//                entityDoc.entity = currentEntity
//                entityDoc.updateChangeCount(.done)
//                entityDoc.close(completionHandler: { success in
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
//                })
//            }
//        })
    }
}
