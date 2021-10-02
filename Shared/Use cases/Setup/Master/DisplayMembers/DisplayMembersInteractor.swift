//
//  DisplayMembersInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 29/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine



class DisplayMembersInteractor {
   
   init() {
      print("DisplayMembersInteractor initialized")
   }
   
   deinit {
      print("DisplayMembersInteractor de-initialized")
   }
   
    func fetchMembers(entity: Entity, presenter: DisplayMembersPresenter) {
      var members = [Member]()
      if entity.members != nil {
         members = entity.members!
         members.sort(by: {
            if $0.lastName! < $1.lastName! {
               return true
            }
            return false
         })
      }
//      setupState.membersMasterIsSetup = true
      presenter.presentMemberNames(members: members)
//      setupState.selectedRow = 0 
   }
   
//   func fetchMembersForEntity(entity: Entity) {
//      self.entity = entity
//      fetchMembers()
//   }
   
   
   
   func memberAtRow(row: Int) {
      print("DisplayMembersInteractor memberAtRow row: \(row)")
//      if self.members != nil && self.members!.count > 0 {
//         self.detailState?.currentMember = self.members![row]
//         self.masterState?.selectedRow = row
//      }
//      else {
//         self.detailState?.currentMember = nil
//      }
   }
   

}
