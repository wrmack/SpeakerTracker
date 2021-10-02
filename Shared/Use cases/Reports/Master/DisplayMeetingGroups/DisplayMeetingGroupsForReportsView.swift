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
    @EnvironmentObject var setupState: SetupState
    @StateObject var presenter = DisplayMeetingGroupsForReportsPresenter()
    @State var selectedIndex = 0
    @Binding var selectedMasterRow: Int
    //    @Binding var selectedTab: Int
    
    
    var body: some View {
        Print(">>>>>> DisplayMeetingGroupsForReportsView body refreshed")
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                if entityState.sortedEntities != nil {
                    HStack {
                        Text("Meeting groups for entity:")
                        Spacer()
                        Menu {
                            ForEach(entityState.entities.indices, id: \.self) { idx in
                                Button(entityState.entities[idx].name!, action: { changeEntity(row: idx)})
                            }
                        } label: {
                            Text("Change")
                        }.padding(.trailing, 20)
                    }
                    if entityState.currentEntity != nil {
                        Text(entityState.currentEntity!.name!)
                            .font(.system(size: 18, weight: .medium))
                    }
                }
                else {
                    Text("No entities created")
                }
            }.alignmentGuide(HorizontalAlignment.leading) {_ in -10 }
            
            Divider().frame(height: 2).background(Color(white: 0.85, opacity: 1.0))
            
            List(presenter.meetingGroupNames, id: \.self, rowContent:  { meetingGroupName in
                MeetingGroupsForReportsListRow(rowContent: meetingGroupName, setupState: setupState, selectedMasterRow: $selectedMasterRow)
            })
            // When user selects a different row
            .onChange(of: selectedMasterRow, perform: {row in
                print("DisplayMeetingGroupsView .onChange $selectedMasterRow")
//                if (self.setupState.meetingGroupsMasterIsSetup == true) {
                    print("------ onReceive")
                    self.selectedIndex = row
//                }
            })
            //            // When user changes selected entity
            //            .onReceive(self.setupState.objectWillChange, perform: { entity in
            //                print("DisplayMeetingGroupsView .onRecieve detailState.objectWillChange")
            //                if (selectedTab == 2) {
            //                   print("------ onReceive: Calling interactor")
            //                    let interactor = DisplayMeetingGroupsInteractor(presenter: self.presenter)
            //                    interactor.setupInteractorState(setupState: setupState)
            //                   interactor.fetchMeetingGroupsForEntity(entity: entity)
            //                }
            //            })
            //            // Fetch meeting groups when tab is selected, if not already setup
            //            .onChange(of: selectedTab, perform: { tab in
            //               print("----- DisplayMeetingGroupsView .onChange SelectedTab changed to \(tab)")
            //               if tab == 2 && self.setupState.meetingGroupsMasterIsSetup == false && entityState.entities.count > 0 {
            //                  print("****** fetching members on change of tab")
            //                  setupState.selectedEntity = entityState.entities[0]
            //                  let interactor = DisplayMeetingGroupsInteractor(presenter: self.presenter)
            //                  interactor.setupInteractorState(setupState: setupState)
            //                  interactor.fetchMeetingGroups()
            //               }
            //            })
            // Fetch meeting groups when view appears, if not already setup
            .onAppear(perform: {
                print("------ DisplayMeetingGroupsForReportsView .onAppear")
                //               if selectedTab == 2 && self.setupState.membersMasterIsSetup == false && entityState.entities.count > 0 {
                if entityState.entities.count > 0 {
                    print("****** fetching members on view appear")
                    let selectedEntity = entityState.entities[0]
                    entityState.currentEntity = selectedEntity
                    let interactor = DisplayMeetingGroupsForReportsInteractor()
                    interactor.fetchMeetingGroups(entity: selectedEntity, presenter: presenter)
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
        print("Changed entity: row \(row) selected")
        let entities = entityState.sortedEntities
        let selectedEntity = entities[row]
        setupState.meetingGroupsMasterIsSetup = false
        entityState.currentEntity = selectedEntity
    }
}

struct MeetingGroupsForReportsListRow: View {
    var rowContent: MeetingGroupName
    var setupState: SetupState
//    var selectedIndex: Int
    @Binding var selectedMasterRow: Int
    
    var body: some View {
        HStack {
            Text(rowContent.name)
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .background(rowContent.idx == selectedMasterRow ? Color.init(white: 0.85) :  Color.white)
        .onTapGesture {
            selectedMasterRow = rowContent.idx
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
