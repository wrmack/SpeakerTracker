//
//  SheetState.swift
//  Speaker-tracker-multi
//
//  Created by Warwick McNaughton on 9/10/21.
//

import Foundation
import Combine

/// Holds state associated with editing use-cases
///
class SetupSheetState: ObservableObject {
    
    @Published var saveWasPressed = false
    @Published var showSheet = false
    @Published var showMembersSheet = false
    @Published var selectedMembers: Set<Member>?
    
    @Published var addDisabled = true
    @Published var editDisabled = true
    @Published var deleteDisabled = true
    
    var editMode = 0  // 0 = add, 1 = edit, 2 = delete
    
    init() {
       print("++++++ SetupSheetState initialized")
    }
    
    deinit {
       print("++++++ SetupSheetState de-initialized")
    }
}


