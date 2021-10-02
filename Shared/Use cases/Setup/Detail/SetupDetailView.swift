//
//  SetupDetail.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 14/08/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine

struct SetupDetailView: View {
    //   @EnvironmentObject var setupState : SetupState
    @Binding var selectedSetupTab: Int
    @Binding var selectedMasterRow: Int
    
    var body: some View {
        Print(">>>>>> SetupDetailView body refreshed")
        switch selectedSetupTab {
        case 0: DisplaySelectedEntityView(selectedMasterRow: $selectedMasterRow)
        case 1: DisplaySelectedMemberView(selectedMasterRow: $selectedMasterRow)
        case 2: DisplaySelectedMeetingGroupView(selectedMasterRow: $selectedMasterRow)
//        case 3: DisplaySelectedEventView(selectedMasterRow: $selectedMasterRow)
        default: DisplaySelectedEntityView(selectedMasterRow: $selectedMasterRow)
        }
    }
}

//struct SetupDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        SetupDetail()
//    }
//}
