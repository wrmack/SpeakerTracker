//
//  DisplaySelectedMemberInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 7/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation

/// `DisplaySelectedMemberInteractor` is responsible for interacting with the data model.
class DisplaySelectedMemberInteractor {
   
    class func fetchMember(presenter: DisplaySelectedMemberPresenter, entityState: EntityState, setupSheetState: SetupSheetState,newIndex: UUID?) {
        print("------ DisplaySelectedMemberInteractor.fetchMember")
        
        
        var memberIndex: UUID?
        
        // newIndex is nil when method called by .onAppear
        if newIndex == nil {
            if let currentMemberIndex = entityState.currentMemberIndex {
                memberIndex = currentMemberIndex
            }
            else {
                if entityState.currentEntityIndex == nil { setupSheetState.addDisabled = true }
                setupSheetState.editDisabled = true
                setupSheetState.deleteDisabled = true
                presenter.presentMemberDetail(member: nil)
                return
            }
        }
        else {
            memberIndex = newIndex
        }
        let selectedMember = EntityState.memberWithIndex(index: memberIndex!)
        setupSheetState.deleteDisabled = false
        setupSheetState.editDisabled = false
        presenter.presentMemberDetail(member: selectedMember)
   }
    
}
