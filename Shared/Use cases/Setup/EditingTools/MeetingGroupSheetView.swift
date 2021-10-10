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
    @ObservedObject var setupSheetState: SetupSheetState
    //   @Binding var presentMembersSheet: Bool
    @State var selectedList = Set<Member>()
    
    
    var body: some View {
        VStack {
            Spacer().fixedSize().frame(height: 30)
            HStack {
                Button(action: {withAnimation(.easeInOut(duration: EASEINOUT)) {
                    setupSheetState.showMembersSheet = false
                }}) {
                    Text("Cancel")
                }
                .buttonStyle(PlainButtonStyle())
                .padding(Edge.Set.leading, 50)
                .font(.system(size: 24))
                Spacer()
                Button(action: {withAnimation(.easeInOut(duration: EASEINOUT)) {
                    saveSelectedMembers()
                    setupSheetState.showMembersSheet = false
                }}) {
                    Text("Done")
                }
                .buttonStyle(PlainButtonStyle())
                .padding(Edge.Set.trailing, 50)
                .font(.system(size: 24))
            }
            Text("Select the members in this meeting group")
                .padding(Edge.Set.top, 0).padding(Edge.Set.bottom, 0)
                .font(Font.system(size: 24))
            
            List(entityState.sortedMembers(entity: entityState.currentEntity!)!, id: \.self, selection: $selectedList) {
                let title = ($0.title != nil) ? $0.title! : ""
                let firstName = ($0.firstName != nil) ? $0.firstName! : ""
                let lastName = ($0.lastName != nil) ? $0.lastName! : ""
                Text("\(title) \(firstName) \(lastName)")
            }
#if os(iOS)
            .environment(\.editMode, .constant(.active))
#endif
            
            Spacer()
            
        }
        .background(Color(white: 0.3, opacity: 1.0))
        
    }
    
    func saveSelectedMembers() {
        print("Rows selected: \(selectedList.debugDescription)")
        setupSheetState.selectedMembers = selectedList
    }
}

//struct MeetingGroupSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        MeetingGroupSheetView()
//    }
//}