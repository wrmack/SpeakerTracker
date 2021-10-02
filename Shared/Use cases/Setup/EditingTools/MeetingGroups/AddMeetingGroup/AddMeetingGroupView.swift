//
//  AddMeetingGroupView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 10/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine

struct AddMeetingGroupView: View {
    @EnvironmentObject var entityState: EntityState
    @EnvironmentObject var setupState: SetupState
    @ObservedObject var saveButtonState: SaveButtonState
    @State var meetingGroupName = ""
    @State var memberNames = ""
    @State var members = Set<Member>()
    @Binding var sheetState: SheetState
    @Binding var presentMembersSheet: Bool


    
    init(presentMembersSheet: Binding<Bool>, sheetState: Binding<SheetState>, saveButtonState: SaveButtonState ) {
        self._presentMembersSheet = presentMembersSheet
        self._sheetState = sheetState
        self.saveButtonState = saveButtonState
    }
    
    
    var body: some View {
        Print("AddMeetingGroupView body refreshed")
        VStack {
            Text("Create new meeting group for")
                .padding(Edge.Set.top, 0).padding(Edge.Set.bottom, 0)
                .font(Font.system(size: 30))
            Text(entityState.currentEntity!.name!)
                .padding(Edge.Set.top, 0).padding(Edge.Set.bottom, 30)
                .font(Font.system(size: 30))
            HStack {
                Text("Name")
                    .frame(width: 120, height: 100, alignment: .trailing)
                    .padding(Edge.Set.trailing, 30)
                    .font(Font.system(size: 20))
                TextField("eg Some Committee", text: $meetingGroupName, onCommit: {withAnimation(.easeInOut(duration: EASEINOUT)){
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
                .padding(Edge.Set.trailing,10)
                .onReceive(entityState.$meetingGroupMembers, perform: { selectedMembers in
                    print("Does this work: \(members.debugDescription)")
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
        .onReceive(self.saveButtonState.$savePressed, perform: { pressed in
            print("AddMeetingGroupView onReceive saveButtonState.$savePressed")
            if (pressed == true) && (sheetState.editMode == 0) {
                print("------ .onReceive")
                self.saveButtonState.savePressed = false
                self.saveMeetingGroup() }
        })
        .onAppear(perform: {
            print("AddMeetingGroupView .onAppear")
        })
        .onDisappear(perform: {
            print("AddMeetingGroupView .onDisappear")
        })
        
    }
    
    func saveMeetingGroup() {
        let interactor = AddMeetingGroupInteractor()
        interactor.saveMeetingGroupToEntity(entityState: entityState, setupState: setupState, meetingGroupName: meetingGroupName, members: members)
    }
    
}

//struct AddMeetingGroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddMeetingGroupView()
//    }
//}
