//
//  DisplayMeetingGroupsInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 10/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine



class DisplayMeetingGroupsInteractor {

   
   init() {
      print("DisplayMeetingGroupsInteractor initialized")
   }
   
   deinit {
      print("DisplayMeetingGroupsInteractor de-initialized")
   }

   
    func fetchMeetingGroups(entity: Entity, presenter: DisplayMeetingGroupsPresenter) {
      var meetingGroups = [MeetingGroup]()
      if entity.meetingGroups != nil {
         meetingGroups = entity.meetingGroups!
         meetingGroups.sort(by: {
            if $0.name! < $1.name! {
               return true
            }
            return false
         })
      }

      presenter.presentMeetingGroupNames(meetingGroups: meetingGroups)
   }
   
   
   func meetingGroupAtRow(row: Int) {
      print("DisplayMeetingGroupsInteractor meetingGroupAtRow row: \(row)")
//      if self.meetingGroups != nil && self.meetingGroups!.count > 0 {
//         self.detailState?.currentMeetingGroup = self.meetingGroups![row]
//      }
//      else {
//         self.detailState?.currentMeetingGroup = nil
//      }
   }
   
}
