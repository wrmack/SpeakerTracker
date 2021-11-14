//
//  DisplayMembersView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 29/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine

/// View for displaying members as a list for a selected entity.
///
/// `DisplayMembersView` works with `DisplayMembersInteractor` and `DisplayMembersPresenter`.
///
/// `DisplayMembersInteractor` is responsible for interacting with the data model.
///
/// `DisplayMembersPresenter` is responsible for formatting data it receives from `DisplayMembersInteractor`
/// so that it is ready for presentation by `DisplayMembersView`. It is initialised as a `@StateObject`
/// to ensure there is only one instance and it notifies new content through a publisher.
///
/// This pattern is based on the VIP (View-Interactor-Presenter) and VMVM (View-Model-ViewModel) patterns.
struct DisplayMembersView: View {
    @EnvironmentObject var entityState: EntityState
    @StateObject var presenter = DisplayMembersPresenter()
    @Binding var selectedTab: Int
    
    
    var body: some View {
        Print(">>>>>> DisplayMembersView body refreshed")
        VStack(alignment: .leading) {
            
            // Menu to select entity
            VStack(alignment: .leading) {
                if entityState.currentEntity != nil {
                    Text(entityState.currentEntity!.name!)
                        .font(.system(size: 18, weight: .medium))
                        .padding(.top,10)

                    HStack {
                        Menu {
                            ForEach(EntityState.sortedEntities!.indices, id: \.self) { idx in
                                Button(EntityState.sortedEntities![idx].name!, action: { changeEntity(row: idx)})
                            }
                        } label: {
                            Text("Change entity")
                        }

                    }
                }
                else {
                    Text("Create an entity first").opacity(0.5)
                }
            }
            .padding(.leading,20)
            .padding(.trailing,20)

            
            Divider().frame(height: 2).background(Color(white: 0.85, opacity: 1.0))
            
            // Display members
            List(presenter.members, id: \.self, rowContent:  { member in
                MemberListRow(rowContent: member)
            })
                .listStyle(.insetGrouped)
            
            // When user changes selected entity, reset currentMemberIndex
                .onChange(of: entityState.currentEntityIndex, perform: { newIndex in
                print("------ DisplayMembersView .onChange entityState.currentEntityIndex: \(String(describing: newIndex))")
                if (selectedTab == 1)   {
                    if newIndex == nil {
                        DisplayMembersInteractor.setCurrentEntityIndex(entityState: entityState)
                    }
                    DisplayMembersInteractor.fetchMembersOnEntityChange(entityIndex: newIndex!, presenter: presenter, entityState: entityState)
                }
            })
                .onChange(of: entityState.membersHaveChanged, perform: { val in
                print("------ DisplayMembersView .onChange entityState.membersHaveChanged: \(val)")
                if (selectedTab == 1) && (val == true)   {
                    entityState.membersHaveChanged = false
                    DisplayMembersInteractor.fetchMembers(presenter: presenter, entityState: entityState)
                }
            })

            // When view appears:
            // - set currentEntityIndex
            // - set currentMemberIndex
            // - fetch members
            .onAppear(perform: {
                print("------ DisplayMembersView .onAppear")
                if selectedTab == 1 {
                    DisplayMembersInteractor.setCurrentEntityIndex(entityState: entityState)
                    DisplayMembersInteractor.setCurrentMemberIndex(idx: nil, entityState: entityState)
                    DisplayMembersInteractor.fetchMembers(presenter: presenter, entityState: entityState)
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
        guard let entities = DisplayMembersInteractor.getEntities() else {return}
        let selectedEntity = entities[row]
        entityState.currentEntityIndex = selectedEntity.idx
    }
}

/// View for displaying a row in the list of members.
///
/// If a row it tapped, the local `selectedMemberIdx` is changed
/// and EntityState's `currentMemberIndex` property is set
/// to the selected member.

struct MemberListRow: View {
    @EnvironmentObject var entityState: EntityState
    @State var selectedMemberIdx: UUID?
    var rowContent: MemberViewModel
    
    var body: some View {
        Print(">>>>>> MemberListRow body refreshed -- \(rowContent.name)")

        HStack {
            Text(rowContent.name)
        }
        .modifier(MasterListRowModifier(isSelected: entityState.currentMemberIndex != nil ? rowContent.idx == entityState.currentMemberIndex! : false))
        .contentShape(Rectangle())  
        .onTapGesture {
            // Set local state variable and EntityState's currentMemberIndex
            selectedMemberIdx = rowContent.idx
            DisplayMembersInteractor.setCurrentMemberIndex(idx: selectedMemberIdx!, entityState: entityState)
        }
    }
}




struct DisplayMembersView_Previews: PreviewProvider {
    @State static var tab = 1


    static var previews: some View {
      Group {
        DisplayMembersView(selectedTab: $tab)
            .environmentObject(EntityState())
//        MemberListRow(rowContent: MemberViewModel(name: "Adam", idx: UUID()))
//              .environmentObject(EntityState())
      }
    }
       
}
