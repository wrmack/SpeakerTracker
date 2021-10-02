//
//  DisplayEntitiesView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 18/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine

/*
 DisplayEntitiesView
 ===================
 
 View for displaying entities as a list.
 
 Environment objects:
 - EntityState
 - ?
 
 Observed objects:
 - DisplayEntitiesPresenter is instantiated as a StateObject so that there is only one associated with the view
 - it publishes changes to its entityNames property causing DisplayEntitiesView to refresh whenever entityNames changes
 
 Modifiers:
 - ??
 
 */


struct DisplayEntitiesView: View {
    @EnvironmentObject var entityState: EntityState
    @StateObject var presenter = DisplayEntitiesPresenter()
    @Binding var selectedTab: Int
    @Binding var selectedMasterRow: Int
   
    
   var body: some View {
      Print(">>>>>> DisplayEntitiesView body refreshed")
      VStack {
         List(presenter.entityNames, id: \.self, rowContent:  { entityName in
            EntityListRow(rowContent: entityName, selectedMasterRow: $selectedMasterRow)
         })
         .onReceive(entityState.$entityModelChanged, perform: { val in
            print("DisplayEntitiesView .onReceive $entityModelChanged val: \(val)")
            // Only if entityModelChanged is true.  View is refreshed even if focus is on a different tab.
            if val == true {
                let interactor = DisplayEntitiesInteractor()
                interactor.fetchEntities(presenter: self.presenter, entityState: entityState)
                entityState.entityModelChanged = false
            }
         })
         
         .onReceive(self.entityState.$currentEntity, perform: { _ in
            print("DisplayEntitiesView .onReceive entityState.$currentEntity")
         })
         
         // Fetch entities when view appears
         .onAppear(perform: {
            print("------ DisplayEntitiesView .onAppear")
            if selectedTab == 0 && entityState.entities.count > 0 {
               print("****** fetching entities on view appear")
                entityState.currentEntity = entityState.sortedEntities[0]
                let interactor = DisplayEntitiesInteractor()
                interactor.fetchEntities(presenter: self.presenter, entityState: entityState)
            }
         })
         // Reset state for when view next appears
         .onDisappear(perform: {
            print("------ DisplayEntitiesView .onDisappear")
         })

      }
   }
}

/*
 EntityListRow
 =============
 
 View for displaying a row in the list of entities.
 
 All properties are injected.
 
 If a row it tapped, SetupState selectedRow property is changed.
 Could use a simple binding to State selectedIndex property above and change that directly
 but DisplaySelectedEntityView is listening for a change in SetupState so
 need to change SetupState.
 

 
 */

struct EntityListRow: View {
    var rowContent: EntityName
    @Binding var selectedMasterRow: Int
    
    var body: some View {
        Print(">>>>>> EntityListRow body called -- \(rowContent.name)")
        HStack {
            Text(rowContent.name)
        }
        .modifier(MasterListRowModifier(isSelected: rowContent.idx == selectedMasterRow))
        .onTapGesture {
            selectedMasterRow = rowContent.idx
        }
    }
}



//struct DisplayEntitiesView_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplayEntitiesView()
//    }
//}
