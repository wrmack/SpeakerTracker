//
//  AddMemberInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 29/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine

class AddMemberInteractor: ObservableObject {
    
    
    
    /*
     Saves member to model and persistent storage.
     Called when user decides to save new member.
     tempMemberList is an array that is updated when user presses the "Add another" button, but is not saved until this is called.
     Also updates currenty entity in user defaults.
     */
    class func saveNewMemberToEntity(entityState: EntityState, title: String, first: String, last: String) {
        
        let viewContext = PersistenceController.shared.container.viewContext
        let newMember = Member(context: viewContext)
        newMember.title = title
        newMember.firstName = first
        newMember.lastName = last
        newMember.idx = UUID()
        
        entityState.currentMemberIndex = newMember.idx
        
        let currentEntity = entityState.currentEntity!
        let memberSet = currentEntity.entityMembers
        currentEntity.entityMembers = memberSet!.adding(newMember) as NSSet
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        entityState.currentMemberIndex = newMember.idx
        entityState.membersHaveChanged = true

    }
    
}
