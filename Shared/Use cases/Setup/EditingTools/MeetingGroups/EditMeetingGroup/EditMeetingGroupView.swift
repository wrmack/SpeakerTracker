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
    @ObservedObject var setupSheetState: SetupSheetState
    @StateObject var presenter = EditMeetingGroupPresenter()
    @State var meetingGroupName = ""
    @State var memberNames = ""
    @State var members = Set<Member>()

    
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
                TextField("eg Some Committee", text: $meetingGroupName)
                    .frame(height: 55)
                    .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .padding(Edge.Set.trailing,100)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(Font.system(size: 18))
                    .disableAutocorrection(true)
            }
            HStack {
                Text("Members")
                    .frame(width: 120, height: 100, alignment: .trailing)
                    .padding(Edge.Set.trailing, 30)
                    .font(Font.system(size: 20))
                TextField("Members", text: $memberNames)
                    .frame(height: 55)
                    .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .padding(Edge.Set.trailing,100)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(Font.system(size: 18))
                    .disableAutocorrection(true)
                    .onReceive(setupSheetState.$selectedMembers, perform: { selectedMembers in
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
                    setupSheetState.saveWasPressed = false
                    setupSheetState.showMembersSheet = true
                }}) {
                    Text(">")
                }
                .buttonStyle(PlainButtonStyle())
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
        .onReceive(setupSheetState.$saveWasPressed, perform: { pressed in
            print("------ EditMeetingGroupView onReceive saveButtonState.$savePressed called")
            if (pressed == true) && (setupSheetState.editMode == 1) {
                setupSheetState.saveWasPressed = false
                self.saveMeetingGroup() }
        })
    }
    
    func fetchSelectedMeetingGroup() {
        let interactor = EditMeetingGroupInteractor()
        interactor.displaySelectedMeetingGroup(entityState: entityState, presenter: presenter)
    }
    
    func saveMeetingGroup() {
        print("------ EditMeetingGroupView saveMeetingGroup called")
        let interactor = EditMeetingGroupInteractor()
        interactor.saveMeetingGroupToEntity(entityState: entityState, setupSheetState: setupSheetState, meetingGroupName: meetingGroupName, members: members)
    }
    
}





//struct EditMeetingGroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditMeetingGroupView()
//    }
//}
