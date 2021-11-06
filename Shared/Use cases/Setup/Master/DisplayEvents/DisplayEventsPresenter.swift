//
//  DisplayEventsPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 15/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation

struct EventSummaryViewModel: Hashable {
    var summary: String
    var idx: UUID
}

class DisplayEventsPresenter : ObservableObject {
    @Published var eventSummaries = [EventSummaryViewModel]()
    
    func presentEventSummaries(events: [MeetingEvent]?) {
//        var tempMeetingEvents = events
//        tempMeetingEvents?.sort(by: {
//            if $0.name! < $1.name! { return true }
//            return false
//        })
        
        var tempMeetingEventVMs = [EventSummaryViewModel]()
        if events != nil {
            events!.forEach({ event in
               let formatter = DateFormatter()
               formatter.dateStyle = .none
               formatter.timeStyle = .short
               let timeString = formatter.string(from: event.date!)
               formatter.dateStyle = .long
               formatter.timeStyle = .none
               let dateString = formatter.string(from: event.date!)
               let timeDateString = timeString + ", " + dateString
                let evSum = EventSummaryViewModel(summary: timeDateString, idx: event.idx!)
                tempMeetingEventVMs.append(evSum)
           })

        }

        eventSummaries = tempMeetingEventVMs
    }
}
