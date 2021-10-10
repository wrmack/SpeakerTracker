//
//  DeleteMemberInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 11/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine
import CoreData


class DeleteMemberInteractor {

    init() {
        print("++++++ DeleteMemberInteractor initialised")
    }

    deinit {
        print("++++++ DeleteMemberInteractor de-initialised")
    }
   
    
    func displaySelectedMember(entityState: EntityState, presenter: DeleteMemberPresenter) {
        guard let member = entityState.currentMember else {return}
        presenter.presentViewModel(selectedMember: member)
    }
    
    
    func deleteSelectedMemberFromEntity(entityState: EntityState) {
        
        guard let member = entityState.currentMember else {return}
        
        let viewContext = PersistenceController.shared.container.viewContext
        viewContext.delete(member as NSManagedObject)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
            
        entityState.currentMemberIndex = nil
        entityState.membersHaveChanged = true
        
   }
}
