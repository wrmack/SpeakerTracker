//
//  DisplaySelectedMeetingGroupPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 10/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine

struct MeetingGroupViewModelRecord: Hashable {
    var label: String
    var value: String
}



class DisplaySelectedMeetingGroupPresenter: ObservableObject {
    @Published var presenterUp = true
    @Published var meetingGroupViewModel = [MeetingGroupViewModelRecord]()
    
    init() {
        print("DisplaySelectedMeetingGroupPresenter initialized")
    }
    
    deinit {
        print("DisplaySelectedMeetingGroupPresenter de-initialized")
    }
    
    func presentMeetingGroupDetail(name: String?, members: [Member]?) {
        var tempArray = [MeetingGroupViewModelRecord]()
        if name != nil && members != nil {
            tempArray.append(MeetingGroupViewModelRecord(label: "Name", value: name!))
            var mbrString =  ""
            members!.forEach({ member in
                if (mbrString.count > 0) {
                   mbrString.append(", ")
                }
                var fullTitle: String?
                if let title = member.title {
                   fullTitle = title + " "
                }
                mbrString.append((fullTitle ?? "") + (member.firstName ?? "") + " " + member.lastName!)
            })
            
            tempArray.append(MeetingGroupViewModelRecord(label: "Members", value: mbrString))
        }
        meetingGroupViewModel = tempArray
    }
}
