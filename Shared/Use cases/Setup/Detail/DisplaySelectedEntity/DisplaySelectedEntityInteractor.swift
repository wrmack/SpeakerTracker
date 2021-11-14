//
//  DisplaySelectedEntityInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 22/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import CoreData

/// `DisplaySelectedEntityInteractor` is responsible for interacting with the data model.
class DisplaySelectedEntityInteractor {
    
    class func fetchEntity(presenter: DisplaySelectedEntityPresenter, entityState: EntityState, setupSheetState: SetupSheetState, newIndex: UUID?) {
        print("------ DisplaySelectedEntityInteractor.fetchEntity")
        if setupSheetState.addDisabled == true { setupSheetState.addDisabled = false}
        var entityIndex: UUID?
        if newIndex == nil {
            guard let currentEntityIndex = entityState.currentEntityIndex else {
                setupSheetState.editDisabled = true
                setupSheetState.deleteDisabled = true
                presenter.presentEntityDetail(entity: nil)
                return
            }
             entityIndex = currentEntityIndex 
        } else { entityIndex = newIndex}
        let selectedEntity = EntityState.entityWithIndex(index: entityIndex!)
        setupSheetState.deleteDisabled = false
        setupSheetState.editDisabled = false
        presenter.presentEntityDetail(entity: selectedEntity)
    }
}
