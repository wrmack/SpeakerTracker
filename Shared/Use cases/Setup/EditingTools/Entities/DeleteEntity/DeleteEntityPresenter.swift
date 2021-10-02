//
//  DeleteEntityPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 13/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation

struct DeleteEntityViewModel {
    var name = ""
}

class DeleteEntityPresenter: ObservableObject {
    @Published var viewModel = DeleteEntityViewModel()
    
    func presentViewModel(selectedEntity: Entity) {
        let tempModel = DeleteEntityViewModel(name: selectedEntity.name!)
        viewModel = tempModel
    }
}
