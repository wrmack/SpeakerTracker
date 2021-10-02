//
//  ShowReportPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 24/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation


struct ReportContent {
    var entityName = ""
    var meetingGroupName = ""
    var dateTime = ""
    var membersString = ""
    var reportDebates = [ReportDebate]()
}

struct ReportDebate: Hashable {
    var reportDebateNumber = ""
    var reportNote = ""
    var reportDebateSections = [ReportDebateSection]()

}

struct ReportDebateSection: Hashable {
    var sectionName = ""
    var reportSpeakerEvents = [ReportSpeakerEvent]()
}

struct ReportSpeakerEvent: Hashable {
    var memberName = ""
    var elapsedTime = ""
    var startTime = ""
}

//class ShowReportPresenter :ObservableObject {
//    
//    @Published var reportContent = ReportContent()
//    @Published var reportAttributedString: NSMutableAttributedString?
//    
//    func presentReport(event: Event) {
//        var tempRpt = ReportContent()
//        
//        // Entity
//        tempRpt.entityName = event.entity!.name!
//        
//        // Meeting group
//        tempRpt.meetingGroupName = event.meetingGroup!.name!
//        
//        // Time and date
//        let formatter = DateFormatter()
//        formatter.dateStyle = .long
//        formatter.timeStyle = .none
//        let dateStrg = formatter.string(from: event.date!)
//        formatter.dateStyle = .none
//        formatter.timeStyle = .short
//        let timeStrg = formatter.string(from: event.date!)
//        tempRpt.dateTime = timeStrg + ", " + dateStrg
//        
//        // Members
//        var membersString = ""
//        let memberids = event.meetingGroup!.memberIDs!
//        memberids.forEach { id in
//            event.entity!.members!.forEach { member in
//                if member.id == id {
//                    if (membersString.count > 0) {
//                        membersString.append(", ")
//                    }
//                    var fullTitle: String?
//                    if let title = member.title {
//                       fullTitle = title + " "
//                    }
//                    membersString.append((fullTitle ?? "") + (member.firstName ?? "") + " " + member.lastName!)
//                }
//            }
//        }
//        tempRpt.membersString = membersString
//
//        // Debates
//        if event.debates != nil {
//            var debates = [ReportDebate]()
//            // Debates
//            event.debates!.forEach { eventDebate in
//                var reportDebate = ReportDebate()
//                reportDebate.reportDebateNumber = String(eventDebate.debateNumber!)
//                reportDebate.reportNote = eventDebate.note ?? ""
//                var reportDebateSections = [ReportDebateSection]()
//                // Sections
//                eventDebate.debateSections!.forEach { eventSection  in
//                    var reportDebateSection = ReportDebateSection()
//                    reportDebateSection.sectionName = eventSection.sectionName!
//                    var reportSpeakerEvents = [ReportSpeakerEvent]()
//                    // Speaker events
//                    eventSection.speakerEvents!.forEach { speakerEvent in
//                        var reportSpeakerEvent = ReportSpeakerEvent()
//                        reportSpeakerEvent.memberName = speakerEvent.member!.lastName!
//                        reportSpeakerEvent.elapsedTime = String(format: "%02d:%02d", speakerEvent.elapsedMinutes!, speakerEvent.elapsedSeconds!)
//                        reportSpeakerEvent.startTime = "llll"
//                        reportSpeakerEvents.append(reportSpeakerEvent)
//                    }
//                    reportDebateSection.reportSpeakerEvents = reportSpeakerEvents
//                    reportDebateSections.append(reportDebateSection)
//                }
//                reportDebate.reportDebateSections = reportDebateSections
//                debates.append(reportDebate)
//            }
//            tempRpt.reportDebates = debates
//        }
//        
//        reportContent = tempRpt
//    }
//    
//    func convertReportContentToAttributedString() {
//        let reportContent = self.reportContent
//        let attString = NSMutableAttributedString()
//        
//        // Convenience properties
//        var normalAtts = FontStyle().normal
//        normalAtts[NSAttributedString.Key.paragraphStyle] = ParaStyle().left
//        
//        var boldAtts = FontStyle().normalBold
//        boldAtts[NSAttributedString.Key.paragraphStyle] = ParaStyle().leftWithSpacingBefore
//        
//        var italicAtts = FontStyle().normalItalic
//        italicAtts[NSAttributedString.Key.paragraphStyle] = ParaStyle().leftWithSpacingAfter
//        
//        // Entity
//        var atts = FontStyle().heading1
//        atts[NSAttributedString.Key.paragraphStyle] = ParaStyle().centered
//        let entityAttStrg = NSAttributedString(string: "\n" + (reportContent.entityName + "\n"), attributes: atts)
//        attString.append(entityAttStrg)
//        
//        // Meeting group
//        atts = FontStyle().heading2
//        atts[NSAttributedString.Key.paragraphStyle] = ParaStyle().centeredWithSpacingBeforeAfter
//        let meetingGroupAttStrg = NSAttributedString(string: reportContent.meetingGroupName + "\n", attributes: atts)
//        attString.append(meetingGroupAttStrg)
//        
//        // Time and date
//        atts = FontStyle().heading3
//        atts[NSAttributedString.Key.paragraphStyle] = ParaStyle().centered
//        let dateAttStrg = NSAttributedString(string: reportContent.dateTime + "\n", attributes: atts)
//        attString.append(dateAttStrg)
//        
//        // Members
//        attString.append(NSAttributedString(string:  "Members:\n", attributes: boldAtts))
//        
//        let membersAttStrg = NSAttributedString(string: reportContent.membersString + "\n\n", attributes: normalAtts)
//        attString.append(membersAttStrg)
//        attString.append(NSAttributedString(string:  "\tDuration\tStart-time\n", attributes: boldAtts))
//        
//        // Debates
//        atts = normalAtts
//
//        if reportContent.reportDebates.count > 0 {
//            for debate in reportContent.reportDebates {
//                (boldAtts[NSAttributedString.Key.paragraphStyle] as! NSMutableParagraphStyle).firstLineHeadIndent = 0
//                let debateNumberAttStg = NSAttributedString(string: "\nDebate " +  String(debate.reportDebateNumber) + "\n", attributes: boldAtts)
//                attString.append(debateNumberAttStg)
//                let note = debate.reportNote
//                let refAttStg = NSAttributedString(string: note + "\n", attributes: italicAtts)
//                attString.append(refAttStg)
//                for debateSection in debate.reportDebateSections {
//                    var debateSectionNameAtts = FontStyle().normalBold
//                    debateSectionNameAtts[NSAttributedString.Key.paragraphStyle] = ParaStyle().leftWithSpacingBefore
//                    (debateSectionNameAtts[NSAttributedString.Key.paragraphStyle] as! NSMutableParagraphStyle).firstLineHeadIndent = 20
//                    let debateSectionNameAttStg = NSAttributedString(string: debateSection.sectionName + "\n", attributes: debateSectionNameAtts)
//                    attString.append(debateSectionNameAttStg)
//                    var spkrEvtStrg = String()
//                    for speakerEvt in debateSection.reportSpeakerEvents {
//                        spkrEvtStrg.append(speakerEvt.memberName + "\t" + speakerEvt.elapsedTime + "\t" + speakerEvt.startTime + "\n")
//                    }
//                    var spkrAtts = FontStyle().normal
//                    spkrAtts[NSAttributedString.Key.paragraphStyle] = ParaStyle().left
//                    (spkrAtts[NSAttributedString.Key.paragraphStyle] as! NSMutableParagraphStyle).firstLineHeadIndent = 20
//                    let spkrEvtAttStr = NSAttributedString(string: spkrEvtStrg, attributes: spkrAtts)
//                    attString.append(spkrEvtAttStr)
//                }
//            }
//        }
//        
//        attString.fixAttributes(in: NSRange(location: 0, length: attString.length))
//        self.reportAttributedString = attString
//    }
//    
//}
