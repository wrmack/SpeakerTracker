//
//  DeleteEventPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 30/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation

struct DeleteEventViewModel {
    var entityName = ""
    var meetingGroupName = ""
    var eventDateString = ""
}

class DeleteEventPresenter : ObservableObject {
    
    @Published var viewModel = DeleteEventViewModel()
//    
//    func presentViewModel(selectedEvent: Event) {
//        
//        // Date and time
//        let formatter = DateFormatter()
//        formatter.dateStyle = .none
//        formatter.timeStyle = .short
//        let timeString = formatter.string(from: selectedEvent.date!)
//        formatter.dateStyle = .long
//        formatter.timeStyle = .none
//        let dateString = formatter.string(from: selectedEvent.date!)
//        let timeDateString = timeString + " " + dateString
//        
//        let tempModel = DeleteEventViewModel(
//            entityName: selectedEvent.entity!.name!,
//            meetingGroupName: selectedEvent.meetingGroup!.name!,
//            eventDateString: timeDateString
//        )
//        viewModel = tempModel
//    }
//    
}
