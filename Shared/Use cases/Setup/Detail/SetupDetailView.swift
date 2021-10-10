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

    @Binding var selectedSetupTab: Int

    
    var body: some View {
        Print(">>>>>> SetupDetailView body refreshed")
        switch selectedSetupTab {
        case 0: DisplaySelectedEntityView()
        case 1: DisplaySelectedMemberView()
        case 2: DisplaySelectedMeetingGroupView()
//        case 3: DisplaySelectedEventView(selectedMasterRow: $selectedMasterRow)
        default: DisplaySelectedEntityView()
        }
    }
}

//struct SetupDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        SetupDetail()
//    }
//}
