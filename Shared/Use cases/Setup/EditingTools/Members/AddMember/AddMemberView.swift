//
//  AddMemberView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 29/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine

/// A view providing textfields for adding a new member.
///
/// `AddMemberView` works with `AddMemberInteractor`.
///
/// `AddMemberInteractor` is responsible for interacting with the data model.
///
/// `sheetState` is bound to ContentView
///
/// `saveWasPressed` is bound to `SetupSheetView` which has the Save button.
struct AddMemberView: View {
    @EnvironmentObject var entityState: EntityState
    @State var memberTitle = ""
    @State var memberFirstName = ""
    @State var memberLastName = ""
    @ObservedObject var setupSheetState: SetupSheetState
    
    
    
    var body: some View {
        Print(">>>>>> AddMemberView body refreshed")
        VStack {
            Text("Add new member for")
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

                TextField("eg Councillor", text: $memberTitle)
                    .frame(height: 55)
                    .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .padding(Edge.Set.trailing,100)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(Font.system(size: 18))
                    .disableAutocorrection(true)

            }
            HStack {
                Text("First name")
                    .frame(width: 120, height: 100, alignment: .trailing)
                    .padding(Edge.Set.trailing, 30)
                    .font(Font.system(size: 20))

                TextField("eg John", text: $memberFirstName)
                    .frame(height: 55)
                    .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .padding(Edge.Set.trailing,100)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(Font.system(size: 18))
                    .disableAutocorrection(true)
            }
            HStack {
                Text("Last name")
                    .frame(width: 120, height: 100, alignment: .trailing)
                    .padding(Edge.Set.trailing, 30)
                    .font(Font.system(size: 20))
                TextField("eg Smith", text: $memberLastName, onCommit: {withAnimation(.easeInOut(duration: EASEINOUT)){
                    self.setupSheetState.showSheet = false
                    self.saveNewMember()
                }})
                    .frame(height: 55)
                    .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .padding(Edge.Set.trailing,100)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(Font.system(size: 18))
                    .disableAutocorrection(true)
            }
            Spacer()
        }
        .onReceive(setupSheetState.$saveWasPressed, perform: { pressed in
            print("------ AddMemberView .onReceive saveButtonState.$savePressed")
            if (pressed == true) && (setupSheetState.editMode == 0) {
                setupSheetState.saveWasPressed = false
                self.saveNewMember()
            }
        })
    }
    
    
    func saveNewMember() {
        print("------ AddMemberView saveMember called")
        AddMemberInteractor.saveNewMemberToEntity(entityState: entityState, title: memberTitle, first: memberFirstName, last: memberLastName)
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
