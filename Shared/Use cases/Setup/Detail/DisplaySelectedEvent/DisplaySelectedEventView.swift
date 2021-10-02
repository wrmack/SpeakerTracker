//
//  DisplaySelectedEventView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 16/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import SwiftUI

struct DisplaySelectedEventView: View {
    @EnvironmentObject var setupState: SetupState
    @EnvironmentObject var entityState: EntityState
    @StateObject var presenter = DisplaySelectedEventPresenter()
    @Binding var selectedMasterRow: Int
    
    var body: some View {
        Print(">>>>>> DisplaySelectedEventView body refreshed")
        List {
            Section {
                ForEach(presenter.eventViewModel, id: \.self) { content in
                    DisplaySelectedEventListRow(rowContent: content)
                }
            }
        }
        .onReceive(self.presenter.$presenterUp, perform: { _ in
            print("DisplaySelectedEventView: .onReceive presenter.$presenterUp")
            // If presenter is ready and events master has already been set up
            if setupState.eventsMasterIsSetup == true {
                print("------ onReceive calling interactor")
                let interactor = DisplaySelectedEventInteractor()
                interactor.fetchEvent(
                    presenter: presenter,
                    entityState: entityState,
                    setupState: setupState,
                    forRow: 0)
                self.setupState.meetingGroupsDetailIsSetup = true
            }
        })
        .onReceive(self.setupState.$eventsMasterIsSetup, perform: { _ in
            print("DisplaySelectedEventView: .onReceive presenter.$eventsMasterIsSetup")
            // If event detail has not been setup but members master has been set up
            if (setupState.eventsDetailIsSetup == false) && (setupState.eventsMasterIsSetup == true)  {
                print("------ onReceive calling interactor")
                let interactor = DisplaySelectedEventInteractor()
                interactor.fetchEvent(
                    presenter: presenter,
                    entityState: entityState,
                    setupState: setupState,
                    forRow: 0)
                self.setupState.meetingGroupsDetailIsSetup = true
            }
        })
        .onChange(of: selectedMasterRow, perform: { row in
            print("DisplaySelectedEventView: .onChange selectedMasterRow")
            if setupState.eventsMasterIsSetup == true {
                print("------ onReceive calling interactor")
                let interactor = DisplaySelectedEventInteractor()
                interactor.fetchEvent(
                    presenter: presenter,
                    entityState: entityState,
                    setupState: setupState,
                    forRow: row)
            }
        })
    }
}

struct DisplaySelectedEventListRow: View {
   var rowContent: EventViewModelRecord
   
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

//struct DisplaySelectedEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplaySelectedEventView()
//    }
//}
