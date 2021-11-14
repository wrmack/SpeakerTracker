//
//  Event_OldManager.swift
//  Speaker-tracker-multi (iOS)
//
//  Created by Warwick McNaughton on 13/11/21.
//

import UIKit

struct Event_Old: Codable  {
    var filename: String?
    var date: Date?
    var entity: Entity_Old?
    var meetingGroup: MeetingGroup_Old?
    var note: String?
    var debates: [Debate_Old]?
    var meetingGroupStatus: MeetingGroupStatus?
    let id: UUID?
    
    init(date: Date?, entity: Entity_Old?, meetingGroup: MeetingGroup_Old?, note: String?, debates: [Debate_Old]?, id: UUID?, filename: String?) {
        self.date = date
        self.entity = entity
        self.meetingGroup = meetingGroup
        self.note = note
        self.debates = debates
        self.id = id
        self.filename = filename
    }
}


struct Debate_Old: Codable {
    var debateNumber: Int?
    var note: String?
    var debateSections: [(DebateSection_Old)]?
    init(debateNumber: Int?, note: String?, debateSections: [(DebateSection_Old)]?) {
        self.debateNumber = debateNumber
        self.note = note
        self.debateSections = debateSections
    }
}

struct DebateSection_Old: Codable {
    var sectionNumber: Int?
    var sectionName: String?
    var speakerEvents: [(SpeakerEvent_Old)]?
    init(sectionNumber: Int?, sectionName: String?, speakerEvents: [(SpeakerEvent_Old)]?) {
        self.sectionNumber = sectionNumber
        self.sectionName = sectionName
        self.speakerEvents = speakerEvents
    }
}

struct SpeakerEvent_Old: Codable {
    let member: Member_Old?
    let elapsedMinutes: Int?
    let elapsedSeconds: Int?
    let startTime: Date?
    
    init(member: Member_Old?, elapsedMinutes: Int?, elapsedSeconds: Int?, startTime: Date?) {
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


struct Event_OldManager {
    
    
    static func fetchEvents(callback: @escaping ([Event_Old])->()) {
        var events = [Event_Old]()
        let fileManager = FileManager.default
        guard let docDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Event_OldManager: fetchEvents: error: Document directory not found")
            return
        }
        do {
            var eventUrls = [URL]()
            let fileURLs = try fileManager.contentsOfDirectory(at: docDirectory, includingPropertiesForKeys: nil)
            for url in fileURLs {
                if url.pathExtension == "evt" {
                    eventUrls.append(url)
                }
            }
            
            if eventUrls.count == 0 {
                print("No urls found for event documents")
                return
            }
            else {
                for eventUrl in eventUrls {
                    let eventDoc = EventDocument(fileURL: eventUrl)
                    eventDoc.open(completionHandler: { success in
                        if !success {
                            print("Event_OldManager: fetchEvents: error opening EventDocument")
                            return
                        }
                        else {                            
                            eventDoc.close(completionHandler: {success in
                                guard let event = eventDoc.event else {
                                    print("Event_OldManager: fetchEvents: entity is nil")
                                    return
                                }
                                events.append(event)
                                if events.count == eventUrls.count {
                                    callback(events)
                                }
                            })
                        }
                    })
                }
            }
            
        }
        catch {
            print("Error while enumerating files \(docDirectory.path): \(error.localizedDescription)")
        }
    
    }
}
