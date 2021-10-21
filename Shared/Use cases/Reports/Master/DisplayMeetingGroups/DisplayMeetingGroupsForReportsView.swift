//
//  DisplayMeetingGroupsForReportsView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 24/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import SwiftUI

struct DisplayMeetingGroupsForReportsView: View {
    @EnvironmentObject var entityState: EntityState
    @StateObject var presenter = DisplayMeetingGroupsForReportsPresenter()
    @State var selectedIndex = 0
//    @Binding var selectedMasterRow: Int
    @Binding var selectedTab: Int
    
    
    var body: some View {
        Print(">>>>>> DisplayMeetingGroupsForReportsView body refreshed")
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                if EntityState.sortedEntities != nil {
                    if entityState.currentEntity != nil {
                        Text(entityState.currentEntity!.name!)
                            .font(.system(size: 18, weight: .medium))
                            .padding(.top, 10)
                    }
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
                    Text("No entities created")
                }
            }
            .padding(.leading,20)
            .padding(.trailing,20)

            Divider().frame(height: 2).background(Color(white: 0.85, opacity: 1.0))

            List(presenter.meetingGroups, id: \.self, rowContent:  { meetingGroup in
                MeetingGroupsForReportsListRow(rowContent: meetingGroup)
            })
            // When user changes selected entity
            .onReceive(entityState.$currentEntityIndex, perform:{ newIndex in
                print("------ DisplayMeetingGroupsForReportsView .onReceive $currentEntityIndex")
                if (selectedTab == 2) {
                    if newIndex == nil {
                        DisplayMeetingGroupsForReportsInteractor.initialiseEntities(entityState: entityState)
                    }
                    else {
                    DisplayMeetingGroupsForReportsInteractor.fetchMeetingGroupsOnEntityChange(entityIndex: newIndex!, presenter: presenter, entityState: entityState)
                    }
                }
            })
            .onReceive(entityState.$meetingGroupsHaveChanged, perform: { val in
                print("------ DisplayMeetingGroupsForReportsView .onReceive entityState.$meetingGroupsHaveChanged: \(val)")
                if (selectedTab == 2) && (val == true)   {
                    entityState.meetingGroupsHaveChanged = false
                    DisplayMeetingGroupsForReportsInteractor.fetchMeetingGroups(presenter: presenter, entityState: entityState)
                }
            })
            // Fetch meeting groups when view appears, if not already setup
            .onAppear(perform: {
                print("------ DisplayMeetingGroupsForReportsView .onAppear")
                if selectedTab == 2 {
                    DisplayMeetingGroupsForReportsInteractor.initialiseEntities(entityState: entityState)
                    DisplayMeetingGroupsForReportsInteractor.setSelectedMeetingGroupIndex(idx: nil, entityState: entityState)
                }
            })
            //            // Reset state for when view is recreated
            //            .onDisappear(perform: {
            //                print("DisplayMeetingGroupsView ------ .onDisappear")
            //                setupState.meetingGroupsMasterIsSetup = false
            //                setupState.meetingGroupsDetailIsSetup = false
            //            })
        }
    }
    
    func changeEntity(row: Int) {
        guard let entities = DisplayMeetingGroupsForReportsInteractor.getEntities(entityState: entityState) else {return}
        let selectedEntity = entities[row]
        entityState.currentEntityIndex = selectedEntity.idx
    }
}

struct MeetingGroupsForReportsListRow: View {
    @EnvironmentObject var entityState: EntityState
    @State var selectedMeetingGroupIdx: UUID?
    var rowContent: MeetingGroupForReportsViewModel


    var body: some View {
        HStack {
            Text(rowContent.name)
        }
        .modifier(MasterListRowModifier(isSelected: entityState.currentMeetingGroupIndex != nil ? rowContent.idx == entityState.currentMeetingGroupIndex! : false))
        .contentShape(Rectangle())  
        .onTapGesture {
            // Set local state variable and EntityState's currentMemberIndex
            selectedMeetingGroupIdx = rowContent.idx
            DisplayMeetingGroupsForReportsInteractor.setSelectedMeetingGroupIndex(idx: selectedMeetingGroupIdx!, entityState: entityState)
        }
    }
}

//struct DisplayMeetingGroupsForReportsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplayMeetingGroupsForReportsView()
//            .environmentObject(AppState())
//            .environmentObject(SetupState())
//    }
//}
