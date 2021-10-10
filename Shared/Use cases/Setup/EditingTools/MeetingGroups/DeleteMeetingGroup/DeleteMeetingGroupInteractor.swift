//
//  DeleteMeetingGroupInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 15/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation
import CoreData


class DeleteMeetingGroupInteractor {

    init() {
        print("++++++ DeleteMeetingGroupInteractor initialised")
    }

    deinit {
        print("++++++ DeleteMeetingGroupInteractor de-initialised")
    }
   
    
    func displaySelectedMeetingGroup(entityState: EntityState, presenter:  DeleteMeetingGroupPresenter) {
        
        guard let meetingGroup = entityState.currentMeetingGroup else {return}
        presenter.presentViewModel(selectedMeetingGroup: meetingGroup)
        
    }
    
    
    func deleteSelectedMeetingGroupFromEntity(entityState: EntityState) {
        guard let meetingGroup = entityState.currentMeetingGroup else {return}
        
        let viewContext = PersistenceController.shared.container.viewContext
        viewContext.delete(meetingGroup as NSManagedObject)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
            
        entityState.currentMeetingGroupIndex = nil
        entityState.meetingGroupsHaveChanged = true
        
   }
}
