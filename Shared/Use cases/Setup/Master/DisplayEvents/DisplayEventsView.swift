//
//  DisplayEventsView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 15/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine


struct DisplayEventsView: View {
    @EnvironmentObject var entityState: EntityState
    @EnvironmentObject var eventState: EventState
    @EnvironmentObject var setupState: SetupState
    @StateObject var presenter = DisplayEventsPresenter()
//    @State var selectedIndex = 0
    @Binding var selectedTab: Int
    @Binding var selectedMasterRow: Int
    
    var body: some View {
        Print(">>>>>> DisplayEventsView body refreshed")
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                if entityState.sortedEntities != nil {
                    if entityState.currentEntity != nil {
                        Text(entityState.currentEntity!.name!)
                            .font(.system(size: 18, weight: .medium))
                            .padding(.top, 10)
                    }
                    HStack {
                        Menu {
                            ForEach(entityState.entities.indices, id: \.self) { idx in
                                Button(entityState.entities[idx].name!, action: { changeEntity(row: idx)})
                            }
                        } label: {
                            Text("Change entity")
                        }.padding(.trailing, 20)
                    }
                    
                }
                else {
                    Text("No entities created")
                }
            }.alignmentGuide(HorizontalAlignment.leading) {_ in -10 }
            
            Divider()
            
            VStack(alignment: .leading) {
                if entityState.currentEntity?.meetingGroups != nil {
                    Text(entityState.currentMeetingGroup?.name! ?? entityState.currentEntity!.meetingGroups![0].name!)
                        .font(.system(size: 18, weight: .medium))
                        .padding(.top, 10)
                    HStack {
                        Menu {
                            ForEach(entityState.currentEntity!.meetingGroups!.indices, id: \.self) { idx in
                                Button(entityState.currentEntity!.meetingGroups![idx].name!, action: { changeMeetingGroup(row: idx)})
                            }
                        } label: {
                            Text("Change meeting group")
                        }.padding(.trailing, 20)
                    }
                }
                else {
                    Text("Create a meeting group first").foregroundColor(Color(white: 0.5))
                }
            }.alignmentGuide(HorizontalAlignment.leading) {_ in -10 }
            
            Divider().frame(height: 2).background(Color(white: 0.85, opacity: 1.0))
            
            List(presenter.eventSummaries, id: \.self, rowContent:  {  eventSummary in
                EventsListRow(rowContent: eventSummary, setupState: setupState, selectedMasterRow: $selectedMasterRow)
            })
            // When user selects a different row
//            .onReceive(self.setupState.$selectedRow, perform: {row in
//                print("DisplayEventsView .onReceive setupState.$selectedRow")
//                if selectedTab == 3 {
//                    if (self.setupState.eventsMasterIsSetup == true) {
//                        print("------ onReceive")
////                        self.selectedIndex = row
//                    }
//                }
//            })
            // After user changes selected entity
            .onChange(of: entityState.currentEntity, perform: { entity in
                print("DisplayEventsView .onRecieve setupState.objectWillChange")
                if (selectedTab == 3) {
                    print("------ onReceive: Calling interactor")
                    let interactor = DisplayEventsInteractor()
                    interactor.fetchEvents(presenter: presenter, eventState: eventState, entityState: entityState, setupState: setupState)
                }
            })
            // Fetch events after user changes selected meeting group
            .onChange(of: entityState.currentMeetingGroup, perform: { group in
                print("DisplayEventsView .onReceive setupState.$selectedMeetingGroup")
                if (selectedTab == 3) {
                    print("------ onReceive: Calling interactor")
                    let interactor = DisplayEventsInteractor()
                    interactor.fetchEvents(presenter: presenter, eventState: eventState, entityState: entityState, setupState: setupState)
                }
            })
            // Fetch events when tab is selected, if not already setup
            .onChange(of: selectedTab, perform: { tab in
                print("----- DisplayEventsView .onChange SelectedTab changed to \(tab)")
                if tab == 3 && self.setupState.eventsMasterIsSetup == false && entityState.entities.count > 0 {
                    print("****** fetching events on change of tab")
                    entityState.currentEntity = entityState.entities[0]
                    let interactor = DisplayEventsInteractor()
                    interactor.fetchEvents(presenter: presenter, eventState: eventState, entityState: entityState,setupState: setupState)
                }
            })
            // Fetch events when view appears, if not already setup
            .onAppear(perform: {
                print("------ DisplayEventsView .onAppear")
                if selectedTab == 3 && self.setupState.eventsMasterIsSetup == false && entityState.entities.count > 0 {
                    print("****** fetching events on view appear")
                    entityState.currentEntity = entityState.entities[0]
                    if entityState.currentEntity?.meetingGroups != nil &&
                        entityState.currentEntity!.meetingGroups!.count > 0 {
                        entityState.currentMeetingGroup = entityState.currentEntity!.meetingGroups![0]
                    }
                    else {
                        entityState.currentMeetingGroup = nil
                    }
                    let interactor = DisplayEventsInteractor()
                    interactor.fetchEvents(presenter: presenter, eventState: eventState, entityState: entityState, setupState: setupState)
                }
            })
            // Reset state for when view is recreated
            .onDisappear(perform: {
                print("DisplayEventsView ------ .onDisappear")
                setupState.eventsMasterIsSetup = false
                setupState.eventsDetailIsSetup = false
            })
        }
    }
    
    func changeEntity(row: Int) {
        print("Changed entity: row \(row) selected")
        let entities = entityState.sortedEntities
        let selectedEntity = entities[row]
        setupState.eventsMasterIsSetup = false
        entityState.currentEntity = selectedEntity
        entityState.currentMeetingGroup = nil
    }
    
    func changeMeetingGroup(row: Int) {
        print("Changed meeting group: row \(row) selected")
        let meetingGroups = entityState.currentEntity?.meetingGroups
        let selectedMeetingGroup = meetingGroups![row]
        setupState.eventsMasterIsSetup = false
        entityState.currentMeetingGroup = selectedMeetingGroup
    }
}

struct EventsListRow: View {
    var rowContent: EventSummary
    var setupState: SetupState
    @Binding var selectedMasterRow: Int
    
    var body: some View {
        HStack {
            Text(rowContent.summary)
        }
        .modifier(MasterListRowModifier(isSelected: rowContent.idx == selectedMasterRow))
        .onTapGesture {
            selectedMasterRow = rowContent.idx
        }
    }
}
//struct DisplayEventsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplayEventsView()
//    }
//}
