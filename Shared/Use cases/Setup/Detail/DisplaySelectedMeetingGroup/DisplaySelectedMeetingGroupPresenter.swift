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

    @Published var meetingGroupViewModel = [MeetingGroupViewModelRecord]()
    
    init() {
        print("++++++ DisplaySelectedMeetingGroupPresenter initialized")
    }
    
    deinit {
        print("++++++ DisplaySelectedMeetingGroupPresenter de-initialized")
    }
    
    func presentMeetingGroupDetail(meetingGroup: MeetingGroup?) {
        var tempArray = [MeetingGroupViewModelRecord]()
        if meetingGroup != nil {
            var name = ""
            if meetingGroup!.name != nil {
                name = meetingGroup!.name!
            }
            tempArray.append(MeetingGroupViewModelRecord(label: "Name", value: name))
                
            var mbrString =  ""
            if meetingGroup!.members != nil {
                meetingGroup!.members!.forEach({ val in
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
            }
            
            tempArray.append(MeetingGroupViewModelRecord(label: "Members", value: mbrString))
        }
        
        meetingGroupViewModel = tempArray
    }
}
