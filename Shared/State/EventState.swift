//
//  EventState.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 17/07/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine

/*
 An Environment Object
 
 */

class EventState : ObservableObject {
    
    var events = [Event]() {
        didSet {
            print("++++++ AppState: [Event] set for \(events.count) events")
        }
    }
    
    init() {
        print("++++++ AppState intialized")
    }
    
    deinit {
        print("++++++ AppState de-initialized")
    }
}
