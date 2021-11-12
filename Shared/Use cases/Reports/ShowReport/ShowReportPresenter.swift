//
//  ShowReportPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 24/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation
import SwiftUI


struct ReportContent {
    var entityName = ""
    var meetingGroupName = ""
    var dateTime = ""
    var membersString = ""
    var reportDebates = [ReportDebate]()
}

struct ReportDebate: Hashable {
    var reportDebateNumber = 0
    var reportNote = ""
    var reportDebateSections = [ReportDebateSection]()

}

struct ReportDebateSection: Hashable {
    var sectionName = ""
    var sectionNumber = 0
    var reportSpeakerEvents = [ReportSpeakerEvent]()
}

struct ReportSpeakerEvent: Hashable {
    var memberName = ""
    var elapsedTime = ""
    var startTime = ""
}

class ShowReportPresenter :ObservableObject {
    
    @Published var reportContent = ReportContent()
    @Published var reportAttributedString: NSMutableAttributedString?
    
    func presentReport(event: MeetingEvent) {
        var tempRpt = ReportContent()
        
        // Meeting group
        let meetingGroup = event.meetingOfGroup!
        tempRpt.meetingGroupName = meetingGroup.name!
        
        // Entity
        tempRpt.entityName = meetingGroup.groupOfEntity!.name!
        
        // Time and date
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        let dateStrg = formatter.string(from: event.date!)
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let timeStrg = formatter.string(from: event.date!)
        tempRpt.dateTime = timeStrg + ", " + dateStrg
        
        // Members
        var membersString = ""
        var members = meetingGroup.groupMembers?.allObjects as! [Member]
        members.sort(by: {
            if $0.lastName! < $1.lastName! { return true}
            return false
        })
        members.forEach { member in
            var gap = ""
            if membersString.count > 0 {gap = ", "}
            let str = gap + (member.title ?? "") + " " + (member.firstName ?? "") + " " + member.lastName!
            membersString.append(str)
        }
        tempRpt.membersString = membersString

        if event.debates != nil {
            
            // Debates
            var debates = [ReportDebate]()
            event.debates!.forEach { element in
                let eventDebate = element as! Debate
                var reportDebate = ReportDebate()
                reportDebate.reportDebateNumber = Int(eventDebate.debateNumber) + 1
                reportDebate.reportNote = eventDebate.note ?? ""
                
                // Debate sections
                var reportDebateSections = [ReportDebateSection]()
                eventDebate.debateSections!.forEach { element  in
                    let eventSection = element as! DebateSection
                    var reportDebateSection = ReportDebateSection()
                    reportDebateSection.sectionName = eventSection.sectionName!
                    reportDebateSection.sectionNumber = Int(eventSection.sectionNumber)
                    
                    // Speaker events
                    var reportSpeakerEvents = [ReportSpeakerEvent]()
                    var speechesArray = eventSection.speeches?.allObjects as! [SpeechEvent]
                    speechesArray.sort(by:{
                        if $0.startTime != nil && $1.startTime != nil && $0.startTime! < $1.startTime! {
                            return true
                        }
                        return false
                    })
                    speechesArray.forEach { element in
                        let speech = element
                        var reportSpeakerEvent = ReportSpeakerEvent()
                        reportSpeakerEvent.memberName = speech.member!.lastName!
                        reportSpeakerEvent.elapsedTime = String(format: "%02d:%02d", speech.elapsedMinutes, speech.elapsedSeconds)
                        if speech.startTime != nil {
                            reportSpeakerEvent.startTime = formatter.string(from: speech.startTime!)
                        }
                        else {reportSpeakerEvent.startTime = ""}
                        reportSpeakerEvents.append(reportSpeakerEvent)
                    }
                    reportDebateSection.reportSpeakerEvents = reportSpeakerEvents
                    reportDebateSections.append(reportDebateSection)
                }
                reportDebateSections.sort(by: {
                    if $0.sectionNumber < $1.sectionNumber {return true}
                    return false
                })
                reportDebate.reportDebateSections = reportDebateSections
                debates.append(reportDebate)
            }
            debates.sort(by: {
                if $0.reportDebateNumber < $1.reportDebateNumber {return true}
                return false
            })
            tempRpt.reportDebates = debates
        }
        reportContent = tempRpt
    }
    
}
