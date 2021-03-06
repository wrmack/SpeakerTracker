//
//  EditMeetingGroupPresenter.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 14/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol EditMeetingGroupPresentationLogic {
    func presentMembers(response: EditMeetingGroup.MeetingGroup.Response)
}


class EditMeetingGroupPresenter: EditMeetingGroupPresentationLogic {
    weak var viewController: EditMeetingGroupDisplayLogic?

    // MARK: Do something

    func presentMembers(response: EditMeetingGroup.MeetingGroup.Response) {
        var memberString: String?
        let members = response.members 
        if members != nil {
            memberString = String()
            for member in members! {
                if memberString!.count > 0 {
                    memberString!.append(", ")
                }
                memberString!.append((member.firstName ?? "") + " " + member.lastName!)
            }
        }
        let viewModel = EditMeetingGroup.MeetingGroup.ViewModel(memberNames: memberString)
        viewController?.displayMemberNames(viewModel: viewModel)
    }
}
