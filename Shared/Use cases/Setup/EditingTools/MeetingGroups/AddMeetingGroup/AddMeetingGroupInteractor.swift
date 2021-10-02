//
//  AddMeetingGroupInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 10/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine

class AddMeetingGroupInteractor {
    
    // MARK: Model management
    
    /*
     Saves member to model and persistent storage.
     Called when user decides to save new member.
     tempMemberList is an array that is updated when user presses the "Add another" button, but is not saved until this is called.
     Also updates current entity in user defaults.
     */
    func saveMeetingGroupToEntity(entityState: EntityState, setupState: SetupState, meetingGroupName: String, members: Set<Member>?) {
        let entityState = entityState
        let setupState = setupState
        var currentEntity = entityState.currentEntity!
        let meetingGroupName = meetingGroupName
        let members = members
        
        var memberIDs = [UUID]()
        members?.forEach({ member in
            memberIDs.append(member.id)
        })
        let newMeetingGroup = MeetingGroup(name: meetingGroupName, memberIDs: memberIDs, fileName: nil)
        
        if currentEntity.meetingGroups == nil {
            currentEntity.meetingGroups = [MeetingGroup]()
        }
        currentEntity.meetingGroups?.append(newMeetingGroup)
        currentEntity.meetingGroups?.sort(by: {
            if $0.name! < $1.name! {
                return true
            }
            return false
        })
        
//        let savedEntity = UserDefaultsManager.getCurrentEntity()
//        if savedEntity == self.entity {
//            UserDefaultsManager.saveCurrentEntity(entity: currentEntity)
//        }
        
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("AddMeetingGroupInteractor: saveMeetingGroupToEntity: error: Document directory not found")
            return
        }
        let docFileURL = docDirectory.appendingPathComponent(currentEntity.id.uuidString + ".ent")
        let entityDoc = EntityDocument(fileURL: docFileURL)
        entityDoc.open(completionHandler: { success in
            if !success {
                print("AddMeetingGroupInteractor: saveMeetingGroupToEntity: error opening EntityDocument")
            }
            else {
                print("entityDoc: \(entityDoc)")
                if entityDoc.entity!.meetingGroups == nil {
                    entityDoc.entity!.meetingGroups = [MeetingGroup]()
                }
                entityDoc.entity?.meetingGroups?.append(newMeetingGroup)
                entityDoc.updateChangeCount(.done)
                entityDoc.close(completionHandler: { success in
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
                    entityState.meetingGroupMembers = Set<Member>()
                })
            }
        })
    }
    
    
//    func addMeetingGroupToTempList(member: MeetingGroup) {
//        if tempMeetingGroupList == nil { tempMeetingGroupList = [MeetingGroup]()}
//        tempMeetingGroupList?.append(member)
//    }
}
