//
//  DisplaySelectedEntityPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 28/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation


struct EntityDetailViewModel: Hashable {
    var label: String
    var value: String
}


/// `DisplaySelectedEntityPresenter` is responsible for formatting data it receives from `DisplaySelectedEntityInteractor`
/// so that it is ready for presentation by `DisplaySelectedEntityView`.
class DisplaySelectedEntityPresenter: ObservableObject {

    @Published var entityDetail = [EntityDetailViewModel]()
    
    init() {
        print("++++++ DisplaySelectedEntityPresenter initialized")
    }
    
    deinit {
        print("++++++ DisplaySelectedEntityPresenter de-initialized")
    }
    

    func presentEntityDetail(entity: Entity?) {
        var tempArray = [EntityDetailViewModel]()
        if entity != nil {
            tempArray.append(EntityDetailViewModel(label: "Name", value: entity!.name!))
        }
        entityDetail = tempArray
    }
}
