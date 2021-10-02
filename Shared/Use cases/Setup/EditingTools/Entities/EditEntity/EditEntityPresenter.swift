//
//  EditEntityPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 13/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation

struct EditEntityViewModel {
    var name = ""
}

class EditEntityPresenter: ObservableObject {
    @Published var viewModel = EditEntityViewModel()
    
    func presentViewModel(selectedEntity: Entity) {
        let tempModel = EditEntityViewModel(name: selectedEntity.name!)
        viewModel = tempModel
    }
}
