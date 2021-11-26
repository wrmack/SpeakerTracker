//
//  DisplaySelectedEventView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 16/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import SwiftUI

struct DisplaySelectedEventView: View {
    
    @EnvironmentObject var entityState: EntityState
    @EnvironmentObject var eventState: EventState
    @StateObject var presenter = DisplaySelectedEventPresenter()
    @StateObject var setupSheetState: SetupSheetState
    
    var body: some View {
        Print(">>>>>> DisplaySelectedEventView body refreshed")
        List {
            ForEach(presenter.eventViewModel, id: \.self) { content in
                DisplaySelectedEventListRow(rowContent: content)
            }
        }
        .listStyle(.automatic)
        
        // Called when different meeting event is selected by user
        .onChange(of: eventState.currentMeetingEventIndex, perform: { newIndex in
            print("------ DisplaySelectedEventView: .onChange currentMeetingEventIndex")
            DisplaySelectedEventInteractor.fetchEvent(
                presenter: presenter,
                eventState: eventState,
                entityState: entityState,
                setupSheetState: setupSheetState,
                newIndex: newIndex
            )
        })
        .onChange(of: eventState.eventsHaveChanged, perform: { val in
            DisplaySelectedEventInteractor.fetchEvent(
                presenter: presenter,
                eventState: eventState,
                entityState: entityState,
                setupSheetState: setupSheetState,
                newIndex: nil
            )
        })
        .onReceive(presenter.$eventViewModel, perform: { viewModel in
            print("viewModel \(viewModel)")
        })
        // Called when first appears
        .onAppear(perform: {
            DisplaySelectedEventInteractor.fetchEvent(
                presenter: presenter,
                eventState: eventState,
                entityState: entityState,
                setupSheetState: setupSheetState,
                newIndex: nil
            )
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
