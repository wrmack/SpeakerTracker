//
//  DisplaySelectedEntityInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 22/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation


class DisplaySelectedEntityInteractor {
    
    func fetchEntity(presenter: DisplaySelectedEntityPresenter, entityState: EntityState?, selectedMasterRow: Int) {
        print("DisplaySelectedEntityInteractor.fetchEntity")
        var entity: Entity?
        var idx = selectedMasterRow
        if entityState!.entities.count > 0 {
            if idx > entityState!.entities.count - 1 { idx = entityState!.entities.count - 1}
            entity = entityState!.sortedEntities[idx]
        }
        presenter.presentEntityDetail(entity: entity)
    }
}
