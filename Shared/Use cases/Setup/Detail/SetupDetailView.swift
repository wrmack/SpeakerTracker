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
    @StateObject var setupSheetState: SetupSheetState
    @Binding var selectedSetupTab: Int

    
    var body: some View {
        Print(">>>>>> SetupDetailView body refreshed")
        switch selectedSetupTab {
        case 0: DisplaySelectedEntityView(setupSheetState: setupSheetState)
        case 1: DisplaySelectedMemberView(setupSheetState: setupSheetState)
        case 2: DisplaySelectedMeetingGroupView(setupSheetState: setupSheetState)
        case 3: DisplaySelectedEventView(setupSheetState: setupSheetState)
        default: DisplaySelectedEntityView(setupSheetState: setupSheetState)
        }
    }
}

//struct SetupDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        SetupDetail()
//    }
//}
