//
//  EditEventInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 30/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation


class EditEventInteractor {
    
    func displaySelectedEvent(setupState: SetupState, presenter: EditEventPresenter, selectedMasterRow: Int) {
        let event = setupState.sortedEvents![selectedMasterRow]
        presenter.presentViewModel(selectedEvent: event)
    }
}
