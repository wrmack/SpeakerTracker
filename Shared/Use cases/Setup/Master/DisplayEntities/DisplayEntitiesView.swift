//
//  DisplayEntitiesView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 18/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine


/// A view to display entities as a list.
///
/// `DisplayEntitiesView` works with `DisplayEntitiesInteractor` and `DisplayEntitiesPresenter`.
///
/// `DisplayEntitiesInteractor` is responsible for interacting with the data model.
///
/// `DisplayEntitiesPresenter` is responsible for formatting data it receives from `DisplayEntitiesInteractor`
/// so that it is ready for presentation by `DisplayEntitiesView`. It is initialised as a `@StateObject`
/// to ensure there is only one instance and it notifies new content through a publisher.
///
/// This pattern is based on the VIP (View-Interactor-Presenter) and VMVM (View-Model-ViewModel) patterns.
struct DisplayEntitiesView: View {
    @EnvironmentObject var entityState: EntityState
    @StateObject var presenter = DisplayEntitiesPresenter()
    @Binding var selectedTab: Int
    
    
    var body: some View {
        Print(">>>>>> DisplayEntitiesView body refreshed")
        VStack {
            List(presenter.entities, id: \.self, rowContent:  { entity in
                EntityListRow(rowContent: entity)
            })
                .listStyle(PlainListStyle())
                .onChange(of: entityState.entitiesHaveChanged, perform: { val in
                    print("------ DisplayEntitiesView .onChange entityState.entitiesHaveChanged: \(val)")
                    if (selectedTab == 0) && (val == true)   {
                        entityState.entitiesHaveChanged = false
                        DisplayEntitiesInteractor.fetchEntities(presenter: presenter)
                    }
                })
            // Called whenever `currentEntityIndex` changes.
            // - when user selects a different row.
            //
                .onChange(of: entityState.currentEntityIndex, perform: { newIndex in
                    if selectedTab == 0 {
                        print("------ DisplayEntitiesView .onChange entityState.currentEntityIndex \(String(describing: newIndex))")
                        if newIndex == nil {return}
                        DisplayEntitiesInteractor.fetchEntities(presenter: self.presenter)
                    }
                })
            
            // When view appears:
            // - set currentEntityIndex
            // - fetch entities
                .onAppear(perform: {
                    print("------ DisplayEntitiesView .onAppear")
                    if selectedTab == 0 {
                        DisplayEntitiesInteractor.setCurrentEntityIndex(idx: nil, entityState: entityState)
                        DisplayEntitiesInteractor.fetchEntities(presenter: self.presenter)
                    }
                })
            // Reset state for when view next appears
                .onDisappear(perform: {
                    print("------ DisplayEntitiesView .onDisappear")
                })
            
        }
//        .background(Color.primary)
    }
}



/// View for displaying a row in the list of entities.
///
/// If a row it tapped, the local `selectedEntityIdx` is changed
/// and EntityState's `currentEntityIndex` property is set
/// to the selected entity
struct EntityListRow: View {
    @EnvironmentObject var entityState: EntityState
    //    @State var selectedEntityIdx: UUID?
    var rowContent: EntityViewModel
    
    var body: some View {
        Print(">>>>>> EntityListRow body called -- \(rowContent.name)")
        HStack {
            Text(rowContent.name)
        }
        .modifier(MasterListRowModifier(isSelected: entityState.currentEntityIndex != nil ? rowContent.idx == entityState.currentEntityIndex! : false))
        .contentShape(Rectangle())
        .onTapGesture {
            // Set local state variable and EntityState's currentEntityIndex
            let selectedEntityIdx = rowContent.idx
            DisplayEntitiesInteractor.setCurrentEntityIndex(idx: selectedEntityIdx, entityState: entityState)
        }
    }
}



//struct DisplayEntitiesView_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplayEntitiesView()
//    }
//}
