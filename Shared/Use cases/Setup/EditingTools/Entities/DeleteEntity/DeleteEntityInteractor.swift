//
//  DeleteEntityInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 6/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine


class DeleteEntityInteractor {
    
    init() {
        print("DeleteEntityInteractor initialised")
    }
    
    deinit {
        print("DeleteEntityInteractor de-initialised")
    }
    
    func displaySelectedEntity(entityState: EntityState, presenter: DeleteEntityPresenter, indexOfEntityToFetch: Int) {
        let entity = entityState.sortedEntities[indexOfEntityToFetch]
        presenter.presentViewModel(selectedEntity: entity)
    }
    
    func deleteEntity(entityState: EntityState, indexOfEntityToDelete: Int) {
//        let entityState = entityState
//        let currentEntity = entityState.sortedEntities[indexOfEntityToDelete]
//        
//        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            print("DeleteEntityInteractor: removEntity: error: Document directory not found")
//            return
//        }
//        let file = currentEntity.id.uuidString
//        let docFileURL = docDirectory.appendingPathComponent(file + ".ent")
//        do {
//            try FileManager.default.removeItem(at: docFileURL)
//            entityState.entities.removeAll(where: { entity in
//                entity.id == currentEntity.id
//            })
//            entityState.entityModelChanged = true
//        }
//        catch {
//            print(error)
//        }
    }
}
