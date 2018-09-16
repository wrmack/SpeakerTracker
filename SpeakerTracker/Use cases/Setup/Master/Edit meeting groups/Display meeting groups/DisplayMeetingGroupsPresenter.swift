//
//  DisplayMeetingGroupsPresenter.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 8/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DisplayMeetingGroupsPresentationLogic {
    func presentMeetingGroups(response: DisplayMeetingGroups.MeetingGroups.Response)
}


class DisplayMeetingGroupsPresenter: DisplayMeetingGroupsPresentationLogic {
    weak var viewController: DisplayMeetingGroupsDisplayLogic?

    // MARK: VIP

    func presentMeetingGroups(response: DisplayMeetingGroups.MeetingGroups.Response) {
        var meetingGroupNames = [String]()
        if let meetingGroups = response.meetingGroups {
            for meetingGroup in meetingGroups {
                let name = (meetingGroup.name ?? "")
                meetingGroupNames.append(name)
            }
        }
        let viewModel = DisplayMeetingGroups.MeetingGroups.ViewModel(meetingGroupNames: meetingGroupNames)
        viewController?.displayMeetingGroups(viewModel: viewModel)
    }
}
