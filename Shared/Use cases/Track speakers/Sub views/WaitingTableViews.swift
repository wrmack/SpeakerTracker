//
//  WaitingTableViews.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 18/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI

struct WaitingTableList: View {
   var title = "WAITING TO SPEAK"
   var viewModel: [SectionList]
   @Binding var moveAction: MoveMemberAction
   @State var isEditable = false
   
   var body: some View {
      Print(">>>>>> WaitingTableList body")
      VStack(spacing: 0) {
         HStack {
            Spacer()
            Text(title)
               .font(.headline)
               .foregroundColor(Color.white)
               .padding(.vertical, 10.0)
            Spacer()
            Image("reordertemplate")
               .foregroundColor(.white)
               .onTapGesture {
                  isEditable.toggle()
               }
         }.background(Color.black)
         List {
            ForEach(viewModel, id: \.self) { sectionList in 
               Section {
                  ForEach(sectionList.sectionMembers, id: \.self) { listMember in
                     WaitingTableRow(rowContent: listMember, sectionNumber: sectionList.sectionNumber, moveAction: $moveAction)
                  }
                  .onMove(perform: { (indexSet, index) in
                     print("here")
                  })
               }
            }
         }
         .background(Color.white)
//         .environment(\.editMode, isEditable ? .constant(.active) : .constant(.inactive))

      }
   }
}


struct WaitingTableRow: View {
   var rowContent: ListMember
   var sectionNumber = 0
   @State var isDragging = false
   @Binding var moveAction: MoveMemberAction
   @EnvironmentObject var trackSpeakersState: TrackSpeakersState
   
   
   var drag: some Gesture {
      DragGesture(minimumDistance: 60, coordinateSpace: .local)
         .onChanged { _ in self.isDragging = true }
         .onEnded { value in
            self.isDragging = false
            print("Dragged with value: \(value.translation)")
            if value.translation.width > 60 {
               moveAction = MoveMemberAction(sourceTable: 1, sourceSectionListNumber: 0, listMember: rowContent, direction: .right)
            }
            if value.translation.width < -60 {
               moveAction = MoveMemberAction(sourceTable: 1, sourceSectionListNumber: 0, listMember: rowContent, direction: .left)
            }
         }
   }
   
   var body: some View {
      VStack {
         HStack {
            Text("<")
               .fixedSize(horizontal: true, vertical: true)
               .frame(width: 40, height: 30)
               .font(.system(size: 50, weight: .medium, design: .default))
               .foregroundColor(Color(white: 0.85))
               .onTapGesture {
                  moveAction = MoveMemberAction(sourceTable: 1, sourceSectionListNumber: 0, listMember: rowContent, direction: .left)
               }
            Text("\(rowContent.member!.lastName!) row: \(rowContent.row!)")
            Spacer()
            Text(">")
               .fixedSize(horizontal: true, vertical: true)
               .frame(width: 40, height: 30)
               .font(.system(size: 50, weight: .medium, design: .default))
               .foregroundColor(Color(white: 0.85))
               .onTapGesture {
                  moveAction = MoveMemberAction(sourceTable: 1, sourceSectionListNumber: 0, listMember: rowContent, direction: .right)
               }
         }
      }
      .gesture(drag)
      
   }

}
