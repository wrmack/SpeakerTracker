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
    @Binding var selectedMasterRow: Int
   
   var body: some View {
      Print(">>>>>> DisplaySelectedMeetingGroupView body refreshed")
      List {
         Section {
            ForEach(presenter.meetingGroupViewModel, id: \.self) { content in
               DisplaySelectedMeetingGroupListRow(rowContent: content)
            }
         }
      }
      .onReceive(entityState.$currentEntity, perform: { entity in
        print("DisplaySelectedMeetingGroupView onReceive entityState.$currentEntity \(entity!)")
        let interactor = DisplaySelectedMeetingGroupInteractor()
        interactor.fetchMeetingGroupFromChangingEntity(presenter: presenter, entity: entity!, selectedMasterRow: 0)
      })
      .onChange(of: selectedMasterRow, perform: { row in
        print("DisplaySelectedMeetingGroupView: .onChange selectedMasterRow")
        print("------ onReceive calling interactor")
        let interactor = DisplaySelectedMeetingGroupInteractor()
        interactor.fetchMeetingGroup(presenter: presenter, entityState: entityState, selectedMasterRow: row)
        })
      .onAppear(perform: {
        if entityState.sortedEntities.count > 0 {
            let interactor = DisplaySelectedMeetingGroupInteractor()
            interactor.fetchMeetingGroup(presenter: presenter, entityState: entityState, selectedMasterRow: 0)
        }
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
