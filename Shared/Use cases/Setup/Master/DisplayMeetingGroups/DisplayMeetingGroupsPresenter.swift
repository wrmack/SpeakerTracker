//
//  DisplayMeetingGroupsPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 10/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine


struct MeetingGroupName: Hashable {
   var name: String
   var idx: Int
}

class DisplayMeetingGroupsPresenter: ObservableObject {
   var meetingGroups = [MeetingGroup]()
   @Published var meetingGroupNames = [MeetingGroupName]()
   @Published var presenterUp = true  // Used to signal to DisplayMeetingGroupsView to fetch data
   
   init() {
      print("DisplayMeetingGroupsPresenter initialized")
   }
   
   deinit {
      print("DisplayMeetingGroupsPresenter de-initialized")
   }
   
   func presentMeetingGroupNames(meetingGroups: [MeetingGroup]?) {
      var tempNames = [String]()
      var tempMeetingGroupNames = [MeetingGroupName]()
      if meetingGroups != nil {
         for meetingGroup in meetingGroups! {
            tempNames.append(meetingGroup.name!)
            tempNames.sort(by: {
               if $0 < $1 {
                  return true
               }
               return false
            })
         }
         var idx = 0
         tempNames.forEach({ el in
            tempMeetingGroupNames.append(MeetingGroupName(name: el, idx: idx))
            idx += 1
         })
      }
      print("DisplayMeetingGroupsPresenter presentMeetingGroupsNames")
      self.meetingGroupNames = tempMeetingGroupNames
   }
}
