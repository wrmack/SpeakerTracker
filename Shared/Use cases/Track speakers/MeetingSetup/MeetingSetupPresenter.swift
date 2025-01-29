//
//  MeetingSetupPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 18/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation

struct MeetingSetupViewModel {
    var entityName = ""
//    var meetingGroupName = ""
    var meetingGroupNameWithId = ("", UUID()) 
}

class MeetingSetupPresenter : ObservableObject {
//    @Published var presenterUp = true
    @Published var setupViewModel = MeetingSetupViewModel()
    
    init() {
        print("MeetingSetupPresenter initialized")
    }
    
    deinit {
        print("MeetingSetupPresenter de-initialized")
    }
    
    // Initial presentation
    func presentSetup(currentEntity: Entity?, currentMeetingGroup: MeetingGroup?) {
        print("presentSetup called")
        let entityName = currentEntity?.name ?? "None"
//        let meetingGroupName = currentMeetingGroup?.name ?? "None"
        let meetingGroupNameWithId = (currentMeetingGroup?.name ?? "None", currentMeetingGroup?.idx ?? UUID())
        setupViewModel = MeetingSetupViewModel(entityName: entityName, meetingGroupNameWithId: meetingGroupNameWithId)
    }
    

}
