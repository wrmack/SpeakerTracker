//
//  DisplayEntitiesPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 18/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine

struct EntityName: Hashable {
   var name: String
   var idx: Int
}

class DisplayEntitiesPresenter: ObservableObject {
    var entities = [Entity]()
    @Published var entityNames = [EntityName]()
   
    init() {
      print("DisplayEntitiesPresenter initialized")
    }
   
    deinit {
      print("DisplayEntitiesPresenter de-initialized")
    }
   
   func presentEntityNames(entities: [Entity]) {
      self.entities = entities
      var tempNames = [String]()
      var tempEntityNames = [EntityName]()
      for entity in entities {
         tempNames.append(entity.name!)
         tempNames.sort(by: {
              if $0 < $1 {
                  return true
              }
              return false
          })
      }
      var idx = 0
      tempNames.forEach({ el in
         tempEntityNames.append(EntityName(name: el, idx: idx))
         idx += 1
      })
      self.entityNames = tempEntityNames
   }
   
}
