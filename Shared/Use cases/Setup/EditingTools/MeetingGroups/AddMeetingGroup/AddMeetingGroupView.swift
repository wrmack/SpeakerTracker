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
    @ObservedObject var setupSheetState: SetupSheetState
    @State var meetingGroupName = ""
    @State var memberNames = ""
    @State var members = Set<Member>()
//    @Binding var presentMembersSheet: Bool

    
    
    var body: some View {
        Print(">>>>>> AddMeetingGroupView body refreshed")
        VStack {
            Text("Add a new meeting group for")
                .padding(Edge.Set.top, 0).padding(Edge.Set.bottom, 0)
                .font(Font.system(size: 24))
            Text(entityState.currentEntity!.name!)
                .padding(Edge.Set.top, 0).padding(Edge.Set.bottom, 30)
                .font(Font.system(size: 24))
            HStack {
                Text("Name")
                    .frame(width: 120, height: 100, alignment: .trailing)
                    .padding(Edge.Set.trailing, 30)
                    .font(Font.system(size: 20))
                TextField("eg Some Committee", text: $meetingGroupName)
                    .font(Font.system(size: 18))
                    .textFieldStyle(MyTextFieldStyle())
                    .padding(.trailing,100)
            }
            HStack {
                Text("Members")
                    .frame(width: 120, height: 100, alignment: .trailing)
                    .padding(Edge.Set.trailing, 30)
                    .font(Font.system(size: 20))
                TextField("Members", text: $memberNames)
                    .font(Font.system(size: 18))
                    .textFieldStyle(MyTextFieldStyle())
                    .padding(.trailing,100)
                .onReceive(setupSheetState.$selectedMembers, perform: { selectedMembers in
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
                    print("------ Members string: \(mbrsStr)")
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
        .onReceive(setupSheetState.$saveWasPressed, perform: { pressed in
            print("------ AddMeetingGroupView onReceive saveButtonState.$savePressed")
            if (pressed == true) && (setupSheetState.editMode == 0) {
                setupSheetState.saveWasPressed = false
                self.saveMeetingGroup() }
        })
        .onAppear(perform: {
            print("------ AddMeetingGroupView .onAppear")
        })
        .onDisappear(perform: {
            print("------ AddMeetingGroupView .onDisappear")
        })
        
    }
    
    func saveMeetingGroup() {
        AddMeetingGroupInteractor.saveMeetingGroupToEntity(entityState: entityState, setupSheetState: setupSheetState, meetingGroupName: meetingGroupName, members: members)
    }
    
}

//struct AddMeetingGroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddMeetingGroupView()
//    }
//}
