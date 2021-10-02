//
//  DisplayEventsPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 15/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation

struct EventSummary: Hashable {
    var summary: String
    var idx: Int
}

//class DisplayEventsPresenter : ObservableObject {
//    @Published var eventSummaries = [EventSummary]()
//    
//    func presentEventSummaries(events: [Event]) {
//        let savedEvents = events
//        var tempSummaries = [EventSummary]()
//        var idx = 0
//        savedEvents.forEach({ event in
//            let formatter = DateFormatter()
//            formatter.dateStyle = .none
//            formatter.timeStyle = .short
//            let timeString = formatter.string(from: event.date!)
//            formatter.dateStyle = .long
//            formatter.timeStyle = .none
//            let dateString = formatter.string(from: event.date!)
//            let timeDateString = timeString + ", " + dateString
//            let evSum = EventSummary(summary: timeDateString, idx: idx)
//            tempSummaries.append(evSum)
//            idx += 1
//        })
//        eventSummaries = tempSummaries
//    }
//}
