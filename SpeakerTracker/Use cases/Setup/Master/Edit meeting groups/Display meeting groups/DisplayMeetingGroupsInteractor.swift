//
//  DisplayMeetingGroupsInteractor.swift
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

protocol DisplayMeetingGroupsBusinessLogic {
    func fetchMeetingGroups(request: DisplayMeetingGroups.MeetingGroups.Request)
    func setCurrentMeetingGroup(index: Int)
    func refreshMeetingGroups()
}

protocol DisplayMeetingGroupsDataStore {
    var meetingGroup: MeetingGroup? {get set}
    var entity: Entity? {get set}
}



class DisplayMeetingGroupsInteractor: DisplayMeetingGroupsBusinessLogic, DisplayMeetingGroupsDataStore {
    var presenter: DisplayMeetingGroupsPresentationLogic?
    var entity: Entity?
    var meetingGroup: MeetingGroup?
    var meetingGroups: [MeetingGroup]?

    
    // MARK: VIP
    
    func fetchMeetingGroups(request: DisplayMeetingGroups.MeetingGroups.Request) {
        self.meetingGroups = [MeetingGroup]()
        self.meetingGroup = nil
        self.entity = request.entity
        self.meetingGroups = request.entity?.meetingGroups
        let response = DisplayMeetingGroups.MeetingGroups.Response(meetingGroups: self.meetingGroups)
        self.presenter?.presentMeetingGroups(response: response)
    }
    
    /*
     Meeting group has to be set, even if nil (so a previous value does not persist)
     */
    func setCurrentMeetingGroup(index: Int) {
        if meetingGroups != nil {
            meetingGroup = meetingGroups![index]
        }
        else {
            meetingGroup = nil
        }
    }
    
    
    func refreshMeetingGroups() {
        self.meetingGroups = entity?.meetingGroups
        let response = DisplayMeetingGroups.MeetingGroups.Response(meetingGroups: self.meetingGroups)
        self.presenter?.presentMeetingGroups(response: response)
    }
}
