//
//  AddEntity.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 14/08/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine

/// A view providing a textfield for adding a new entity.
///
/// `AddEntityView` works with `AddEntityInteractor`.
///
/// `AddEntityInteractor` is responsible for interacting with the data model.
///
/// `sheetState` is bound to ContentView
///
/// `saveWasPressed` is bound to `SetupSheetView` which has the Save button.
struct AddEntityView: View {
    @EnvironmentObject var entityState: EntityState
    @State var entityName = ""
    @ObservedObject var setupSheetState: SetupSheetState
    
    var body: some View {
        Print(">>>>>> AddEntityView body refreshed")
        VStack {
            Text("Add a new entity")
                .padding(Edge.Set.top, 30).padding(Edge.Set.bottom, 30)
                .font(Font.system(size: 24))
            HStack {
                Text("Name")
                    .padding(Edge.Set.trailing, 20).padding(Edge.Set.leading, 50)
                    .font(Font.system(size: 20))
                TextField("eg Some Council, or Some Board", text: $entityName, onCommit: {withAnimation(.easeInOut(duration: EASEINOUT)){
                    self.setupSheetState.showSheet = false
                    self.saveNewEntity()
                }})
                    .font(Font.system(size: 18))
                    .textFieldStyle(MyTextFieldStyle())
                    .padding(.trailing,100)
            }
            Spacer()
        }
        .onChange(of: setupSheetState.saveWasPressed, perform: { val in
          print("------ AddEntityView onChange saveWasPressed called val: \(val)")
          if (val == true) && (setupSheetState.editMode == 0) {
              self.saveNewEntity()
              setupSheetState.saveWasPressed = false
             }
        })
    }
    
    /// Sends entity name to interactor to save to data store
    func saveNewEntity() {
        print("------ AddEntityView saveEntity called")
        AddEntityInteractor.saveNewEntityToStore(entityName: entityName, entityState: entityState)
    }
}


//struct AddEntity_Previews: PreviewProvider {
//    static var previews: some View {
//        AddEntityView(setupSheetState: .constant(SetupSheetState()))
//        .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (4th generation)"))
//        .previewDisplayName("iPad Pro (12.9-inch) (4th generation)")
//        .previewLayout(.fixed(width: 1080, height: 900))
//    }
//}
