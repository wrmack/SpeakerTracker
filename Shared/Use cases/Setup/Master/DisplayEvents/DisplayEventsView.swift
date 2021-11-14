//
//  DisplayEventsView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 15/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine

/// View for displaying members as a list for a selected entity.
///
/// `DisplayEventsView` works with `DisplayEventsInteractor` and `DisplayEventsPresenter`.
///
/// `DisplayEventsPresenter` is responsible for interacting with the data model.
///
/// `DisplayEventsPresenter` is responsible for formatting data it receives from `DisplayEventsInteractor`
/// so that it is ready for presentation by `DisplayEventsView`. It is initialised as a `@StateObject`
/// to ensure there is only one instance and it notifies new content through a publisher.
///
/// This pattern is based on the VIP (View-Interactor-Presenter) and VMVM (View-Model-ViewModel) patterns.
struct DisplayEventsView: View {
    @EnvironmentObject var entityState: EntityState
    @EnvironmentObject var eventState: EventState
    @StateObject var presenter = DisplayEventsPresenter()
    @Binding var selectedTab: Int
    
    var body: some View {
        Print(">>>>>> DisplayEventsView body refreshed")
        VStack(alignment: .leading) {
            // Select an entity
            VStack(alignment: .leading) {
                if EntityState.sortedEntities != nil {
                    if entityState.currentEntity != nil {
                        Text(entityState.currentEntity!.name!)
                            .font(.system(size: 18, weight: .medium))
                            .padding(.top, 10)

                        HStack {
                            Menu {
                                ForEach(EntityState.sortedEntities!.indices, id: \.self) { idx in
                                    Button(EntityState.sortedEntities![idx].name!, action: { changeEntity(row: idx)})
                                }
                            } label: {
                                Text("Change entity")
                            }.padding(.trailing, 20)
                        }
                    }
                    else {
                        Text("Create an entity first").opacity(0.5)
                    }

                }
            }
            .padding(.leading,20)
            .padding(.trailing,20)
            
            Divider().frame(height: 2).background(Color(white: 0.85, opacity: 1.0))
            
            // Select a meeting group
            VStack(alignment: .leading) {
                if  entityState.currentEntityIndex != nil && EntityState.sortedMeetingGroups(entityIndex: entityState.currentEntityIndex!) != nil {
                    if entityState.currentMeetingGroup != nil {
                        Text(entityState.currentMeetingGroup!.name!)
                            .font(.system(size: 18, weight: .medium))
                            .padding(.top, 10)

                        HStack {
                            Menu {
                                ForEach(EntityState.sortedMeetingGroups(entityIndex: entityState.currentEntityIndex!)!.indices, id: \.self) { idx in
                                    Button(EntityState.sortedMeetingGroups(entityIndex: entityState.currentEntityIndex!)![idx].name!, action: { changeMeetingGroup(row: idx)})
                                }
                            } label: {
                                Text("Change meeting group")
                            }.padding(.trailing, 20)
                        }
                    }
                    else { Text("No meeting groups available").opacity(0.5) }
                }
                else { Text("No meeting groups available").opacity(0.5) }
            }
            .padding(.leading,20)
            .padding(.trailing,20)
            //            .alignmentGuide(HorizontalAlignment.leading) {_ in -10 }
            
            Divider().frame(height: 2).background(Color(white: 0.85, opacity: 1.0))
            
            List(presenter.eventSummaries, id: \.self, rowContent:  {  eventSummary in
                EventsListRow(rowContent: eventSummary)
            })
                .listStyle(.insetGrouped)
            
            // After user changes selected entity
                .onChange(of: entityState.currentEntity, perform: { entity in
                    print("------ DisplayEventsView .onChange entityState.currentEntity")
                    if (selectedTab == 3) {
                        DisplayEventsInteractor.resetMeetingGroupIndex(entityState: entityState)
                        DisplayEventsInteractor.fetchEvents(presenter: presenter, eventState: eventState, entityState: entityState)
                    }
                })
            // Fetch events after user changes selected meeting group
                .onChange(of: entityState.currentMeetingGroupIndex, perform: { newIndex in
                    print("------ DisplayEventsView .onChange entityState.currentMeetingGroupIndex")
                    if (selectedTab == 3) {
                        DisplayEventsInteractor.fetchEventsOnMeetingGroupChange(meetingGroupIndex: newIndex, presenter: presenter, eventState: eventState)
                    }
                })
                .onChange(of: eventState.eventsHaveChanged, perform: { val in
                    print("------ DisplayEventsView .onChange eventState.eventsHaveChanged: \(val)")
                    if (selectedTab == 3) && (val == true) {
                        eventState.eventsHaveChanged = false
                        DisplayEventsInteractor.setCurrentEventIndex(idx: nil, entityState: entityState, eventState: eventState)
                        DisplayEventsInteractor.fetchEvents(presenter: presenter, eventState: eventState, entityState: entityState)
                    }
                })
            
            // Fetch events when view appears, if not already setup
                .onAppear(perform: {
                    print("------ DisplayEventsView .onAppear")
                    if selectedTab == 3 {
                        DisplayEventsInteractor.setCurrentEntityAndMeetingGroupIndices(entityState: entityState)
                        DisplayEventsInteractor.setCurrentEventIndex(idx: nil, entityState: entityState, eventState: eventState)
                        DisplayEventsInteractor.fetchEvents(presenter: presenter, eventState: eventState, entityState: entityState)
                    }
                })
                // Reset state for when view is recreated
                .onDisappear(perform: {
                    print("DisplayEventsView ------ .onDisappear")
                })
            
        }
        
    }
    
    func changeEntity(row: Int) {
        print("------ DisplayEventsView changeEntity(row: \(row))")
        guard let entities = DisplayEventsInteractor.getEntities() else {return}
        let selectedEntity = entities[row]
        entityState.currentEntityIndex = selectedEntity.idx
    }
    
    func changeMeetingGroup(row: Int) {
        print("------ DisplayEventsView changeMeetingGroup(row: \(row))")
        let entityIndex = entityState.currentEntityIndex!
        let meetingGroups = EntityState.sortedMeetingGroups(entityIndex: entityIndex)
        let selectedMeetingGroup = meetingGroups![row]
        entityState.currentMeetingGroupIndex = selectedMeetingGroup.idx
    }
    
}


struct EventsListRow: View {
    @EnvironmentObject var entityState: EntityState
    @EnvironmentObject var eventState: EventState
    @State var selectedMeetingEventIdx: UUID?
    var rowContent: EventSummaryViewModel
    
    var body: some View {
        Print(">>>>>> EventsListRow body refreshed -- \(rowContent.summary)")
        HStack {
            Text(rowContent.summary)
        }
        .modifier(MasterListRowModifier(isSelected: eventState.currentMeetingEventIndex != nil ? rowContent.idx == eventState.currentMeetingEventIndex! : false))
        .contentShape(Rectangle())
        .onTapGesture {
            // Set local state variable and EventState's
            selectedMeetingEventIdx = rowContent.idx
            DisplayEventsInteractor.setCurrentEventIndex(idx: selectedMeetingEventIdx!, entityState: entityState, eventState: eventState)
        }
    }
}


//struct DisplayEventsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplayEventsView()
//    }
//}
