//
//  DisplaySelectedGroupView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 23/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine

struct DisplaySelectedMeetingGroupView: View {
    @EnvironmentObject var entityState: EntityState
    @StateObject var presenter = DisplaySelectedMeetingGroupPresenter()
    @StateObject var setupSheetState: SetupSheetState
    
    var body: some View {
        Print(">>>>>> DisplaySelectedMeetingGroupView body refreshed")
        List {
            ForEach(presenter.meetingGroupViewModel, id: \.self) { content in
                DisplaySelectedMeetingGroupListRow(rowContent: content)
            }
        }
        .listStyle(.insetGrouped)
        
        // Called when meeting group is changed
        .onChange(of: entityState.currentMeetingGroupIndex, perform: { newIndex in
            print("------ DisplaySelectedMeetingGroupView: .onChange currentMeetingGroupIndex")
            DisplaySelectedMeetingGroupInteractor.fetchMeetingGroup(
                presenter: presenter,
                entityState: entityState,
                setupSheetState: setupSheetState,
                newIndex: newIndex
            )
        })
        // Called when first appears
        .onAppear(perform: {
            DisplaySelectedMeetingGroupInteractor.fetchMeetingGroup(
                presenter: presenter,
                entityState: entityState,
                setupSheetState: setupSheetState,
                newIndex: nil
            )
        })
    }
}


struct DisplaySelectedMeetingGroupListRow: View {
    var rowContent: MeetingGroupViewModelRecord
    
    var body: some View {
        HStack{
            Text("\(rowContent.label): ")
                .modifier(DetailListRowLabelModifier())
            Spacer()
            Text(rowContent.value)
                .modifier(DetailListRowValueModifier())
        }
    }
}


//struct DisplaySelectedMeetingGroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplaySelectedMeetingGroupView()
//    }
//}
