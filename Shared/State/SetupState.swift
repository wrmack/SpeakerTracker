//
//  SetupState.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 12/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine

/**
 An Observable Object which holds state for the use-cases in setup.
 - injected by scene delegate as an environment object
 - publishes total number of rows (will change if user adds or deletes an item)
 - publishes whether master has been set up (so detail view can do its thiing)
 - publishes whether an item was edited
 - publishes the selected entity
 - publishes the selected meeting group
 - publishes meeting group members
 - stores sorted entities
 - stores sorted members
 - stores sorted meeting groups
 - stores sorted events
 - stores whether entities detail view is setup
 - stores whether members detail view is setup
 - stores whether meeting groups detail view is setup
 - stores whether events detail view is setup
 */

class SetupState: ObservableObject {
//   @Published var selectedSetupTab = 0
//    @Published var selectedRow = 0
    @Published var numberOfRows = 0
    @Published var membersMasterIsSetup = false
    @Published var meetingGroupsMasterIsSetup = false
    @Published var eventsMasterIsSetup = false
    @Published var itemWasEdited = false
    
    
//    // Manually published for debugging purposes
//    let objectWillChange = PassthroughSubject<Entity,Never>()
//    // TODO: save to defaults at same time.  Not used at the moment.
//    var selectedEntity: Entity? {
//        willSet {
//            print("++++++ SetupState selectedEntity set")
//            UserDefaultsManager.saveCurrentEntity(entity: newValue!)
//            objectWillChange.send(newValue!)
//        }
//    }
//    @Published var selectedMeetingGroup: MeetingGroup?
//    @Published var meetingGroupMembers: Set<Member>?
    
    
//    var sortedEntities: [Entity]?
//    var sortedMembers: [Member]?
//    var sortedMeetingGroups: [MeetingGroup]?
    var sortedEvents: [Event]?

    var membersDetailIsSetup = false
    var meetingGroupsDetailIsSetup = false
    var eventsDetailIsSetup = false
    

    
    init(){
        print("++++++ SetupState: initialized")
    }
    
    deinit {
        print("++++++ SetupState: de-initialized")
    }
}
