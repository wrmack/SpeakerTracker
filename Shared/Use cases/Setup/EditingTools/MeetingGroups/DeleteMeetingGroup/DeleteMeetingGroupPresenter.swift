//
//  DeleteMeetingGroupPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 15/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation


struct DeleteMeetingGroupViewModel {
    var name = ""
    var members = ""
}

class DeleteMeetingGroupPresenter: ObservableObject {
    @Published var viewModel = DeleteMeetingGroupViewModel()
    
    func presentViewModel(selectedMeetingGroup: MeetingGroup) {
        let meetingGroupName = selectedMeetingGroup.name
        var meetingGroupMembers = ""
        let members = selectedMeetingGroup.groupMembers
        if members != nil {
            var mbrString =  ""
            members!.forEach({ val in
                let member = val as! Member
                if (mbrString.count > 0) {
                   mbrString.append(", ")
                }
                var fullTitle: String?
                if let title = member.title {
                   fullTitle = title + " "
                }
                mbrString.append((fullTitle ?? "") + (member.firstName ?? "") + " " + member.lastName!)
            })
            meetingGroupMembers = mbrString
        }
        let tempModel = DeleteMeetingGroupViewModel(name: meetingGroupName!, members: meetingGroupMembers)
        viewModel = tempModel
    }
}
