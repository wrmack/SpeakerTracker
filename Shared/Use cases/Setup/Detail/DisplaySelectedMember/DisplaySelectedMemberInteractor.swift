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
   
    class func fetchMember(presenter: DisplaySelectedMemberPresenter, entityState: EntityState, newIndex: UUID?) {
        print("------ DisplaySelectedMemberInteractor.fetchMember")
        var memberIndex: UUID?
        
        // newIndex is nil when method called by .onAppear
        if newIndex == nil {
            if let currentMemberIndex = entityState.currentMemberIndex {
                memberIndex = currentMemberIndex
            }
            else {
                presenter.presentMemberDetail(member: nil)
                return
            }
        }
        else {
            memberIndex = newIndex
        }
        let selectedMember = EntityState.memberWithIndex(index: memberIndex!)
        
        presenter.presentMemberDetail(member: selectedMember)
   }
    
}
