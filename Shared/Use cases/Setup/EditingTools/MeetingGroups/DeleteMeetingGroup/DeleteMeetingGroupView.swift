//
//  DeleteMeetingGroupView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 15/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import SwiftUI

struct DeleteMeetingGroupView: View {
    @EnvironmentObject var entityState: EntityState
    @EnvironmentObject var setupState: SetupState
    @StateObject var presenter = DeleteMeetingGroupPresenter()
    @ObservedObject var saveButtonState: SaveButtonState
    @State var meetingGroupName = ""
    @State var memberNames = ""
    @State var members = Set<Member>()
    @Binding var sheetState: SheetState
    @Binding var selectedMasterRow: Int
    
    init(sheetState: Binding<SheetState>, saveButtonState: SaveButtonState, selectedMasterRow: Binding<Int> ) {
        self._sheetState = sheetState
        self.saveButtonState = saveButtonState
        self._selectedMasterRow = selectedMasterRow
    }
    
    var body: some View {
        Print(">>>>>> DeleteMemberView body refreshed")
        VStack {
            Text("This will delete the meeting group below!")
                .padding(Edge.Set.top, 30).padding(Edge.Set.bottom, 30)
                .font(Font.system(size: 30))
            HStack {
                Text("Name")
                    .frame(width: 120, height: 100, alignment: .trailing)
                    .padding(Edge.Set.trailing, 30)
                    .font(Font.system(size: 20))
                TextField("eg Some committee", text: $meetingGroupName)
                    .disabled(true)
                    .frame(height: 55)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                    .padding(Edge.Set.trailing,100)
            }
            HStack {
                Text("Members")
                    .frame(width: 120, height: 100, alignment: .trailing)
                    .padding(Edge.Set.trailing, 30)
                    .font(Font.system(size: 20))
                TextField("eg John", text: $memberNames)
                    .disabled(true)
                    .frame(height: 55)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                    .padding(Edge.Set.trailing,100)
                    .onReceive(entityState.$meetingGroupMembers, perform: { selectedMembers in
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
            print("DeleteMemberView onReceive saveButtonState.$savePressed = \(pressed)")
            if (pressed == true) && (sheetState.editMode == 2) {
                self.saveButtonState.savePressed = false
                self.deleteMeetingGroup() }
        })
    }
    
    func fetchSelectedMeetingGroup() {
        let interactor = DeleteMeetingGroupInteractor()
        interactor.displaySelectedMeetingGroup(entityState: entityState, presenter:  presenter, selectedMasterRow: selectedMasterRow)
    }
    
    func deleteMeetingGroup() {
        let interactor = DeleteMeetingGroupInteractor()
        interactor.deleteSelectedMeetingGroupFromEntity(entityState: entityState, setupState: setupState, selectedMasterRow: selectedMasterRow)
    }
}

//struct DeleteMeetingGroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeleteMeetingGroupView()
//    }
//}
