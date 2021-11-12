//
//  DeleteEventPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 30/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation

struct DeleteEventViewModel {
    var eventDate = Date()
    var eventTime = Date()
}

class DeleteEventPresenter : ObservableObject {
    
    @Published var viewModel = DeleteEventViewModel()
    
    func presentViewModel(selectedEvent: MeetingEvent) {
        print("Here")
        let tempModel = DeleteEventViewModel(
            eventDate: selectedEvent.date!,
            eventTime: selectedEvent.date!
        )
        viewModel = tempModel
    }
}
