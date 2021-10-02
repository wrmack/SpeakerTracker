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



//class DisplaySelectedEventPresenter: ObservableObject {
//    @Published var presenterUp = true
//    @Published var eventViewModel = [EventViewModelRecord]()
//    
//    init() {
//        print("DisplaySelectedEventPresenter initialized")
//    }
//    
//    deinit {
//        print("DisplaySelectedEventPresenter de-initialized")
//    }
//    
//    func presentEventDetail(event: Event?, memberString: String?) {
//        var tempArray = [EventViewModelRecord]()
//        if event != nil {
//            // Date and time
//            let formatter = DateFormatter()
//            formatter.dateStyle = .none
//            formatter.timeStyle = .short
//            let timeString = formatter.string(from: event!.date!)
//            formatter.dateStyle = .long
//            formatter.timeStyle = .none
//            let dateString = formatter.string(from: event!.date!)
//            
//
//            tempArray.append(EventViewModelRecord(label: "Entity", value: (event!.entity?.name)!))
//            tempArray.append(EventViewModelRecord(label: "Meeting group", value: (event!.meetingGroup?.name)!))
//            tempArray.append(EventViewModelRecord(label: "Members", value: memberString ?? ""))
//            tempArray.append(EventViewModelRecord(label: "Date", value: dateString))
//            tempArray.append(EventViewModelRecord(label: "Time", value: timeString))
//            tempArray.append(EventViewModelRecord(label: "Note", value: (event!.note ?? "")))
//            
//        }
//        eventViewModel = tempArray
//    }
//}
