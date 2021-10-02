//
//  ReportsState.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 24/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation


class ReportsState : ObservableObject {
    var events: [Event]?
    var selectedEvent: Event?
    
    init() {
        print("++++++ ReportsState initialised")
    }
    
    deinit {
        print("++++++ ReportsState initialised")
    }
}
