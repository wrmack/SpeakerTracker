//
//  DisplayEventsPopUpInteractor.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 15/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DisplayEventsPopUpBusinessLogic {
    func includeTodayInEvents()
    func fetchEvents(request: DisplayEventsPopUp.Events.Request)
    func setEntity(entity: Entity)
    func setMeetingGroup(meetingGroup: MeetingGroup)
}

protocol DisplayEventsPopUpDataStore {
}


class DisplayEventsPopUpInteractor: DisplayEventsPopUpBusinessLogic, DisplayEventsPopUpDataStore {
    var presenter: DisplayEventsPopUpPresentationLogic?
    var event: Event?
    var events: [Event]?
    var currentEntity: Entity?
    var currentMeetingGroup: MeetingGroup?
    var currentEvent: Event?
    var currentDebate: Debate?
    var currentMemberSpeaking: Member?
    
    
    func includeTodayInEvents() {
        if events == nil {
            events = [Event]()
            let id = UUID()
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd_hh-mm"
            let newDateString = df.string(from: Date())
            let event = Event(date: Date(), entity: currentEntity, meetingGroup: currentMeetingGroup, note: nil, debates: nil, id: id, filename: newDateString)
            events?.append(event)
        }
    }
    

    func fetchEvents(request: DisplayEventsPopUp.Events.Request) {
        if events == nil {
            events = [Event]()
        }
        let fileManager = FileManager.default
        guard let docDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("DisplayEventsPopUpInteractor: fetchEvents: error: Document directory not found")
            return
        }
        do {
            var eventUrls = [URL]()
            let fileURLs = try fileManager.contentsOfDirectory(at: docDirectory, includingPropertiesForKeys: nil)
            for url in fileURLs {
                if url.pathExtension == "evt" {
                    eventUrls.append(url)
                }
            }
            if eventUrls.count == 0 {
                let response = DisplayEventsPopUp.Events.Response(events: self.events)
                self.presenter?.presentEvents(response: response)
            }
            else {
                var count = 0
                for eventUrl in eventUrls {
                    let eventDoc = EventDocument(fileURL: eventUrl)
                    eventDoc.open(completionHandler: { success in
                        if !success {
                            print("DisplayEventsPopUpInteractor: fetchEvents: error opening EventDocument")
                            return
                        }
                        else {
                            eventDoc.close(completionHandler: {success in
                                guard let event = eventDoc.event else {
                                     print("DisplayEventsPopUpInteractor: fetchEvents: event is nil")
                                    return
                                }
                                if event.entity == self.currentEntity && event.meetingGroup == self.currentMeetingGroup {
                                    self.events!.append(event)
                                }
                                count += 1
                                if count == eventUrls.count {
                                    let response = DisplayEventsPopUp.Events.Response(events: self.events)
                                    self.presenter?.presentEvents(response: response)
                                }
                            })
                        }
                    })
                }
            }
            
        } catch {
            print("DisplayEventsPopUpInteractor: error while enumerating files \(docDirectory.path): \(error.localizedDescription)")
        }
    }
    
    
    func getEvent(index: Int) -> Event {
        return events![index]
    }
    
    
    func setEntity(entity: Entity) {
        self.currentEntity = entity
    }
    
    
    func setMeetingGroup(meetingGroup: MeetingGroup) {
        self.currentMeetingGroup = meetingGroup
    }
}
