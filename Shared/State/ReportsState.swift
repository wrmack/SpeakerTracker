//
//  ReportsState.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 24/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation

/// Holds state associated with the display of meeting event reports
///
class ReportsState : ObservableObject {
    var events: [MeetingEvent]?
    var selectedEvent: MeetingEvent?
    var eventIndexes: [UUID]?
    
    
    init() {
        print("++++++ ReportsState initialised")
    }
    
    deinit {
        print("++++++ ReportsState initialised")
    }
}
