//
//  SetupSheetView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 29/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine


struct DebugSheetView {
    func printMe() {
        print(">>>>>> SetupSheetView init called")
    }
}

struct SetupSheetView: View {
    
    @EnvironmentObject var entityState: EntityState
//    @EnvironmentObject var setupState: SetupState
    @ObservedObject var setupSheetState: SetupSheetState
    @Binding var presentMembersSheet: Bool
    @Binding var selectedSetupTab: Int
//    @Binding var selectedMasterRow: Int
//    @State var saveWasPressed = false
    
//    init(setupSheetState: Binding<SetupSheetState>, presentMembersSheet: Binding<Bool>, selectedSetupTab: Binding<Int>) {
//        self._setupSheetState = setupSheetState
//        self._presentMembersSheet = presentMembersSheet
//        self._selectedSetupTab = selectedSetupTab
////        self._selectedMasterRow = selectedMasterRow
////        DebugSheetView().printMe()
//    }
    
    var body: some View {
        
        Print(">>>>>> SetupSheetView body refreshed")
        VStack {
            Spacer().fixedSize().frame(height: 30)
            HStack {
                Button(action: {withAnimation(.easeInOut(duration: EASEINOUT)) {
                    setupSheetState.showSheet = false
                }}) {
                    Text("Cancel")
                }
                .buttonStyle(PlainButtonStyle())
                .padding(Edge.Set.leading, 50)
                .font(.system(size: 24))
                Spacer()
                Button(action: {withAnimation(.easeInOut(duration: EASEINOUT)) {
                    setupSheetState.showSheet = false
                    setupSheetState.saveWasPressed = true
                }}) {
                    switch setupSheetState.editMode {
                    case 0, 1:
                        Text("Save")
                    case 2:
                        Text("DELETE")
                            .bold()
                            .foregroundColor(Color.red)
                    default:
                        Text("Save")
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(Edge.Set.trailing, 50)
                .font(.system(size: 24))
            }
            
            switch selectedSetupTab {
            case 0:
                
                if setupSheetState.editMode == 0 {
                    AddEntityView(setupSheetState: setupSheetState)
                }
                if setupSheetState.editMode == 1 {
                    EditEntityView(setupSheetState: setupSheetState)
                }
                if (setupSheetState.editMode == 2) {
                    DeleteEntityView(setupSheetState: setupSheetState)
                }
                
            case 1:
                if setupSheetState.editMode == 0 {
                    AddMemberView(setupSheetState: setupSheetState)
                }
                if setupSheetState.editMode == 1 {
                    EditMemberView(setupSheetState: setupSheetState)
                }
                if (setupSheetState.editMode == 2) {
                    DeleteMemberView(setupSheetState: setupSheetState)
                }
            case 2:
                if setupSheetState.editMode == 0 {
                    AddMeetingGroupView(setupSheetState: setupSheetState)
                }
                if setupSheetState.editMode == 1 {
                    EditMeetingGroupView(setupSheetState: setupSheetState)
                }
                if setupSheetState.editMode == 2 {
                    DeleteMeetingGroupView(setupSheetState: setupSheetState)
                }
            case 3:
                if setupSheetState.editMode == 0 {
                    AddEventView(setupSheetState: setupSheetState)
                }
                if setupSheetState.editMode == 1 {
//                    EditEventView(sheetState: self.$sheetState, saveButtonState: self.saveButtonState, selectedMasterRow: self.$selectedMasterRow)
                }
                if (setupSheetState.editMode == 2) {
//                    DeleteEventView(sheetState: self.$sheetState, saveButtonState: self.saveButtonState, selectedMasterRow: self.$selectedMasterRow)
                }
            
            default: AddEntityView(setupSheetState: setupSheetState)
            
            }
            
        }
        .background(Color(white: 0.3, opacity: 1.0))
    }
}


//struct SetupSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        SetupSheet()
//    }
//}
