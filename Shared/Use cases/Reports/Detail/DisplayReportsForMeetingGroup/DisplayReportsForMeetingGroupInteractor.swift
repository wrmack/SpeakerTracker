//
//  DisplayReportsForMeetingGroupInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 24/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation


//class DisplayReportsForMeetingGroupInteractor {
//    
//    func fetchEvents(reportsState: ReportsState, presenter: DisplayReportsForMeetingGroupPresenter) {
//        var events = [Event]()
//        let fileManager = FileManager.default
//        guard let docDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            print("DisplayReportsForMeetingGroupInteractor: fetchEvents: error: Document directory not found")
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
////                self.appState!.events = self.events!
////                self.setupState!.sortedEvents = self.events
////                self.setupState!.eventsMasterIsSetup = false
////                self.presenter.presentEventSummaries(events: self.events!)
////                self.setupState!.selectedRow = 0
//            }
//            else {
//                for eventUrl in eventUrls {
//                    let eventDoc = EventDocument(fileURL: eventUrl)
//                    eventDoc.open(completionHandler: { success in
//                        if !success {
//                            print("DisplayReportsForMeetingGroupInteractor: fetchEvents: error opening EventDocument")
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
////                                    self.appState!.events = self.events!
////                                    self.setupState!.sortedEvents = self.events
////                                    self.setupState!.eventsMasterIsSetup = true
//                                    reportsState.events = events
//                                    presenter.presentEventReports(events: events)
////                                    self.setupState!.selectedRow = 0
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
//}
