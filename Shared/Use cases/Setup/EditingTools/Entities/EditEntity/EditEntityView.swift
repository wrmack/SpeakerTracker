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
    @EnvironmentObject var setupState: SetupState
    @StateObject var presenter = EditEntityPresenter()
    @State var entityName = ""
    @Binding var sheetState: SheetState
    @Binding var selectedMasterRow: Int
    @Binding var saveWasPressed: Bool

   
    init(sheetState: Binding<SheetState>, selectedMasterRow: Binding<Int>, saveWasPressed: Binding<Bool> ) {
        self._sheetState = sheetState
        self._selectedMasterRow = selectedMasterRow
        self._saveWasPressed = saveWasPressed
    }
   
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
               self.sheetState.showSheet = false
                self.saveWasPressed = true
            }})
            .frame(height: 55)
            .disableAutocorrection(true)
            .textFieldStyle(PlainTextFieldStyle())
            .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 0))
            .background(Color.white)
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
            .padding(Edge.Set.trailing,100)
         }
         Spacer()
      }
      .onAppear(perform: {
        fetchSelectedEntity(indexOfEntityToFetch: selectedMasterRow)
      })
      .onReceive(presenter.$viewModel, perform: { viewModel in
          self.entityName = viewModel.name
      })
      .onChange(of: saveWasPressed, perform: { val in
        print("EditEntityView onChange saveWasPressed called val: \(val)")
        if (val == true) && (sheetState.editMode == 1) {
            let indexOfEntityToSave = selectedMasterRow
            self.saveEntity(indexOfEntityToSave: indexOfEntityToSave)
            self.saveWasPressed = false
           }
      })
    }
   
    func fetchSelectedEntity(indexOfEntityToFetch: Int) {
        let interactor = EditEntityInteractor()
        interactor.displaySelectedEntity(entityState: entityState, presenter: presenter, indexOfEntityToFetch: indexOfEntityToFetch) 
    }
    
    func saveEntity(indexOfEntityToSave: Int) {
      print("EditEntityView saveEntity called")
    let interactor = EditEntityInteractor()
    interactor.saveEntityToDisk(entityState: entityState, entityName: entityName, indexOfEntityToSave: indexOfEntityToSave)
   }
}

//struct EditEntityView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditEntityView()
//    }
//}
