//
//  DisplayEntitiesPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 18/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine

/// The model that is used by the presenter for publishing entities
struct EntityViewModel: Hashable {
   var name: String
   var idx: UUID
}

/// `DisplayEntitiesPresenter` is responsible for formatting data it receives from `DisplayEntitiesInteractor`
/// so that it is ready for presentation by `DisplayMembersView`.
class DisplayEntitiesPresenter: ObservableObject {

    @Published var entities = [EntityViewModel]()
   
    init() {
      print("++++++ DisplayEntitiesPresenter initialized")
    }
   
    deinit {
      print("++++++ DisplayEntitiesPresenter de-initialized")
    }
   
    /// Receives entities and stores them in the presenter's publisher using the presenter's view model
   func presentEntityNames(entities: [Entity]?) {
       print("------ DisplayEntitiesPresenter presentEntityNames")
       var tempEntities = entities
       tempEntities?.sort(by: {
           if $0.name! < $1.name! { return true }
           return false
       })
      var tempEntityVMs = [EntityViewModel]()
      if entities != nil {
         for entity in entities! {
             let entityName = entity.name == "" ? "test" : entity.name
             tempEntityVMs.append(EntityViewModel(name:entityName!, idx: entity.idx!))
         }

      }

      self.entities = tempEntityVMs
       
   }
   
}
