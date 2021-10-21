//
//  DisplayMeetingGroupsForReportsPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 24/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation

struct MeetingGroupForReportsViewModel: Hashable {
   var name: String
   var idx: UUID
}

class DisplayMeetingGroupsForReportsPresenter : ObservableObject {
    @Published var meetingGroups = [MeetingGroupForReportsViewModel]()

    func presentMeetingGroups(meetingGroups: [MeetingGroup]?) {
        var tempMeetingGroups = meetingGroups
        tempMeetingGroups?.sort(by: {
            if $0.name! < $1.name! { return true }
            return false
        })
       var tempMeetingGroupVMs = [MeetingGroupForReportsViewModel]()
       if meetingGroups != nil {
          for meetingGroup in meetingGroups! {
              let meetingGroupName = meetingGroup.name == "" ? "test" : meetingGroup.name
              tempMeetingGroupVMs.append(MeetingGroupForReportsViewModel(name:meetingGroupName!, idx: meetingGroup.idx!))
          }

       }
        print("DisplayMeetingGroupsForReportsPresenter presentMeetingGroupNames")
        self.meetingGroups = tempMeetingGroupVMs
    }
}
