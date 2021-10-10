//
//  DisplayMembersPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 29/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine

/// The model that is used by the presenter for publishing members
struct MemberViewModel: Hashable {
   var name: String
   var idx: UUID
}

/// `DisplayMembersPresenter` is responsible for formatting data it receives from `DisplayMembersInteractor`
/// so that it is ready for presentation by `DisplayMembersView`.
class DisplayMembersPresenter: ObservableObject {

   @Published var members = [MemberViewModel]()
   
   init() {
      print("++++++ DisplayMembersPresenter initialized")
   }
   
   deinit {
      print("++++++ DisplayMembersPresenter de-initialized")
   }
   
    /// Receives members and stores them in the presenter's publisher using the presenter's view model
   func presentMembers(members: [Member]?) {
       var tempMembers = members
       tempMembers?.sort(by: {
           if $0.lastName! < $1.lastName! { return true }
           return false
       })
      var tempMemberVMs = [MemberViewModel]()
      if members != nil {
         for member in members! {
             let memberName = member.lastName == "" ? "test" : member.lastName
             tempMemberVMs.append(MemberViewModel(name:memberName!, idx: member.idx!))
         }

      }
      print("------ DisplayMembersPresenter presentMembers")
      self.members = tempMemberVMs
   }
}
