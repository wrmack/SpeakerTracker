//
//  Event.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 1/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import Foundation


struct Event: Codable  {
    let date: Date?
    let entity: Entity?
    let subEntity: SubEntity?
    let members: [Member]?
    let debates: [Debate]?
    let id: UUID?
    
    init(date: Date?, entity: Entity?, subEntity: SubEntity?, members: [Member]?, debates: [Debate]?, id: UUID?) {
        self.date = date
        self.entity = entity
        self.subEntity = subEntity
        self.members = members
        self.debates = debates
        self.id = id
    }
}


struct Debate: Codable {
    let reference: String?
    let speakerEvents: [(SpeakerEvent)]?
    
    init(reference: String?, speakerEvents: [(SpeakerEvent)]?) {
        self.reference = reference
        self.speakerEvents = speakerEvents
    }
}


struct SpeakerEvent: Codable {
    let member: Member?
    let elapsedMinutes: Int?
    let elapsedSeconds: Int?
    let startTime: Date?
    
    init(member: Member?, elapsedMinutes: Int?, elapsedSeconds: Int?, startTime: Date?) {
        self.member = member
        self.elapsedMinutes = elapsedMinutes
        self.elapsedSeconds = elapsedSeconds
        self.startTime = startTime
    }
}
