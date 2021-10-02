//
//  DisplayMeetingGroupsView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 10/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine

struct DisplayMeetingGroupsView: View {
    @EnvironmentObject var entityState: EntityState
    @StateObject var presenter = DisplayMeetingGroupsPresenter()
    @Binding var selectedTab: Int
    @Binding var selectedMasterRow: Int
    
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
            
            Divider().frame(height: 2).background(Color(white: 0.85, opacity: 1.0))
            
            List(presenter.meetingGroupNames, id: \.self, rowContent:  { meetingGroupName in
                MeetingGroupsListRow(rowContent: meetingGroupName, selectedMasterRow: $selectedMasterRow)
            })
            // When user changes selected entity
            .onReceive(entityState.$currentEntity, perform:{ entity in
                print("DisplayMeetingGroupsView .onRecieve detailState.objectWillChange")
                if (selectedTab == 2) {
                    print("------ onReceive: Calling interactor")
                    let interactor = DisplayMeetingGroupsInteractor()
                    interactor.fetchMeetingGroups(entity: entity!, presenter: presenter)
                }
            })
            // Fetch meeting groups when view appears, if not already setup
            .onAppear(perform: {
                print("------ DisplayMeetingGroupsView .onAppear")
                if selectedTab == 2 && entityState.entities.count > 0 {
                    print("****** fetching members on view appear")
                    entityState.currentEntity = entityState.entities[0]
                    let interactor = DisplayMeetingGroupsInteractor()
                    interactor.fetchMeetingGroups(entity: entityState.currentEntity!, presenter: presenter)
                }
            })
            // Reset state for when view is recreated
            .onDisappear(perform: {
                print("DisplayMeetingGroupsView ------ .onDisappear")
            })
        }
    }
    
    func changeEntity(row: Int) {
        print("Changed entity: row \(row) selected")
        let entities = entityState.sortedEntities
        let selectedEntity = entities[row]
        entityState.currentEntity = selectedEntity
    }
}

struct MeetingGroupsListRow: View {
    var rowContent: MeetingGroupName
    @Binding var selectedMasterRow: Int
    
    var body: some View {
        HStack {
            Text(rowContent.name)
        }
        .modifier(MasterListRowModifier(isSelected: rowContent.idx == selectedMasterRow))
        .onTapGesture {
            selectedMasterRow = rowContent.idx
        }
    }
}



//struct DisplayMeetingGroupsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplayMeetingGroupsView()
//    }
//}
