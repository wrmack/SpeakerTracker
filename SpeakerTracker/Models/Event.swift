//
//  Event.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 1/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import Foundation

/*
 Event: such as a meeting
 Debate: one debate comprises sections such as main debate, amendment debate
 DebateSection: comprises speaker events (speeches)
 SpeakerEvent: a speech
 */


struct Event: Codable  {
    var filename: String?
    var date: Date?
    var entity: Entity?
    var meetingGroup: MeetingGroup?
    var note: String?
    var debates: [Debate]?
    var meetingGroupStatus: MeetingGroupStatus?
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
    var debateNumber: Int?
    var note: String?
    var debateSections: [(DebateSection)]?
    init(debateNumber: Int?, note: String?, debateSections: [(DebateSection)]?) {
        self.debateNumber = debateNumber
        self.note = note
        self.debateSections = debateSections
    }
}

struct DebateSection: Codable {
    var sectionNumber: Int?
    var sectionName: String?
    var speakerEvents: [(SpeakerEvent)]?
    init(sectionNumber: Int?, sectionName: String?, speakerEvents: [(SpeakerEvent)]?) {
        self.sectionNumber = sectionNumber
        self.sectionName = sectionName
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

enum MeetingGroupStatus: String, Codable {
    case current
    case previous
}
