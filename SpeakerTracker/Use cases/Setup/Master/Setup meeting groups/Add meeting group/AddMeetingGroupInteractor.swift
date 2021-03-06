//
//  AddMeetingGroupInteractor.swift
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

protocol AddMeetingGroupBusinessLogic {
    func fetchMembers(request: AddMeetingGroup.MeetingGroup.Request)
    func saveMeetingGroupToEntity(meetingGroup: MeetingGroup, callback: @escaping ()->())
}

protocol AddMeetingGroupDataStore {
    var entity: Entity? { get set }
    var memberIDs: [UUID]? {get set}
}


class AddMeetingGroupInteractor: AddMeetingGroupBusinessLogic, AddMeetingGroupDataStore {
    var presenter: AddMeetingGroupPresentationLogic?
    var entity: Entity?
    var memberIDs: [UUID]?
    
    
    // MARK: VIP
    
    func fetchMembers(request: AddMeetingGroup.MeetingGroup.Request) {
        var members = [Member]()
        for memberID in memberIDs! {
            let mmbr = entity?.members?.first(where: {$0.id == memberID })
            members.append(mmbr!)
        }
        let response = AddMeetingGroup.MeetingGroup.Response(members: members)
        self.presenter?.presentMembers(response: response)
    }
    
    // MARK: Update entity models
    
    func saveMeetingGroupToEntity(meetingGroup: MeetingGroup, callback: @escaping ()->()) {
        var meetingGroup = meetingGroup
        meetingGroup.memberIDs = self.memberIDs
        if entity!.meetingGroups == nil {
            entity!.meetingGroups = [MeetingGroup]()
        }
        meetingGroup.id = UUID()
        entity?.meetingGroups?.append(meetingGroup)
        entity?.meetingGroups?.sort(by: {
            if $0.name! < $1.name! {
                return true
            }
            return false
        })
        let savedEntity = UserDefaultsManager.getCurrentEntity()
        if savedEntity == self.entity {
            UserDefaultsManager.saveCurrentEntity(entity: self.entity!)
        }
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("AddMeetingGroupInteractor: saveMeetingGroupToEntity: error: Document directory not found")
            return
        }
        let docFileURL = docDirectory.appendingPathComponent((entity?.id?.uuidString)! + ".ent")
        let entityDoc = EntityDocument(fileURL: docFileURL)
        entityDoc.open(completionHandler: { success in
            if !success {
                print("AddMeetingGroupInteractor: saveMeetingGroupToEntity: error opening EntityDocument")
            }
            else {
                
                if entityDoc.entity!.meetingGroups == nil {
                    entityDoc.entity!.meetingGroups = [MeetingGroup]()
                }
                entityDoc.entity?.meetingGroups?.append(meetingGroup)
                entityDoc.updateChangeCount(.done)
                entityDoc.close(completionHandler: { success in
//                    print(entityDoc)
                    callback()
                })
            }
        })
    }
}
