//
//  DisplayEventsPresenter.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 2/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DisplayEventsPresentationLogic {
    func presentEvents(response: DisplayEvents.Events.Response)
}

class DisplayEventsPresenter: DisplayEventsPresentationLogic {
    weak var viewController: DisplayEventsDisplayLogic?

    // MARK:- VIP

    func presentEvents(response: DisplayEvents.Events.Response) {
        var eventNames = [String]()
        for event in response.events! {
            let dateString = event.date?.description
            eventNames.append(dateString!)
        }
        
        let viewModel = DisplayEvents.Events.ViewModel(eventNames: eventNames)
        viewController?.displayEvents(viewModel: viewModel)
    }
}
