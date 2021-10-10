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
            //            .onReceive(entityState.$entityModelChanged, perform: { val in
            //                print("DisplayEntitiesView .onReceive $entityModelChanged val: \(val)")
            //                // Only if entityModelChanged is true.  View is refreshed even if focus is on a different tab.
            //                if val == true {
            //                    let interactor = DisplayEntitiesInteractor()
            //                    interactor.fetchEntities(presenter: self.presenter, entityState: entityState)
            //                    entityState.entityModelChanged = false
            //                }
            //            })
            
            // Called whenever `currentEntityIndex` publishes a change.
            // `currentEntityIndex` changes when .onAppear sets it and
            // when user selects a different row.
            // Each time all entities are fetched.
                .onReceive(entityState.$currentEntityIndex, perform: { val in
                    if selectedTab == 0 {
                        print("------ DisplayEntitiesView .onReceive entityState.$currentEntityIndex \(String(describing: val))")
                        if val == nil {return}
                        let interactor = DisplayEntitiesInteractor()
                        interactor.fetchEntities(presenter: self.presenter, entityState: entityState)
                    }
                })
            
            // When view appears:
            // - set currentEntityIndex
                .onAppear(perform: {
                    print("------ DisplayEntitiesView .onAppear")
                    if selectedTab == 0 {
                        let interactor = DisplayEntitiesInteractor()
                        interactor.setSelectedEntityIndex(idx: nil, entityState: entityState)
                    }
                })
            // Reset state for when view next appears
                .onDisappear(perform: {
                    print("------ DisplayEntitiesView .onDisappear")
                })
            
        }
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
            let interactor = DisplayEntitiesInteractor()
            interactor.setSelectedEntityIndex(idx: selectedEntityIdx, entityState: entityState)
        }
    }
}



//struct DisplayEntitiesView_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplayEntitiesView()
//    }
//}
