//
//  UserDefaultsManager.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 1/10/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import Foundation



/*
 This class provides utilities for saving and retrieving the current entity or current meeting group.
 When a user selects an entity it is stored as the current entity.
 The current entity is retrieved as the default entity whenever the user is required to select an entity.
 */
class UserDefaultsManager {
    
    static func saveCurrentEntity(entity: Entity) {
        let defaults = UserDefaults.standard
        let encodedEntity = try? JSONEncoder().encode(entity)
        defaults.set(encodedEntity, forKey: "CurrentEntity")
    }
    
    
    static func getCurrentEntity()->Entity? {
        let defaults = UserDefaults.standard
        if let currentEntityData = defaults.data(forKey: "CurrentEntity") {
            let entity = try! JSONDecoder().decode(Entity.self, from: currentEntityData)
            return entity
        }
        return nil
    }
    
    
    static func removeCurrentEntity() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "CurrentEntity")
    }

    
    static func saveCurrentMeetingGroup(meetingGroup: MeetingGroup) {
        let defaults = UserDefaults.standard
        let encodedEntity = try? JSONEncoder().encode(meetingGroup)
        defaults.set(encodedEntity, forKey: "CurrentMeetingGroup")
    }
    
    
    static func getCurrentMeetingGroup()->MeetingGroup? {
        let defaults = UserDefaults.standard
        if let currentMeetingGroupData = defaults.data(forKey: "CurrentMeetingGroup") {
            var meetingGroup = try! JSONDecoder().decode(MeetingGroup.self, from: currentMeetingGroupData)
            if meetingGroup.memberIDs == nil {
                meetingGroup.memberIDs = [UUID]()
            }
            return meetingGroup
        }
        return nil
    }
    
    
    
}
