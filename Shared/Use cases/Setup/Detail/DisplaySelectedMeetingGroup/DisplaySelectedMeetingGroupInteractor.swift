//
//  DisplaySelectedMeetingGroupInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 10/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation


class DisplaySelectedMeetingGroupInteractor {
    
    class func fetchMeetingGroup(presenter: DisplaySelectedMeetingGroupPresenter, entityState: EntityState,setupSheetState:SetupSheetState, newIndex: UUID?) {
        print("------ DisplaySelectedMeetingGroupInteractor.fetchMeetingGroup newIndex \(String(describing: newIndex))")
        
        var meetingGroupIndex: UUID?

        // newIndex is nil when method called by .onAppear
        if newIndex == nil {
            if let currentMeetingGroupIndex = entityState.currentMeetingGroupIndex {
                meetingGroupIndex = currentMeetingGroupIndex
            }
            else {
                if entityState.currentEntityIndex == nil {
                    setupSheetState.addDisabled = true
                } else {
                    setupSheetState.addDisabled = false
                }
                setupSheetState.editDisabled = true
                setupSheetState.deleteDisabled = true
                presenter.presentMeetingGroupDetail(meetingGroup: nil)
                return
            }
        }
        else {
            meetingGroupIndex = newIndex
        }
        let selectedMeetingGroup = EntityState.meetingGroupWithIndex(index: meetingGroupIndex!)
        setupSheetState.addDisabled = false
        setupSheetState.deleteDisabled = false
        setupSheetState.editDisabled = false
        presenter.presentMeetingGroupDetail(meetingGroup: selectedMeetingGroup)
    }
    
}
