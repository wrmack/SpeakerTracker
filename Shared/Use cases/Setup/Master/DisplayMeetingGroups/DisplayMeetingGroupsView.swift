//
//  DisplayMeetingGroupsView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 10/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine


/// View for displaying meeting groups as a list for a selected entity.
///
/// `DisplayMeetingGroupsView` works with `DisplayMeetingGroupsInteractor` and `DisplayMeetingGroupsPresenter`.
///
/// `DisplayMeetingGroupsInteractor` is responsible for interacting with the data model.
///
/// `DisplayMeetingGroupsPresenter` is responsible for formatting data it receives from `DisplayMeetingGroupsInteractor`
/// so that it is ready for presentation by `DisplayMeetingGroupsView`. It is initialised as a `@StateObject`
/// to ensure there is only one instance and it notifies new content through a publisher.
///
/// This pattern is based on the VIP (View-Interactor-Presenter) and VMVM (View-Model-ViewModel) patterns.
struct DisplayMeetingGroupsView: View {
    @EnvironmentObject var entityState: EntityState
    @StateObject var presenter = DisplayMeetingGroupsPresenter()
    @Binding var selectedTab: Int
    
    var body: some View {
        Print(">>>>>> DisplayMeetingGroupsView body refreshed")
        VStack(alignment: .leading) {
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
            
            List(presenter.meetingGroups, id: \.self, rowContent:  { meetingGroup in
                MeetingGroupListRow(rowContent: meetingGroup)
            })
                .listStyle(.automatic)
            
            // .onChange preferred to .onReceive because not called when view is first rendered, only when changed
                .onChange(of: entityState.currentEntityIndex, perform: { newIndex in
                    print("------ DisplayMeetingGroupsView .onChange currentEntityIndex \(String(describing: newIndex))")
                    if (selectedTab == 2) {
                        if newIndex == nil {
                            DisplayMeetingGroupsInteractor.setCurrentEntityIndex(entityState: entityState)  // Ever called?? Unlikely currentEntityIndex will change to nil
                        }
                        DisplayMeetingGroupsInteractor.fetchMeetingGroupsOnEntityChange(entityIndex: newIndex!, presenter: presenter, entityState: entityState)
                    }
                })
                .onChange(of: entityState.meetingGroupsHaveChanged, perform: { val in
                    print("------ DisplayMeetingGroupsView .onChange entityState.meetingGroupsHaveChanged: \(val)")
                    if (selectedTab == 2) && (val == true)   {
                        entityState.meetingGroupsHaveChanged = false
                        DisplayMeetingGroupsInteractor.fetchMeetingGroups(presenter: presenter, entityState: entityState)
                    }
                })
            // When view appears:
            // - set currentEntityIndex
            // - set currentMeetingGroupIndex
            // - fetch meeting groups
                .onAppear(perform: {
                    print("------ DisplayMeetingGroupsView .onAppear")
                    if selectedTab == 2 {
                        DisplayMeetingGroupsInteractor.setCurrentEntityIndex(entityState: entityState)
                        DisplayMeetingGroupsInteractor.setCurrentMeetingGroupIndex(idx: nil, entityState: entityState)
                        DisplayMeetingGroupsInteractor.fetchMeetingGroups(presenter: presenter, entityState: entityState)
                    }
                })
            // Reset state for when view is recreated
                .onDisappear(perform: {
                    print("------ DisplayMeetingGroupsView ------ .onDisappear")
                })
        }
    }
    
    func changeEntity(row: Int) {
        print("------ DisplayMeetingGroupsView changeEntity(row: \(row))")
        guard let entities = DisplayMeetingGroupsInteractor.getEntities() else {return}
        let selectedEntity = entities[row]
        entityState.currentEntityIndex = selectedEntity.idx
    }
}

struct MeetingGroupListRow: View {
    @EnvironmentObject var entityState: EntityState
    @State var selectedMeetingGroupIdx: UUID?
    var rowContent: MeetingGroupViewModel
    
    
    var body: some View {
        HStack {
            Text(rowContent.name)
        }
        .modifier(MasterListRowModifier(isSelected: entityState.currentMeetingGroupIndex != nil ? rowContent.idx == entityState.currentMeetingGroupIndex! : false))
        .contentShape(Rectangle())
        .onTapGesture {
            // Set local state variable and EntityState's currentMeetingGroupIndex
            selectedMeetingGroupIdx = rowContent.idx
            DisplayMeetingGroupsInteractor.setCurrentMeetingGroupIndex(idx: selectedMeetingGroupIdx!, entityState: entityState)
        }
    }
}



//struct DisplayMeetingGroupsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplayMeetingGroupsView()
//    }
//}
