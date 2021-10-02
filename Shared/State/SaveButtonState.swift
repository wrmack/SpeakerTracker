//
//  SaveButtonState.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 6/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine

/**
 Observers are notified when savePressed changes
 */

class SaveButtonState: ObservableObject {
   @Published var savePressed = false
   
   init() {
      print("++++++ SaveButtonState initialized")
   }
   
   deinit {
      print("++++++ SaveButtonState de-initialized")
   }
}
