//
//  DisplayMeetingGroupsPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 10/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine


struct MeetingGroupViewModel: Hashable {
   var name: String
   var idx: UUID
}

class DisplayMeetingGroupsPresenter: ObservableObject {

   @Published var meetingGroups = [MeetingGroupViewModel]()

   
   init() {
      print("++++++ DisplayMeetingGroupsPresenter initialized")
   }
   
   deinit {
      print("++++++ isplayMeetingGroupsPresenter de-initialized")
   }
   
   func presentMeetingGroups(meetingGroups: [MeetingGroup]?) {
       var tempMeetingGroups = meetingGroups
       tempMeetingGroups?.sort(by: {
           if $0.name! < $1.name! { return true }
           return false
       })
      var tempMeetingGroupVMs = [MeetingGroupViewModel]()
      if meetingGroups != nil {
         for meetingGroup in meetingGroups! {
             let meetingGroupName = meetingGroup.name == "" ? "test" : meetingGroup.name
             tempMeetingGroupVMs.append(MeetingGroupViewModel(name:meetingGroupName!, idx: meetingGroup.idx!)) 
         }

      }
      print("------ DisplayMeetingGroupsPresenter presentMembers")
      self.meetingGroups = tempMeetingGroupVMs

   }
}
