//
//  DisplayMembersView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 29/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine

struct DisplayMembersView: View {
    @EnvironmentObject var entityState: EntityState
    @StateObject var presenter = DisplayMembersPresenter()
    @Binding var selectedTab: Int
    @Binding var selectedMasterRow: Int
    
    
    var body: some View {
        Print(">>>>>> DisplayMembersView body refreshed")
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                if entityState.currentEntity != nil {
                    Text(entityState.currentEntity!.name!)
                        .font(.system(size: 18, weight: .medium))
                        .padding(.top,10)
                }
                HStack {
                    Menu {
                        ForEach(entityState.sortedEntities.indices, id: \.self) { idx in
                            Button(entityState.sortedEntities[idx].name!, action: { changeEntity(row: idx)})
                        }
                    } label: {
                        Text("Change entity")
                    }.padding(.trailing, 20)
                    Spacer()
                }

            }.alignmentGuide(HorizontalAlignment.leading) {_ in -10 }
            
            Divider().frame(height: 2).background(Color(white: 0.85, opacity: 1.0))
            
            List(presenter.memberNames, id: \.self, rowContent:  { memberName in
                Print("DisplayMembersView list closure")
                MemberListRow(rowContent: memberName, selectedMasterRow: $selectedMasterRow)
            })
            
            // When user changes selected entity
            .onReceive(entityState.$currentEntity, perform: { entity in
                if entity == nil {return}
                print("DisplayMembersView .onReceive entityState.$currentEntity")
                if (selectedTab == 1)   {
                    print("------ onReceive: Calling interactor")
                    let interactor = DisplayMembersInteractor()
                    interactor.fetchMembers(entity: entity!, presenter: presenter)
                }
            })
            // Fetch members when view appears, if not already setup
            .onAppear(perform: {
                print("------ DisplayMembersView .onAppear")
                if selectedTab == 1 && entityState.entities.count > 0 {
                    print("****** fetching members on view appear")
                    entityState.currentEntity = entityState.sortedEntities[0]
                    let interactor = DisplayMembersInteractor()
                    interactor.fetchMembers(entity: entityState.currentEntity!, presenter: presenter) 
                }
            })
            // Reset state for when view is recreated
            .onDisappear(perform: {
                print("------ DisplayMembersView .onDisappear")
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

/*
 MemberListRow
 =============
 
 View for displaying a row in the list of members.
 
 State variable:
 - tracks whether this row is selected, which determines the background color
 
 Observed object:
 - DisplayMembersState object: the view passes this to the row; if the row is tapped,
 the selectedRow property of DisplayEntitiesState is updated
 
 Modifiers:
 - onRecieve: listens for changes to the DisplayEntitiesState selectedRow property and
 modifies the State variable selected accordingly
 
 */

struct MemberListRow: View {
    var rowContent: MemberName
    @Binding var selectedMasterRow: Int
    
    var body: some View {
        Print(">>>>>> MemberListRow body refreshed -- \(rowContent.name)")
        Print("selectedMasterRow: \(selectedMasterRow)")
        HStack {
            Text(rowContent.name)
        }
        .modifier(MasterListRowModifier(isSelected: rowContent.idx == selectedMasterRow))
        .onTapGesture {
            selectedMasterRow = rowContent.idx
        }
    }
}




struct DisplayMembersView_Previews: PreviewProvider {
    @State static var tab = 1
    @State static var row = 0
    
    static var previews: some View {
      Group {
        DisplayMembersView(selectedTab: $tab, selectedMasterRow: $row)
            .environmentObject(EntityState())
        MemberListRow(rowContent: MemberName(name: "Adam", idx: 0), selectedMasterRow: $row)
      }
    }
}
