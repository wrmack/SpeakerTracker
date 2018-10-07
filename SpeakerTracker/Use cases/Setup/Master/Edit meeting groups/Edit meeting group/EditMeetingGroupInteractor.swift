//
//  EditMeetingGroupInteractor.swift
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

protocol EditMeetingGroupBusinessLogic {
    func getMeetingGroup() -> MeetingGroup?
    func saveMeetingGroupToEntity(meetingGroup: MeetingGroup, callback: @escaping ()->())
    func addMeetingGroupToBeDeletedToDataStore(meetingGroup: MeetingGroup)
    func fetchMembers(request: EditMeetingGroup.MeetingGroup.Request)
}

protocol EditMeetingGroupDataStore {
    var entity: Entity? {get set}
    var meetingGroup: MeetingGroup? {get set}
    var members: [Member]? {get set}
}


class EditMeetingGroupInteractor: EditMeetingGroupBusinessLogic, EditMeetingGroupDataStore {
    var presenter: EditMeetingGroupPresentationLogic?
    var entity: Entity?
    var meetingGroup: MeetingGroup?
    var members: [Member]?
    
    
    // MARK: VIP
    
    /*
     The sub-entity from the editing form is passed in as a parameter.
     The members propoerty was updated through data-passing after members were selected so members need to be added to the sub-entity.
     
     */
    func saveMeetingGroupToEntity(meetingGroup: MeetingGroup, callback: @escaping ()->()) {
        if entity!.meetingGroups == nil {
            entity!.meetingGroups = [MeetingGroup]()
        }
        self.meetingGroup = meetingGroup
        self.meetingGroup?.members = members
        if let idx = entity!.meetingGroups?.firstIndex(where: {$0.id == meetingGroup.id}) {
            entity?.meetingGroups![idx] = self.meetingGroup!
        }
        let defaults = UserDefaults.standard
        if let currentEntityData = defaults.data(forKey: "CurrentEntity") {
            let savedEntity = try! JSONDecoder().decode(Entity.self, from: currentEntityData)
            if savedEntity == self.entity {
                let encodedEntity = try? JSONEncoder().encode(self.entity)
                defaults.set(encodedEntity, forKey: "CurrentEntity")
            }
        }
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("EditMeetingGroupInteractor: saveMeetingGroupToEntity: error: Document directory not found")
            return
        }
        let docFileURL = docDirectory.appendingPathComponent((entity?.id?.uuidString)! + ".ent")
        let entityDoc = EntityDocument(fileURL: docFileURL)
        entityDoc.open(completionHandler: { success in
            if !success {
                print("EditMeetingGroupInteractor: saveMeetingGroupToEntity: error opening EntityDocument")
            }
            else {
                
                if entityDoc.entity!.meetingGroups == nil {
                    entityDoc.entity!.meetingGroups = [MeetingGroup]()
                }
                if let idx = self.entity!.meetingGroups?.firstIndex(where: {$0.id == meetingGroup.id}) {
                    entityDoc.entity?.meetingGroups![idx] = self.meetingGroup!
                }
                entityDoc.updateChangeCount(.done)
                entityDoc.close(completionHandler: { success in
                    print(entityDoc)
                    callback()
                })
            }
        })
    }
    
    
    func fetchMembers(request: EditMeetingGroup.MeetingGroup.Request) {
        meetingGroup?.members = members
        let response = EditMeetingGroup.MeetingGroup.Response(members: self.members)
        self.presenter?.presentMembers(response: response)
    }
    
    
    // MARK: - Datastore
    
    func getMeetingGroup() -> MeetingGroup? {
        return self.meetingGroup
    }
    
    func addMeetingGroupToBeDeletedToDataStore(meetingGroup: MeetingGroup){
        self.meetingGroup = meetingGroup
    }
}

