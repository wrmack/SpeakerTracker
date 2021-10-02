//
//  AddEventInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 15/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation


class AddEventInteractor {
    
    func fetchEntityForRow(entityState: EntityState, row: Int) -> Entity {
        return entityState.entities[row]
    }
    
    func fetchMeetingGroupForRow(entityState: EntityState, selectedEntityIndex: Int, row: Int) -> MeetingGroup {
        let entity = entityState.entities[selectedEntityIndex]
        return entity.meetingGroups![row]
    }
    
    func saveEvent(entityState: EntityState, entityIndex: Int, meetingGroupIndex: Int, date: Date, time: Date) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: Document directory not found")
            return
        }
        let cal = Calendar.current
        let dateComponents = cal.dateComponents(Set([Calendar.Component.day,Calendar.Component.month, Calendar.Component.year]), from: date)
        let newDate = cal.date(from: dateComponents)
        let timeComponents = cal.dateComponents(Set([Calendar.Component.hour,Calendar.Component.minute]), from: time)
        let newDateWithTime = cal.date(byAdding: timeComponents, to: newDate!)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd_hh-mm"
        let newDateString = df.string(from: newDateWithTime!)
        let event = Event(date: newDateWithTime, entity: entityState.entities[entityIndex], meetingGroup: entityState.entities[entityIndex].meetingGroups![meetingGroupIndex], note: nil, debates: nil, filename: newDateString)
        let newEvent = event
        var filename: String
        if newEvent.filename == nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd_hh-mm"
            filename = formatter.string(from: Date())
        }
        else { filename = newEvent.filename!}

        let docFileURL =  documentsDirectory.appendingPathComponent(filename + ".evt")
        let eventDoc = EventDocument(fileURL: docFileURL, name: event.filename, event: newEvent)
        eventDoc.save(to: docFileURL, for: .forCreating, completionHandler: { success in
            if !success {
                print("AddEventInteractor: saveEntity: Error saving")
            }
            else{
                print("AddEventInteractor: saveEntity: Saving successful")
            }
        })
    }
}
