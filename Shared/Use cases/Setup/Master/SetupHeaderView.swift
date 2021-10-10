//
//  SetupHeaderView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 8/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import SwiftUI

/**
 Displays a heading for the master view and the "+", trash and edit tools.
 
 The editing sheet is displayed (by ContentView) depending on the state of SheetState.
 */
struct SetupHeaderView: View {
    @ObservedObject var setupSheetState: SetupSheetState
    @Binding var selectedSetupTab: Int
    
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                Spacer()
                switch selectedSetupTab {
                case 0: Text("Entities").modifier(SetupHeaderViewMasterHeading())
                case 1: Text("Members").modifier(SetupHeaderViewMasterHeading())
                case 2: Text("Meeting groups").modifier(SetupHeaderViewMasterHeading())
                case 3: Text("Events").modifier(SetupHeaderViewMasterHeading())
                default: Text("Entities").modifier(SetupHeaderViewMasterHeading())
                }
                Spacer()
                Button(action: {withAnimation(.easeInOut(duration: EASEINOUT)) {
                    setupSheetState.showSheet.toggle()
                    self.setupSheetState.editMode = 0
                }}) {
                    Text("+")
                        .font(.system(size: 32, weight: .light, design: .default))
                        .frame(alignment: .trailing)
                        .padding(.trailing, 10)
                }
                    .buttonStyle(PlainButtonStyle())
            }
                .frame(width: MASTERVIEW_WIDTH, alignment: .center)
            
            HStack{
                Spacer()
                Button(action: {withAnimation(.easeInOut(duration: EASEINOUT)) {
                    self.setupSheetState.showSheet.toggle()
                    self.setupSheetState.editMode = 2
                }})
                {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle())

                
                Spacer().fixedSize().frame(width: 50)
                Button(action: {withAnimation(.easeInOut(duration: EASEINOUT)) {
                    self.setupSheetState.showSheet.toggle()
                    self.setupSheetState.editMode = 1
                }}) {
                    Text("Edit")
                        .modifier(SetupHeaderViewMasterHeading())
                        .frame(width: 60, height: 60, alignment: .trailing)
                        .padding(.trailing,30)
                }
                    .buttonStyle(PlainButtonStyle())
            }
            .frame(minWidth: 200, alignment: .trailing)

        }
    }
}

//struct SetupHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        SetupHeaderView(setupSheetState: .constant(SetupSheetState()), selectedSetupTab: .constant(0))
//    }
//}
