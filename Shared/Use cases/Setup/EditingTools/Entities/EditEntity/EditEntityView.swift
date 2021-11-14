//
//  EditEntityView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 6/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine

/**
 Need to populate textfields with initial values representing the selected member.
 Do this using a Presenter to publish a view model.
 */
struct EditEntityView: View {
    @EnvironmentObject var entityState: EntityState
    @ObservedObject var setupSheetState: SetupSheetState
    @StateObject var presenter = EditEntityPresenter()
    @State var entityName = ""
    
    
    var body: some View {
        Print(">>>>>> EditEntityView body refreshed")
        VStack {
            Text("Edit entity name")
                .padding(Edge.Set.top, 30).padding(Edge.Set.bottom, 30)
                .font(Font.system(size: 30))
            HStack {
                Text("Name")
                    .padding(Edge.Set.trailing, 20).padding(Edge.Set.leading, 50)
                    .font(Font.system(size: 20))
                TextField("eg Some Council, or Some Board", text: $entityName, onCommit: {withAnimation(.easeInOut(duration: EASEINOUT)){
                    setupSheetState.showSheet = false
                    saveEntity()
                }})
                    .font(Font.system(size: 18))
                    .textFieldStyle(MyTextFieldStyle())
                    .padding(.trailing,100)
                
            }
            Spacer()
        }
        .onAppear(perform: {
            fetchSelectedEntity()
        })
        .onReceive(presenter.$viewModel, perform: { viewModel in
            self.entityName = viewModel.name
        })
        .onReceive(setupSheetState.$saveWasPressed, perform: { val in
            print("------ EditEntityView onReceive saveWasPressed called val: \(val)")
            if (val == true) && (setupSheetState.editMode == 1) {
                setupSheetState.saveWasPressed = false
                saveEntity()
            }
        })
    }
    
    func fetchSelectedEntity() {
        EditEntityInteractor.displaySelectedEntity(entityState: entityState, presenter: presenter)
    }
    
    func saveEntity() {
        print("------ EditEntityView saveEntity called")
        EditEntityInteractor.saveChangedEntityToStore(entityState: entityState, entityName: entityName)
    }
}

//struct EditEntityView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditEntityView()
//    }
//}
