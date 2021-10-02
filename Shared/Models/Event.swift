//
//  Event.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 1/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import Foundation

/*
 An event such as a meeting, comprises
 debates which comprise
 sections (such as main debate, amendment debate) which comprise
 speaker events (speeches).
 */


struct Event: Codable  {
    var filename: String?
    var date: Date?
    var entity: Entity?
    var meetingGroup: MeetingGroup?
    var note: String?
    var debates: [Debate]?
    var meetingGroupStatus: MeetingGroupStatus?
    var id = UUID()
    
    init(date: Date?, entity: Entity?, meetingGroup: MeetingGroup?, note: String?, debates: [Debate]?, filename: String?) {
        self.date = date
        self.entity = entity
        self.meetingGroup = meetingGroup
        self.note = note
        self.debates = debates
        self.filename = filename
    }
}

/**
 A debate on a motion.
 
 It may include a number of sections corresponding to:
 - main debate
 - amendment
 */
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


/// A section of a debate (for example main debate, amendment 1)
///
/// Includes an array of speaker events (each speech comprising the member and timing data).
struct DebateSection: Codable {
    var sectionNumber: Int?
    var sectionName: String?
    var speakerEvents: [(SpeakerEvent)]?
    
    /// DebateSection initialisation
    /// 
    /// - Parameters:
    ///   - sectionNumber: An integer. In a debate, section 0 will be the main debate, section 1 will be first amendment etc
    ///   - sectionName: Such as "Main debate", "Amendment 1"
    ///   - speakerEvents: An array of speaker events.  A SpeakerEvent is a single speech with member and timing data.
    
    init(sectionNumber: Int?, sectionName: String?, speakerEvents: [(SpeakerEvent)]?) {
        self.sectionNumber = sectionNumber
        self.sectionName = sectionName
        self.speakerEvents = speakerEvents
    }
}

/// A speech.
///
/// Includes properties for the member speaking and timing data.
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
    case deleted
}
