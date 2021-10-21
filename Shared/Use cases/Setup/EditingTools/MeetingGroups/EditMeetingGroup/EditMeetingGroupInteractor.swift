//
//  EditMeetingGroupInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 14/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation


class EditMeetingGroupInteractor {
    
    class func displaySelectedMeetingGroup(entityState: EntityState, presenter: EditMeetingGroupPresenter) {
        
        guard let meetingGroup = entityState.currentMeetingGroup else {return}
        presenter.presentViewModel(selectedMeetingGroup: meetingGroup)
    
    }
    
    class func saveChangedMeetingGroupToStore(entityState: EntityState, meetingGroupName: String, members: Set<Member>?) {

        let currentMeetingGroup = entityState.currentMeetingGroup
        currentMeetingGroup?.name = meetingGroupName
        currentMeetingGroup?.groupMembers = members as NSSet?
        EntityState.saveManagedObjectContext()
    }
}
