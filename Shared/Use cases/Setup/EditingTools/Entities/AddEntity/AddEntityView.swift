//
//  AddEntity.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 14/08/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine

/**
 Don't need to populate textfields with values.  Just use an Interactor to save final values to model.
 */
struct AddEntityView: View {
    @EnvironmentObject var entityState: EntityState
    @State var entityName = ""
    @Binding var sheetState: SheetState
    @Binding var saveWasPressed: Bool
    
    init(sheetState: Binding<SheetState>, saveWasPressed: Binding<Bool> ) {
        self._sheetState = sheetState
        self._saveWasPressed = saveWasPressed
    }
    
    var body: some View {
        Print(">>>>>> AddEntityView body refreshed")
        VStack {
            Text("Create new entity")
                .padding(Edge.Set.top, 30).padding(Edge.Set.bottom, 30)
                .font(Font.system(size: 30))
            HStack {
                Text("Name")
                    .padding(Edge.Set.trailing, 20).padding(Edge.Set.leading, 50)
                    .font(Font.system(size: 20))
                TextField("eg Some Council, or Some Board", text: $entityName, onCommit: {withAnimation(.easeInOut(duration: EASEINOUT)){
                    self.sheetState.showSheet = false
                    self.saveEntity()
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
        .onChange(of: saveWasPressed, perform: { val in
          print("AddEntityView onChange saveWasPressed called val: \(val)")
          if (val == true) && (sheetState.editMode == 0) {
              self.saveEntity()
              self.saveWasPressed = false
             }
        })
    }
    
    func saveEntity() {
        print("AddEntityView saveEntity called")
        let interactor = AddEntityInteractor()
        interactor.setupInteractor(entityState: entityState)
        interactor.saveEntityToDisk(entityName: entityName)
    }
}


//struct AddEntity_Previews: PreviewProvider {
//    static var previews: some View {
//      AddEntityView(showSheet: .constant(true))
//        .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (4th generation)"))
//        .previewDisplayName("iPad Pro (12.9-inch) (4th generation)")
//        .previewLayout(.fixed(width: 1080, height: 900))
//    }
//}
