//
//  DisplayReportsForMeetingGroupInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 24/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation


class DisplayReportsForMeetingGroupInteractor {
    
    static func fetchEvents(entityState: EntityState, reportsState: ReportsState, presenter: DisplayReportsForMeetingGroupPresenter, index: UUID?) {
        
        var meetingGroupIndex: UUID?
        
        if index == nil {
            if let currentMeetingGroupIndex = entityState.currentMeetingGroupIndex {
                meetingGroupIndex = currentMeetingGroupIndex
            }
            else {
//                presenter.presentEventReports(events: nil)
                return
            }
        }
        else {
            meetingGroupIndex = index
        }
        
        let events = EventState.sortedMeetingEvents(meetingGroupIndex: meetingGroupIndex!)
        reportsState.events = events
        
        var eventIndexes = [UUID]()
        events?.forEach({ event in
            eventIndexes.append(event.idx!)
        })
        reportsState.eventIndexes = eventIndexes
        
        presenter.presentEventReports(events: events!)
    }
}
