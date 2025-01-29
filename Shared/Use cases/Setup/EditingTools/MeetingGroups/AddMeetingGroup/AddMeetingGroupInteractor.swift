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
    
    class func saveMeetingGroupToEntity(entityState: EntityState, setupSheetState: SetupSheetState, meetingGroupName: String, members: Set<Member>?) {
        
        // Existing meeting groups
        let currentEntity = entityState.currentEntity!
        let meetingGroupSet = currentEntity.meetingGroups
        
        let viewContext = PersistenceController.shared.container.viewContext
        let newMeetingGroup = MeetingGroup(context: viewContext)
        newMeetingGroup.name = meetingGroupName
        newMeetingGroup.groupMembers = members as NSSet?
        newMeetingGroup.idx = UUID()
        
        entityState.currentMeetingGroupIndex = newMeetingGroup.idx
        
        currentEntity.meetingGroups = meetingGroupSet!.adding(newMeetingGroup) as NSSet
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        entityState.currentMeetingGroupIndex = newMeetingGroup.idx
        entityState.meetingGroupsHaveChanged = true 
    }
    
    
//    func addMeetingGroupToTempList(member: MeetingGroup) {
//        if tempMeetingGroupList == nil { tempMeetingGroupList = [MeetingGroup]()}
//        tempMeetingGroupList?.append(member)
//    }
}
