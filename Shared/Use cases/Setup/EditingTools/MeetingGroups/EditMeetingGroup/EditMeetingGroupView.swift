//
//  EditMeetingGroupView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 14/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import SwiftUI

struct EditMeetingGroupView: View {
    @EnvironmentObject var entityState: EntityState
    @EnvironmentObject var setupState: SetupState
    @StateObject var presenter = EditMeetingGroupPresenter()
    @ObservedObject var saveButtonState: SaveButtonState
    @State var meetingGroupName = ""
    @State var memberNames = ""
    @State var members = Set<Member>()
    @Binding var sheetState: SheetState
    @Binding var presentMembersSheet: Bool
    @Binding var selectedMasterRow: Int
    
    init(presentMembersSheet: Binding<Bool>, sheetState: Binding<SheetState>, saveButtonState: SaveButtonState, selectedMasterRow: Binding<Int> ) {
        self._presentMembersSheet = presentMembersSheet
        self._sheetState = sheetState
        self.saveButtonState = saveButtonState
        self._selectedMasterRow = selectedMasterRow
    }
    
    var body: some View {
        Print(">>>>>> EditMemberView body refreshed")
        VStack {
            Text("Edit meeting group")
                .padding(Edge.Set.top, 30).padding(Edge.Set.bottom, 30)
                .font(Font.system(size: 30))
            HStack {
                Text("Name")
                    .frame(width: 120, height: 100, alignment: .trailing)
                    .padding(Edge.Set.trailing, 30)
                    .font(Font.system(size: 20))
                TextField("eg Some Committee", text: $meetingGroupName, onCommit: {withAnimation(.easeInOut(duration:  EASEINOUT)){
                    self.sheetState.showSheet = false
                    self.saveMeetingGroup()
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
                Text("Members")
                    .frame(width: 120, height: 100, alignment: .trailing)
                    .padding(Edge.Set.trailing, 30)
                    .font(Font.system(size: 20))
                TextField("Members", text: $memberNames, onCommit: {withAnimation(.easeInOut(duration: EASEINOUT)){
                    self.sheetState.showSheet = false
                    self.saveMeetingGroup()
                }})
                .frame(height: 55)
                .disableAutocorrection(true)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                .background(Color.white)
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                .padding(Edge.Set.trailing,100)
                .onChange(of: entityState.meetingGroupMembers, perform: { selectedMembers in
                    var mbrsStr = String()
                    if selectedMembers != nil {
                        selectedMembers!.forEach { member in
                            if mbrsStr.count > 0 {
                                mbrsStr.append(", ")
                            }
                            var fullTitle: String?
                            if let title = member.title {
                                fullTitle = title + " "
                            }
                            mbrsStr.append((fullTitle ?? "") + (member.firstName ?? "") + " " + member.lastName!)
                            print(mbrsStr.count)
                        }
                    }
                    self.memberNames = mbrsStr
                    print("Members string: \(mbrsStr)")
                    if selectedMembers != nil {
                        self.members = selectedMembers!
                    }
                })
                Button(action: {withAnimation(.easeInOut(duration: EASEINOUT)) {
                    self.saveButtonState.savePressed = false
                    self.presentMembersSheet = true
                }}) {
                    Text(">")
                }
                .padding(Edge.Set.trailing, 50)
                .font(.system(size: 36, weight: .medium))
                Spacer()
            }

            Spacer()
        }
        .onAppear(perform: {
            fetchSelectedMeetingGroup()
        })
        .onReceive(presenter.$viewModel, perform: { viewModel in
            self.meetingGroupName = viewModel.name
            self.memberNames = viewModel.members
        })
        .onReceive(self.saveButtonState.$savePressed, perform: { pressed in
            print("EditMeetingGroupView onReceive saveButtonState.$savePressed called")
            if (pressed == true) && (sheetState.editMode == 1) {
                self.saveButtonState.savePressed = false
                self.saveMeetingGroup() }
        })
    }
    
    func fetchSelectedMeetingGroup() {
        let interactor = EditMeetingGroupInteractor()
        interactor.displaySelectedMeetingGroup(entityState: entityState, presenter: presenter, selectedMasterRow: selectedMasterRow)
    }
    
    func saveMeetingGroup() {
        print("EditMeetingGroupView saveMeetingGroup called")
        let interactor = EditMeetingGroupInteractor()
        interactor.saveMeetingGroupToEntity(entityState: entityState, setupState: setupState, meetingGroupName: meetingGroupName, members: members, selectedMasterRow: selectedMasterRow)
    }
    
}





//struct EditMeetingGroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditMeetingGroupView()
//    }
//}
