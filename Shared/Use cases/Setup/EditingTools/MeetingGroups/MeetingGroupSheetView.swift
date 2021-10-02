//
//  MeetingGroupSheetView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 10/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine



struct MeetingGroupSheetView: View {
   @EnvironmentObject var entityState: EntityState
   @Binding var presentMembersSheet: Bool
   @State var selectedList = Set<Member>()
   
   init(presentMembersSheet: Binding<Bool>) {
      self._presentMembersSheet = presentMembersSheet
   }
   
   
   var body: some View {
      VStack {
         Spacer().fixedSize().frame(height: 30)
         HStack {
            Button(action: {withAnimation(.easeInOut(duration: EASEINOUT)) {
               self.presentMembersSheet = false
            }}) {
               Text("Cancel")
            }
            .padding(Edge.Set.leading, 50)
            .font(.system(size: 24))
            Spacer()
            Button(action: {withAnimation(.easeInOut(duration: EASEINOUT)) {
               self.presentMembersSheet = false
               saveSelectedMembers()
            }}) {
               Text("Save")
            }
            .padding(Edge.Set.trailing, 50)
            .font(.system(size: 24))
         }
         Text("Select the members in this meeting group")
            .padding(Edge.Set.top, 0).padding(Edge.Set.bottom, 0)
            .font(Font.system(size: 30))
//         List(entityState.currentEntity!.members!, id: \.self, selection: $selectedList) {
//            let title = ($0.title != nil) ? $0.title! : ""
//            let firstName = ($0.firstName != nil) ? $0.firstName! : ""
//            let lastName = ($0.lastName != nil) ? $0.lastName! : ""
//            Text("\(title) \(firstName) \(lastName)")
//         }
//         .environment(\.editMode, .constant(.active))
         Spacer()
         
      }
   }
   
   func saveSelectedMembers() {
      print("Rows selected: \(selectedList.debugDescription)")
      entityState.meetingGroupMembers = selectedList 
   }
}

//struct MeetingGroupSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        MeetingGroupSheetView()
//    }
//}
