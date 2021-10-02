//
//  ReportsHeaderView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 24/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import SwiftUI

struct ReportsHeaderView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
//                Spacer()

                Text("Meeting groups").modifier(SetupHeaderViewMasterHeading())

                Spacer()
//                Button(action: {withAnimation(.easeInOut(duration: EASEINOUT)) {
//                    self.sheetState.showSheet.toggle()
//                    self.sheetState.editMode = 0
//                }}) {
//                    Text("+")
//                        .font(.system(size: 32, weight: .light, design: .default))
//                        .frame(alignment: .trailing)
//                        .padding(.trailing, 10)
//                }
            }
            .fixedSize(horizontal: true, vertical: false)
            .frame(width: MASTERVIEW_WIDTH, alignment: .center)
            
            HStack {
                Spacer()
//                Button(action: {withAnimation(.easeInOut(duration: EASEINOUT)) {
//                    self.sheetState.showSheet.toggle()
//                    self.sheetState.editMode = 2
//                }})
//                {
//                    Image(systemName: "trash")
//                        .resizable()
//                        .accentColor(Color.red)
//                        .frame(width: 25, height: 25)
//                }
//                Spacer().fixedSize().frame(width: 50)
//                Button(action: {withAnimation(.easeInOut(duration: EASEINOUT)) {
//                    self.sheetState.showSheet.toggle()
//                    self.sheetState.editMode = 1
//                }}) {
//                    Text("Edit")
//                        ..modifier(SetupHeaderViewMasterHeading())
//                        .frame(width: 60, height: 60, alignment: .trailing)
//                        .padding(.trailing,30)
//                }
            }
            .frame(minWidth: 200, alignment: .leading)
        }
    }
}

//struct ReportsHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportsHeaderView()
//    }
//}
