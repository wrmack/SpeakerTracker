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
    @ObservedObject var setupSheetState: SetupSheetState
    @StateObject var presenter = EditMemberPresenter()
    @State var memberTitle = ""
    @State var memberFirstName = ""
    @State var memberLastName = ""

    
    var body: some View {
        Print(">>>>>> EditMemberView body refreshed")
        VStack {
            Text("Edit member")
                .padding(.top, 30)
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
                    setupSheetState.showSheet = false
                    self.saveMember()
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
        .padding(.trailing,20)
        .onAppear(perform: {
            fetchSelectedMember()
        })
        .onReceive(presenter.$viewModel, perform: { viewModel in
            self.memberTitle = viewModel.title
            self.memberFirstName = viewModel.firstName
            self.memberLastName = viewModel.lastName
        })
        .onReceive(setupSheetState.$saveWasPressed, perform: { pressed in
            print("------ EditMemberView onReceive saveButtonState.$savePressed called")
            if (pressed == true) && (setupSheetState.editMode == 1) {
                setupSheetState.saveWasPressed = false
                saveMember() }
        })
    }
    
    func fetchSelectedMember() {
        let interactor = EditMemberInteractor()
        interactor.displaySelectedMember(entityState: entityState, presenter: presenter)
    }
    
    func saveMember() {
        print("------ EditMemberView saveMember called")
        let interactor = EditMemberInteractor()
        interactor.saveChangedMemberToStore(entityState: entityState, title: memberTitle, first: memberFirstName, last: memberLastName)
    }
}

struct EditMemberView_Previews: PreviewProvider {
    static var previews: some View {
        EditMemberView(setupSheetState: SetupSheetState())
            .environmentObject(EntityState())
    }
}
