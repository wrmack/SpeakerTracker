//
//  AddMemberView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 29/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine

/**
 Don't need to populate textfields with values.  Just use an Interactor to save final values to model.
 */
struct AddMemberView: View {
    @EnvironmentObject var entityState: EntityState
    @EnvironmentObject var setupState: SetupState
    @ObservedObject var saveButtonState: SaveButtonState
    @State var memberTitle = ""
    @State var memberFirstName = ""
    @State var memberLastName = ""
    @Binding var sheetState: SheetState
    
    
    init(sheetState: Binding<SheetState>, saveButtonState: SaveButtonState ) {
        self._sheetState = sheetState
        self.saveButtonState = saveButtonState
    }
    
    var body: some View {
        Print(">>>>>> AddMemberView body refreshed")
        VStack {
            Text("Create new member for")
                .padding(Edge.Set.top, 0).padding(Edge.Set.bottom, 0)
                .font(Font.system(size: 30))
            Text(entityState.currentEntity!.name!)
                .padding(Edge.Set.top, 0).padding(Edge.Set.bottom, 30)
                .font(Font.system(size: 30))
            HStack {
                Text("Title")
                    .frame(width: 120, height: 100, alignment: .trailing)
                    .padding(Edge.Set.trailing, 30)
                    .font(Font.system(size: 20))
                TextField("eg Councillor", text: $memberTitle, onCommit: {withAnimation(.easeInOut(duration: EASEINOUT)){
                    self.sheetState.showSheet = false
                    self.saveMember()
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
            HStack {
                Text("First name")
                    .frame(width: 120, height: 100, alignment: .trailing)
                    .padding(Edge.Set.trailing, 30)
                    .font(Font.system(size: 20))
                TextField("eg John", text: $memberFirstName, onCommit: {withAnimation(.easeInOut(duration: EASEINOUT)){
                    self.sheetState.showSheet = false
                    self.saveMember()
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
            HStack {
                Text("Last name")
                    .frame(width: 120, height: 100, alignment: .trailing)
                    .padding(Edge.Set.trailing, 30)
                    .font(Font.system(size: 20))
                TextField("eg Smith", text: $memberLastName, onCommit: {withAnimation(.easeInOut(duration: EASEINOUT)){
                    self.sheetState.showSheet = false
                    self.saveMember()
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
        .onReceive(self.saveButtonState.$savePressed, perform: { pressed in
            print("AddMemberView .onReceive saveButtonState.$savePressed")
            if (pressed == true) && (sheetState.editMode == 0) {
                print("------ .onReceive")
                self.saveButtonState.savePressed = false
                self.saveMember()
            }
        })
    }
    
    
    func saveMember() {
        print("AddMemberView saveMember called")
        let interactor = AddMemberInteractor()
        interactor.saveMemberToEntity(entityState: entityState, setupState: setupState, title: memberTitle, first: memberFirstName, last: memberLastName)
    }
    
}

//struct AddMemberView_Previews: PreviewProvider {
//    static var buttState = SaveButtonState()
//    @State static var sheetState = SheetState()
//
//    static var previews: some View {
//        AddMemberView(sheetState: $sheetState, saveButtonState: buttState)
//        .previewDevice("iPad Pro (12.9-inch) (4th generation)")
//        .previewDisplayName("iPad Pro (12.9-inch)")
//        .previewLayout(.fixed(width: 1322, height: 1024))
//        .environmentObject(AppState())
//        .environmentObject(SetupState())
//    }
//}
