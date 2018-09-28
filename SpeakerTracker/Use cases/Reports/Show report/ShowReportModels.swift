//
//  ShowReportModels.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 27/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum ShowReport {
  // MARK: Use cases
  
    enum Report {
        struct Request {
        }
        struct Response {
            var event: Event?
        }
        struct ViewModel {
            var attText: NSMutableAttributedString?
        }
    }
}
