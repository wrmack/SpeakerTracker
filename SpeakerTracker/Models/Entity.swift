//
//  Entity.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 1/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import Foundation

enum EntityType: Int, Codable {
    case topLevelParent = 1
    case subordinate = 2
}


struct Entity: Codable {
    let name: String?
    let type: EntityType?
    var members: [Member]?
    var additionalMembers: [Member]?
    var subEntities: [SubEntity]?
    var fileName: String?
    
    init(name: String?, type: EntityType?, members: [Member]?, additionalMembers: [Member]?, subEntities: [SubEntity]?, fileName: String? ) {
        self.name = name
        self.type = type
        self.members = members
        self.additionalMembers = additionalMembers
        self.subEntities = subEntities
    }
}
