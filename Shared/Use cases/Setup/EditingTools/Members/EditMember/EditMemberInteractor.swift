//
//  EditMemberInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 11/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine


class EditMemberInteractor {

    class func displaySelectedMember(entityState: EntityState, presenter: EditMemberPresenter) {
        guard let member = entityState.currentMember else {return}
        presenter.presentViewModel(selectedMember: member)
    }
    
    
    /**
     Saves member being edited.  
     */
    class func saveChangedMemberToStore(entityState: EntityState, title: String, first: String, last: String) {
        let viewContext = PersistenceController.shared.container.viewContext
        let currentMember = entityState.currentMember
        currentMember?.title = title
        currentMember?.firstName = first
        currentMember?.lastName = last
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        entityState.membersHaveChanged = true
    }
}
