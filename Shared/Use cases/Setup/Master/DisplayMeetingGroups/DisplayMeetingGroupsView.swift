//
//  DisplayMeetingGroupsView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 10/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine


/// View for displaying members as a list for a selected entity.
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
                if entityState.sortedEntities != nil {
                    if entityState.currentEntity != nil {
                        Text(entityState.currentEntity!.name!)
                            .font(.system(size: 18, weight: .medium))
                            .padding(.top, 10)
                    }
                    HStack {
                        Menu {
                            ForEach(entityState.sortedEntities!.indices, id: \.self) { idx in
                                Button(entityState.sortedEntities![idx].name!, action: { changeEntity(row: idx)})
                            }
                        } label: {
                            Text("Change entity")
                        }.padding(.trailing, 20)
                    }

                }
                else {
                    Text("No entities created")
                }
            }
            .padding(.leading,20)
            .padding(.trailing,20)
            
            Divider().frame(height: 2).background(Color(white: 0.85, opacity: 1.0))

            List(presenter.meetingGroups, id: \.self, rowContent:  { meetingGroup in
                MeetingGroupListRow(rowContent: meetingGroup)
            })
            // When user changes selected entity
            .onReceive(entityState.$currentEntityIndex, perform:{ newIndex in
                print("------ DisplayMeetingGroupsView .onReceive $currentEntityIndex")
                if (selectedTab == 2) {
                    let interactor = DisplayMeetingGroupsInteractor()
                    if newIndex == nil {
                        interactor.initialiseEntities(entityState: entityState)
                    }
                    interactor.fetchMeetingGroupsOnEntityChange(entityIndex: newIndex!, presenter: presenter, entityState: entityState)
                }
            })
            // When view appears:
            // - set currentEntityIndex
            // - set currentMeetingGroupIndex
            .onAppear(perform: {
                print("------ DisplayMeetingGroupsView .onAppear")
                if selectedTab == 2 {
                    let interactor = DisplayMeetingGroupsInteractor()
                    interactor.initialiseEntities(entityState: entityState)
                    interactor.setSelectedMeetingGroupIndex(idx: nil, entityState: entityState)
                }
            })
            // Reset state for when view is recreated
            .onDisappear(perform: {
                print("DisplayMeetingGroupsView ------ .onDisappear")
            })
        }
    }
    
    func changeEntity(row: Int) {
//        print("Changed entity: row \(row) selected")
//        let entities = entityState.sortedEntities
//        let selectedEntity = entities[row]
//        entityState.currentEntity = selectedEntity
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
        .onTapGesture {
            // Set local state variable and EntityState's currentMemberIndex
            selectedMeetingGroupIdx = rowContent.idx
            let interactor = DisplayMeetingGroupsInteractor()
            interactor.setSelectedMeetingGroupIndex(idx: selectedMeetingGroupIdx!, entityState: entityState)
        }
    }
}



//struct DisplayMeetingGroupsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplayMeetingGroupsView()
//    }
//}
