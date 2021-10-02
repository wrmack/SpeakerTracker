//
//  DisplayEventsInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 15/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation


class DisplayEventsInteractor {

    init() {
        print("DisplayEventsInteractor initialized")
    }
    
    deinit {
        print("DisplayEventsInteractor de-initialized")
    }
    
    
//    func fetchEvents(presenter: DisplayEventsPresenter, eventState: EventState, entityState: EntityState, setupState: SetupState) {
//        let eventState = eventState
//        let entityState = entityState
//        let setupState = setupState
////        var events = [Event]()
//        let fileManager = FileManager.default
//        guard let docDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            print("DisplayEventsInteractor: fetchEvents: error: Document directory not found")
//            return
//        }
//        do {
//            var eventUrls = [URL]()
//            let fileURLs = try fileManager.contentsOfDirectory(at: docDirectory, includingPropertiesForKeys: nil)
//            for url in fileURLs {
//                if url.pathExtension == "evt" {
//                    eventUrls.append(url)
//                }
//            }
//            if eventUrls.count == 0 {
//                print("count == 0")
//                eventState.events = events
//                setupState.sortedEvents = events
//                setupState.eventsMasterIsSetup = false
//                presenter.presentEventSummaries(events: events)
////                setupState.selectedRow = 0
//            }
//            else {
//                for eventUrl in eventUrls {
//                    let eventDoc = EventDocument(fileURL: eventUrl)
//                    eventDoc.open(completionHandler: { success in
//                        if !success {
//                            print("DisplayEventsInteractor: fetchEvents: error opening EventDocument")
//                        }
//                        else {
//                            eventDoc.close(completionHandler: { success in
//                                guard let event = eventDoc.event else {
//                                    print("DisplayEventsInteractor: fetchEvents: event is nil")
//                                    return
//                                }
//                                events.append(event)
//                                if events.count == eventUrls.count {
////                                    self.events!.sort(by: {
////                                        if $0.name! < $1.name! {
////                                            return true
////                                        }
////                                        return false
////                                    })
//                                    eventState.events = events
//                                    setupState.sortedEvents = events
//                                    setupState.eventsMasterIsSetup = true
//                                    var eventsForMeetingGroup = [Event]()
//                                    events.forEach({ event in
//                                        if entityState.currentMeetingGroup != nil {
//                                            if event.meetingGroup!.id == entityState.currentMeetingGroup!.id {
//                                                eventsForMeetingGroup.append(event)
//                                            }
//                                        }
//                                    })
//                                    presenter.presentEventSummaries(events: eventsForMeetingGroup)
////                                    setupState.selectedRow = 0
//                                }
//                            })
//                        }
//                    })
//                }
//            }
//        } catch {
//            print("Error while enumerating files \(docDirectory.path): \(error.localizedDescription)")
//        }
//    }
    
    func fetchMeetingGroupsForEntity(entity: Entity) {
        //       self.entity = entity
        //       fetchMeetingGroups()
    }
    
}
