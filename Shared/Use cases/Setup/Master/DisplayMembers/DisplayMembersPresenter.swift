//
//  DisplayMembersPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 29/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine


struct MemberName: Hashable {
   var name: String
   var idx: Int
}

class DisplayMembersPresenter: ObservableObject {
   var members = [Member]()
   @Published var memberNames = [MemberName]()
   
   init() {
      print("DisplayMembersPresenter initialized")
   }
   
   deinit {
      print("DisplayMembersPresenter de-initialized")
   }
   
   func presentMemberNames(members: [Member]?) {
      var tempNames = [String]()
      var tempMemberNames = [MemberName]()
      if members != nil {
         for member in members! {
            tempNames.append(member.lastName!)
            tempNames.sort(by: {
               if $0 < $1 {
                  return true
               }
               return false
            })
         }
         var idx = 0
         tempNames.forEach({ el in
            tempMemberNames.append(MemberName(name: el, idx: idx))
            idx += 1
         })
      }
      print("DisplayMembersPresenter presentMemberNames")
      self.memberNames = tempMemberNames
   }
}
