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
    @ObservedObject var setupSheetState: SetupSheetState
    @StateObject var presenter = DeleteMeetingGroupPresenter()
    @State var meetingGroupName = ""
    @State var memberNames = ""
    @State var members = Set<Member>()
    

    
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
                    .font(Font.system(size: 18))
                    .textFieldStyle(MyTextFieldStyle())
                    .padding(.trailing,100)
            }
            HStack {
                Text("Members")
                    .frame(width: 120, height: 100, alignment: .trailing)
                    .padding(Edge.Set.trailing, 30)
                    .font(Font.system(size: 20))
                TextField("", text: $memberNames)
                    .disabled(true)
                    .font(Font.system(size: 18))
                    .textFieldStyle(MyTextFieldStyle())
                    .padding(.trailing,100)
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
            }
            Spacer()
        }
        .padding(.trailing, 20)
        .onAppear(perform: {
            fetchSelectedMeetingGroup()
        })
        .onReceive(presenter.$viewModel, perform: { viewModel in
            self.meetingGroupName = viewModel.name
            self.memberNames = viewModel.members
        })
        .onReceive(setupSheetState.$saveWasPressed, perform: { pressed in
            print("------ DeleteMemberView onReceive saveButtonState.$savePressed = \(pressed)")
            if (pressed == true) && (setupSheetState.editMode == 2) {
                setupSheetState.saveWasPressed = false
                self.deleteMeetingGroup() }
        })
    }
    
    func fetchSelectedMeetingGroup() {
        DeleteMeetingGroupInteractor.displaySelectedMeetingGroup(entityState: entityState, presenter:  presenter)
    }
    
    func deleteMeetingGroup() {
        DeleteMeetingGroupInteractor.deleteSelectedMeetingGroupFromEntity(entityState: entityState)
    }
}

//struct DeleteMeetingGroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeleteMeetingGroupView()
//    }
//}
