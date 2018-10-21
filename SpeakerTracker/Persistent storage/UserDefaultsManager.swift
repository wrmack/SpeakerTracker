//
//  UserDefaultsManager.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 1/10/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import Foundation

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

    static func getCurrentMeetingGroup()->MeetingGroup? {
        let defaults = UserDefaults.standard
        if let currentMeetingGroupData = defaults.data(forKey: "CurrentMeetingGroup") {
            let meetingGroup = try! JSONDecoder().decode(MeetingGroup.self, from: currentMeetingGroupData)
            return meetingGroup
        }
        return nil
    }
}
