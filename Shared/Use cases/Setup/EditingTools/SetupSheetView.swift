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
    @EnvironmentObject var setupState: SetupState
    @Binding var sheetState: SheetState
    @Binding var presentMembersSheet: Bool
    @Binding var selectedSetupTab: Int
    @Binding var selectedMasterRow: Int
    @State var saveWasPressed = false
    @StateObject var saveButtonState = SaveButtonState()
    
    init(sheetState: Binding<SheetState>, presentMembersSheet: Binding<Bool>, selectedSetupTab: Binding<Int>, selectedMasterRow: Binding<Int>) {
        self._sheetState = sheetState
        self._presentMembersSheet = presentMembersSheet
        self._selectedSetupTab = selectedSetupTab
        self._selectedMasterRow = selectedMasterRow
        DebugSheetView().printMe()
    }
    
    var body: some View {
        
        Print(">>>>>> SetupSheetView body refreshed")
        VStack {
            Spacer().fixedSize().frame(height: 30)
            HStack {
                Button(action: {withAnimation(.easeInOut(duration: EASEINOUT)) {
                    self.sheetState.showSheet = false
                }}) {
                    Text("Cancel")
                }
                .padding(Edge.Set.leading, 50)
                .font(.system(size: 24))
                Spacer()
                Button(action: {withAnimation(.easeInOut(duration: EASEINOUT)) {
                    self.sheetState.showSheet = false
                    self.saveButtonState.savePressed = true
                    self.saveWasPressed = true
                }}) {
                    switch sheetState.editMode {
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
                .padding(Edge.Set.trailing, 50)
                .font(.system(size: 24))
            }
            
            switch selectedSetupTab {
            case 0:
                
                if self.sheetState.editMode == 0 {
                    AddEntityView(sheetState: self.$sheetState, saveWasPressed: self.$saveWasPressed) 
                }
                if self.sheetState.editMode == 1 {
                    EditEntityView(sheetState: self.$sheetState, selectedMasterRow: self.$selectedMasterRow, saveWasPressed: $saveWasPressed) 
                }
                if (self.sheetState.editMode == 2) {
                    DeleteEntityView(sheetState: self.$sheetState, selectedMasterRow: self.$selectedMasterRow, saveWasPressed: $saveWasPressed)
                }
                
            case 1:
                if self.sheetState.editMode == 0 {
                    AddMemberView(sheetState: self.$sheetState, saveButtonState: self.saveButtonState)
                }
                if self.sheetState.editMode == 1 {
                    EditMemberView(sheetState: self.$sheetState, saveButtonState: self.saveButtonState, selectedMasterRow: self.$selectedMasterRow)
                }
                if (self.sheetState.editMode == 2) {
                    DeleteMemberView(sheetState: self.$sheetState, saveButtonState: self.saveButtonState, selectedMasterRow: self.$selectedMasterRow)
                }
            case 2:
                if self.sheetState.editMode == 0 {
                    AddMeetingGroupView(presentMembersSheet: $presentMembersSheet, sheetState: self.$sheetState, saveButtonState: self.saveButtonState)
                }
                if self.sheetState.editMode == 1 {
                    EditMeetingGroupView(presentMembersSheet: $presentMembersSheet, sheetState: self.$sheetState, saveButtonState: self.saveButtonState, selectedMasterRow: self.$selectedMasterRow)
                }
                if self.sheetState.editMode == 2 {
                    DeleteMeetingGroupView(sheetState: self.$sheetState, saveButtonState: self.saveButtonState, selectedMasterRow: self.$selectedMasterRow)
                }
            case 3:
                if self.sheetState.editMode == 0 {
                    AddEventView(sheetState: self.$sheetState, saveButtonState: self.saveButtonState)
                }
                if self.sheetState.editMode == 1 {
                    EditEventView(sheetState: self.$sheetState, saveButtonState: self.saveButtonState, selectedMasterRow: self.$selectedMasterRow)
                }
                if (self.sheetState.editMode == 2) {
                    DeleteEventView(sheetState: self.$sheetState, saveButtonState: self.saveButtonState, selectedMasterRow: self.$selectedMasterRow)
                }
            
            default: AddEntityView(sheetState: self.$sheetState, saveWasPressed: self.$saveWasPressed)
            
            }
            
        }
        .background(Color(white: 0.85))
    }
}


//struct SetupSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        SetupSheet()
//    }
//}
