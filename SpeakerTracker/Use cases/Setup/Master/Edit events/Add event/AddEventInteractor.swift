//
//  AddEventInteractor.swift
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

protocol AddEventBusinessLogic {
    func saveEventToDisk(event: Event, callback: @escaping ()->())
    func getEntity()-> Entity
    func getMeetingGroup()-> MeetingGroup
}

protocol AddEventDataStore {
    var entity: Entity? {get set}
    var meetingGroup: MeetingGroup? {get set}
}



class AddEventInteractor: AddEventBusinessLogic, AddEventDataStore {
    var presenter: AddEventPresentationLogic?
    var entity: Entity?
    var meetingGroup: MeetingGroup?
    
    
    func saveEventToDisk(event: Event, callback: @escaping ()->()) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: Document directory not found")
            return
        }
        var newEvent = event
        var filename: String
        if newEvent.filename == nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd_hh-mm"
            filename = formatter.string(from: Date())
        }
        else { filename = newEvent.filename!}
        newEvent.entity = self.entity
        newEvent.meetingGroup = self.meetingGroup
        let docFileURL =  documentsDirectory.appendingPathComponent(filename + ".evt")
        let eventDoc = EventDocument(fileURL: docFileURL, name: event.filename, event: newEvent)
        eventDoc.save(to: docFileURL, for: .forCreating, completionHandler: { success in
            if !success {
                print("AddEventInteractor: saveEntityToDisk: Error saving")
            }
            else{
                callback()
            }
        })
    }
    
    func getEntity()-> Entity {
        return self.entity!
    }
    
    func getMeetingGroup()-> MeetingGroup {
        return self.meetingGroup!
    }
}
