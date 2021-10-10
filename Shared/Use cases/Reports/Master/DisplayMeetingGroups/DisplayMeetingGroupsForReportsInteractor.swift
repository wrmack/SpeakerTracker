//
//  DisplayMeetingGroupsForReportsInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 24/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation

class DisplayMeetingGroupsForReportsInteractor {
    
    func fetchMeetingGroups(entity: Entity, presenter: DisplayMeetingGroupsForReportsPresenter ) {
        var meetingGroups = [MeetingGroup]()
        if entity.meetingGroups != nil {
            meetingGroups = entity.meetingGroups!.allObjects as! [MeetingGroup] 
           meetingGroups.sort(by: {
              if $0.name! < $1.name! {
                 return true
              }
              return false
           })
        }
//        presenter.presentMeetingGroupNames(meetingGroups: meetingGroups)
    }
}
