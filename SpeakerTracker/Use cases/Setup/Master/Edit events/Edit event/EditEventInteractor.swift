//
//  EditEventInteractor.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 6/10/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol EditEventBusinessLogic {
    func getEvent()-> Event?
    func saveEventToDisk(event: Event, callback: @escaping ()->())
}

protocol EditEventDataStore {
    var event: Event? {get set}
}

class EditEventInteractor: EditEventBusinessLogic, EditEventDataStore {
    var presenter: EditEventPresentationLogic?
    var event: Event?
//    var entity: Entity?
//    var meetingGroup: MeetingGroup?
    
    
    func getEvent()-> Event? {
        return event
    }

    
    func saveEventToDisk(event: Event, callback: @escaping ()->()) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: Document directory not found")
            return
        }
        let editedEvent = event
        let docFileURL =  documentsDirectory.appendingPathComponent(editedEvent.filename! + ".evt")
        let eventDoc = EventDocument(fileURL: docFileURL)
        eventDoc.open(completionHandler: { success in
            if !success {
                print("EditEventInteractor: saveEventToDisk: error opening EventDocument")
            }
            else {
                eventDoc.event = editedEvent
                eventDoc.updateChangeCount(.done)
                eventDoc.close(completionHandler: { success in
                    callback()
                })
            }
        })
    }
}
