//
//  AddNoteToDebateRouter.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 3/11/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol AddNoteToDebateRoutingLogic {
    func returnToTrackSpeakersVC()
}

protocol AddNoteToDebateDataPassing {
    var dataStore: AddNoteToDebateDataStore? { get }
}

class AddNoteToDebateRouter: NSObject, AddNoteToDebateRoutingLogic, AddNoteToDebateDataPassing {
    weak var viewController: AddNoteToDebateViewController?
    var dataStore: AddNoteToDebateDataStore?
  
  // MARK: Routing
  
    func returnToTrackSpeakersVC() {
        viewController!.sourceVC!.router!.returnFromAddNoteToDebate()
    }
    
    

  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: AddNoteToDebateDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}