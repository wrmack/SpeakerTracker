//
//  DisplaySelectedMeetingGroupInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 10/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation


class DisplaySelectedMeetingGroupInteractor {
    
    func fetchMeetingGroup(presenter: DisplaySelectedMeetingGroupPresenter, entityState: EntityState, newIndex: UUID?) {
        print("------ DisplaySelectedMeetingGroupInteractor.fetchMeetingGroup")
        
        var meetingGroupIndex: UUID?
        if newIndex == nil {
            guard let meetingGroups = entityState.sortedMeetingGroups(entity: entityState.currentEntity!) else {return}
            if meetingGroups.count == 0 {return}
            meetingGroupIndex = meetingGroups[0].idx
        }
        else {
            meetingGroupIndex = newIndex
        }
        let meetingGroup = entityState.meetingGroupWithIndex(index: meetingGroupIndex!)
        
        presenter.presentMeetingGroupDetail(meetingGroup: meetingGroup)
    }
    
    func fetchMeetingGroupFromChangingEntity(presenter: DisplaySelectedMeetingGroupPresenter, entity: Entity, selectedMasterRow: Int) {
        print("------ DisplaySelectedMemberInteractor.fetchMember")

//        let row = selectedMasterRow
//        
//        var sortedMtgGrps = [MeetingGroup]()
//        if entity.meetingGroups != nil {
//           let mtgGrps = entity.meetingGroups!
//            sortedMtgGrps = mtgGrps.sorted(by: {
//              if $0.name! < $1.name! {
//                 return true
//              }
//              return false
//           })
//        }
//        var currentMeetingGroup: MeetingGroup?
//        if sortedMtgGrps.count > 0 {
//            currentMeetingGroup = sortedMtgGrps[row]
//        }
//        var currentMembers = [Member]()
//        currentMeetingGroup!.memberIDs?.forEach({ id in
//            entity.members?.forEach({ member in
//                if member.id == id {
//                    currentMembers.append(member)
//                }
//            })
//        })
//        presenter.presentMeetingGroupDetail(name:currentMeetingGroup?.name, members: currentMembers)
   }
}
