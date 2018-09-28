//
//  Event.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 1/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import Foundation


struct Event: Codable  {
    var filename: String?
    var date: Date?
    var entity: Entity?
    var meetingGroup: MeetingGroup?
    var note: String?
    var debates: [Debate]?
    let id: UUID?
    
    init(date: Date?, entity: Entity?, meetingGroup: MeetingGroup?, note: String?, debates: [Debate]?, id: UUID?, filename: String?) {
        self.date = date
        self.entity = entity
        self.meetingGroup = meetingGroup
        self.note = note
        self.debates = debates
        self.id = id
        self.filename = filename
    }
}


struct Debate: Codable {
    let reference: String?
    var speakerEvents: [(SpeakerEvent)]?
    
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
