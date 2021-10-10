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
    
    
    var body: some View {
        Print(">>>>>> DisplaySelectedMeetingGroupView body refreshed")
        List {
            Section {
                ForEach(presenter.meetingGroupViewModel, id: \.self) { content in
                    DisplaySelectedMeetingGroupListRow(rowContent: content)
                }
            }
        }
        .onReceive(entityState.$currentMeetingGroupIndex, perform: { newIndex in
            print("------ DisplaySelectedMeetingGroupView: .onReceive $currentMeetingGroupIndex")
            if newIndex != nil {
                let interactor = DisplaySelectedMeetingGroupInteractor()
                interactor.fetchMeetingGroup(presenter: presenter, entityState: entityState, newIndex: newIndex!)
            }
        })
        .onAppear(perform: {
            let interactor = DisplaySelectedMeetingGroupInteractor()
            interactor.fetchMeetingGroup(presenter: presenter, entityState: entityState, newIndex: nil)
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
