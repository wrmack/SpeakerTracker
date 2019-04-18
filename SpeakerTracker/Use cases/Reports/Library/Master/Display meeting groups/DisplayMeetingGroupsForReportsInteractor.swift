//
//  DisplayMeetingGroupsForReportsInteractor.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 22/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DisplayMeetingGroupsForReportsBusinessLogic {
    func fetchMeetingGroups(request: DisplayMeetingGroupsForReports.MeetingGroups.Request)
    func getCurrentMeetingGroupIndex()->Int?
    func setCurrentMeetingGroup(index: Int)
    func setDisplayDeletedGroups()
}

protocol DisplayMeetingGroupsForReportsDataStore {
    var meetingGroup: MeetingGroup? {get set}
    var displayDeletedGroups: Bool? {get set}
}


class DisplayMeetingGroupsForReportsInteractor: DisplayMeetingGroupsForReportsBusinessLogic, DisplayMeetingGroupsForReportsDataStore {
    var presenter: DisplayMeetingGroupsForReportsPresentationLogic?
    var entity: Entity?
    var meetingGroup: MeetingGroup?
    var meetingGroups: [MeetingGroup]?
    var displayDeletedGroups: Bool?
    

    deinit {
        print("Deinitializing:  DisplayMeetingGroupsForReportsInteractor")
    }

    // MARK: VIP
    
    func fetchMeetingGroups(request: DisplayMeetingGroupsForReports.MeetingGroups.Request) {
        self.meetingGroups = [MeetingGroup]()
//        self.meetingGroup = nil
        self.entity = request.entity
        self.meetingGroups = request.entity?.meetingGroups
        let response = DisplayMeetingGroupsForReports.MeetingGroups.Response(meetingGroups: self.meetingGroups)
        self.presenter?.presentMeetingGroups(response: response)
    }
    
    
    func getCurrentMeetingGroupIndex()->Int? {
        if meetingGroup != nil {
            return meetingGroups!.firstIndex(of: meetingGroup!)
        }
        return 0
    }
    
    
    func setCurrentMeetingGroup(index: Int) {
        if meetingGroups != nil {
            meetingGroup = meetingGroups![index]
        }
        displayDeletedGroups = false
    }
    
    func setDisplayDeletedGroups() {
        displayDeletedGroups = true
    }
    
    
}
