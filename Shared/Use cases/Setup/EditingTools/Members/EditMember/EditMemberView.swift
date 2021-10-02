//
//  EditMemberView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 11/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine

/**
 Need to populate textfields with initial values representing the selected member.
 Do this using a Presenter to publish a view model.
 */
struct EditMemberView: View {
    @EnvironmentObject var entityState: EntityState
    @EnvironmentObject var setupState: SetupState
    @StateObject var presenter = EditMemberPresenter()
    @ObservedObject var saveButtonState: SaveButtonState
    @State var memberTitle = ""
    @State var memberFirstName = ""
    @State var memberLastName = ""
    @Binding var sheetState: SheetState
    @Binding var selectedMasterRow: Int
    
    
    init(sheetState: Binding<SheetState>, saveButtonState: SaveButtonState, selectedMasterRow: Binding<Int> ) {
        self._sheetState = sheetState
        self.saveButtonState = saveButtonState
        self._selectedMasterRow = selectedMasterRow
    }
    
    var body: some View {
        Print(">>>>>> EditMemberView body refreshed")
        VStack {
            Text("Edit member")
                .padding(Edge.Set.top, 30).padding(Edge.Set.bottom, 30)
                .font(Font.system(size: 30))
            HStack {
                Text("Title")
                    .frame(width: 120, height: 100, alignment: .trailing)
                    .padding(Edge.Set.trailing, 30)
                    .font(Font.system(size: 20))
                TextField("eg Councillor", text: $memberTitle, onCommit: {withAnimation(.easeInOut(duration:  EASEINOUT)){
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
        .onAppear(perform: {
            fetchSelectedMember()
        })
        .onReceive(presenter.$viewModel, perform: { viewModel in
            self.memberTitle = viewModel.title
            self.memberFirstName = viewModel.firstName
            self.memberLastName = viewModel.lastName
        })
        .onReceive(self.saveButtonState.$savePressed, perform: { pressed in
            print("EditMemberView onReceive saveButtonState.$savePressed called")
            if (pressed == true) && (sheetState.editMode == 1) {
                self.saveButtonState.savePressed = false
                self.saveMember() }
        })
    }
    
    func fetchSelectedMember() {
        let interactor = EditMemberInteractor()
        interactor.displaySelectedMember(entityState: entityState, presenter: presenter, selectedMasterRow: selectedMasterRow)
    }
    
    func saveMember() {
        print("EditMemberView saveMember called")
        let interactor = EditMemberInteractor()
        interactor.saveMemberToEntity(entityState: entityState, setupState: setupState, title: memberTitle, first: memberFirstName, last: memberLastName, selectedMasterRow: selectedMasterRow)
    }
}

//struct EditMemberView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditMemberView()
//    }
//}
