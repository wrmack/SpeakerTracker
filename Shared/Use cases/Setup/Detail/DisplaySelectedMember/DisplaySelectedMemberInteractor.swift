//
//  DisplaySelectedMemberInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 7/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation

class DisplaySelectedMemberInteractor {
   
   
    func fetchMember(presenter: DisplaySelectedMemberPresenter, entityState: EntityState, selectedMasterRow: Int) {
        print("DisplaySelectedMemberInteractor.fetchMember")

        let row = selectedMasterRow
        let members = entityState.sortedMembers
        var currentMember: Member?
        if members.count > 0 {
            currentMember = members[row]
        }
        presenter.presentMemberDetail(member: currentMember)
   }
    
    func fetchMemberFromChangingEntity(presenter: DisplaySelectedMemberPresenter, entity: Entity, selectedMasterRow: Int) {
        print("DisplaySelectedMemberInteractor.fetchMember")

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
