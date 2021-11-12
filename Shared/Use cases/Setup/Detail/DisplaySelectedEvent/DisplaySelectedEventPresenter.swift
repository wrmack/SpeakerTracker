//
//  DisplaySelectedEventPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 16/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation


struct EventViewModelRecord: Hashable {
    var label: String
    var value: String
}



class DisplaySelectedEventPresenter: ObservableObject {

    @Published var eventViewModel = [EventViewModelRecord]()
    
    init() {
        print("++++++ DisplaySelectedEventPresenter initialized")
    }
    
    deinit {
        print("++++++ DisplaySelectedEventPresenter de-initialized")
    }
    
    func presentMeetingEventDetail(event: MeetingEvent?, entityName: String?, meetingGroupName: String?) {
        var tempArray = [EventViewModelRecord]()
        if event != nil {
            // Date and time
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            let timeString = formatter.string(from: event!.date!)
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            let dateString = formatter.string(from: event!.date!)
            

            tempArray.append(EventViewModelRecord(label: "Entity", value: entityName!))
            tempArray.append(EventViewModelRecord(label: "Meeting group", value: meetingGroupName!))
//            tempArray.append(EventViewModelRecord(label: "Members", value: memberString ?? ""))
            tempArray.append(EventViewModelRecord(label: "Date", value: dateString))
            tempArray.append(EventViewModelRecord(label: "Time", value: timeString))
            tempArray.append(EventViewModelRecord(label: "Note", value: (event!.note ?? "")))
            
        }
        eventViewModel = tempArray
    }
}
