//
//  DeleteMemberView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 11/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import SwiftUI

/**
 Need to populate textfields with initial values representing the selected member.
 Do this using a Presenter to publish a view model.
 */
struct DeleteMemberView: View {
    @EnvironmentObject var entityState: EntityState
    @ObservedObject var setupSheetState: SetupSheetState
    @StateObject var presenter = DeleteMemberPresenter()
    @State var memberTitle = ""
    @State var memberFirstName = ""
    @State var memberLastName = ""

    
    var body: some View {
       Print(">>>>>> DeleteMemberView body refreshed")
       VStack {
          Text("This will delete the member below!")
             .padding(Edge.Set.top, 30).padding(Edge.Set.bottom, 30)
             .font(Font.system(size: 30))
        HStack {
           Text("Title")
              .frame(width: 120, height: 100, alignment: .trailing)
              .padding(Edge.Set.trailing, 30)
              .font(Font.system(size: 20))
           TextField("eg Councillor", text: $memberTitle)
            .disabled(true)
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
            .disabled(true)
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
           TextField("eg Smith", text: $memberLastName)
            .disabled(true)
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
       .onAppear(perform: {
           fetchSelectedMember()
       })
       .onReceive(presenter.$viewModel, perform: { viewModel in
           self.memberTitle = viewModel.title
           self.memberFirstName = viewModel.firstName
           self.memberLastName = viewModel.lastName
       })
       .onReceive(setupSheetState.$saveWasPressed, perform: { pressed in
          print("DeleteMemberView onReceive saveButtonState.$savePressed = \(pressed)")
          if (pressed == true) && (setupSheetState.editMode == 2) {
              setupSheetState.saveWasPressed = false
            self.deleteMember() }
       })
    }
    
    func fetchSelectedMember() {
        let interactor = DeleteMemberInteractor()
        interactor.displaySelectedMember(entityState: entityState, presenter: presenter)
    }
    
    func deleteMember() {
        let interactor = DeleteMemberInteractor()
        interactor.deleteSelectedMemberFromEntity(entityState: entityState)
    }
}

//struct DeleteMemberView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeleteMemberView()
//    }
//}
