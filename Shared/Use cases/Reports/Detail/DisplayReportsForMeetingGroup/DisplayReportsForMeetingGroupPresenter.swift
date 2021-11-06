//
//  DisplayReportsForMeetingGroupPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 24/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation

struct ReportCover : Hashable {
    var entityName = ""
    var meetingGroupName = ""
    var eventTime = ""
    var eventDate = ""
    var eventID = 0
}

class DisplayReportsForMeetingGroupPresenter : ObservableObject {
    @Published var reportCovers = [ReportCover]()
    
    func presentEventReports(events: [MeetingEvent]) {
        let savedEvents = events
        var tempReportCovers = [ReportCover]()
        var idx = 0
        savedEvents.forEach({ event in
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            let dateStrg = formatter.string(from: event.date!)
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            let timeStrg = formatter.string(from: event.date!)
            let entityName = event.meetingOfGroup!.groupOfEntity!.name!
            let rpt = ReportCover(entityName: entityName, meetingGroupName: event.meetingOfGroup!.name!, eventTime: timeStrg, eventDate: dateStrg, eventID: idx)
            tempReportCovers.append(rpt)
            idx += 1
        })
        reportCovers = tempReportCovers

    }
}
