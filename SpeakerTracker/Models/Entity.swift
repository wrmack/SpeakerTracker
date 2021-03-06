//
//  Entity.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 1/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import Foundation

/*
 Entity: such as a council, company, society
 */
struct Entity: Codable {
    let name: String?
    var members: [Member]?
    var meetingGroups: [MeetingGroup]?
    var id: UUID?
    
    init(name: String?, members: [Member]?, meetingGroups: [MeetingGroup]?, id: UUID? ) {
        self.name = name
        self.members = members
        self.meetingGroups = meetingGroups
        self.id = id
    }
}


extension Entity: Equatable {
    static func == (lhs: Entity, rhs: Entity) -> Bool {
        if lhs.id != nil && rhs.id != nil {
            return lhs.id == rhs.id
        }
        return lhs.name == rhs.name
    }
}
