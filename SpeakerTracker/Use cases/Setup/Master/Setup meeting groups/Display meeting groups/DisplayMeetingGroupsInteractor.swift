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
    func getCurrentMeetingGroupIndex()->Int?
    func setCurrentMeetingGroup(index: Int)
    func refreshMeetingGroups()
     func checkEntitySelected() ->Bool?
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
        self.meetingGroups?.sort(by: {
            if $0.name! < $1.name! {
                return true
            }
            return false
        })
        let response = DisplayMeetingGroups.MeetingGroups.Response(meetingGroups: self.meetingGroups)
        self.presenter?.presentMeetingGroups(response: response)
    }
    
    
    func getCurrentMeetingGroupIndex()->Int? {
        if meetingGroup != nil {
            return meetingGroups!.firstIndex(of: meetingGroup!)
        }
        return 0
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
    
    func checkEntitySelected() ->Bool? {
        let isSelected = self.entity != nil ? true : false
        return isSelected
    }
}
