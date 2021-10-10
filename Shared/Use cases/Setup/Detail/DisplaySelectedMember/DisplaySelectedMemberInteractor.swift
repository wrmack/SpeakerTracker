//
//  DisplaySelectedMemberInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 7/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation

/// `DisplaySelectedMemberInteractor` is responsible for interacting with the data model.
class DisplaySelectedMemberInteractor {
   
    func fetchMember(presenter: DisplaySelectedMemberPresenter, entityState: EntityState, newIndex: UUID?) {
        print("------ DisplaySelectedMemberInteractor.fetchMember")
        var memberIndex: UUID?
        if newIndex == nil {
            guard let members = entityState.sortedMembers(entity: entityState.currentEntity!) else {return}
            if members.count == 0 {return}
            memberIndex = members[0].idx
        }
        else {
            memberIndex = newIndex
        }
        let member = entityState.memberWithIndex(index: memberIndex!)
        presenter.presentMemberDetail(member: member)
   }
    
    func fetchMemberFromChangingEntity(presenter: DisplaySelectedMemberPresenter, entity: Entity, selectedMasterRow: Int) {
        print("------ DisplaySelectedMemberInteractor.fetchMemberFromChangingEntity")

//        let row = selectedMasterRow
//        
//        var sortedMbrs = [Member]()
//        if entity.members != nil {
//           let members = entity.members!
//            sortedMbrs = members.sorted(by: {
//              if $0.lastName! < $1.lastName! {
//                 return true
//              }
//              return false
//           })
//        }
//        var currentMember: Member?
//        if sortedMbrs.count > 0 {
//            currentMember = sortedMbrs[row]
//        }
//        presenter.presentMemberDetail(member: currentMember)
   }
}
