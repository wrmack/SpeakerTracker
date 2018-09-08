//
//  DisplayEventsInteractor.swift
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

protocol DisplayEventsBusinessLogic {
    func doSomething(request: DisplayEvents.Something.Request)
}

protocol DisplayEventsDataStore {
  //var name: String { get set }
}

class DisplayEventsInteractor: DisplayEventsBusinessLogic, DisplayEventsDataStore {
    var presenter: DisplayEventsPresentationLogic?
    var worker: DisplayEventsWorker?
    //var name: String = ""

    // MARK: Do something

    func doSomething(request: DisplayEvents.Something.Request) {
    worker = DisplayEventsWorker()
    worker?.doSomeWork()

    let response = DisplayEvents.Something.Response()
    presenter?.presentSomething(response: response)
}
}
