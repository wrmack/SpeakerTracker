//
//  SpeakerTableList.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 2/08/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//


import SwiftUI
import Combine

struct RemainingTableList: View {
   var title = "REMAINING"
   var viewModel: [SectionList]
   @Binding var moveAction: MoveMemberAction

   var body: some View {
      Print(">>>>>> RemainingTableList body")
      VStack(spacing: 0) {
         HStack {
            Spacer()
            Text(title)
               .font(.headline)
               .foregroundColor(Color.white)
               .padding(.vertical, 10.0)
            Spacer()
         }
         .frame(height:44)
         .background(Color.black)
         List {
            ForEach(viewModel, id: \.self) { sectionList in
//                Section(header: HStack{}){
                  ForEach(sectionList.sectionMembers, id: \.self) { listMember in
                     RemainingTableRow(rowContent: listMember, sectionNumber: sectionList.sectionNumber, moveAction: $moveAction)
//                          .listRowSeparator(.visible)
                  }
//               }
                
            }

         }
         .colorScheme(.light)
         .environment(\.defaultMinListHeaderHeight, 0)
      }
      .background(Color.white)
   }
}


struct RemainingTableRow: View {
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
            if value.translation.width > 60 {
               moveAction = MoveMemberAction(sourceTable: 0, sourceSectionListNumber: 0, listMember: rowContent, direction: .right)
            }
         }
   }
   
   var body: some View {
      VStack {
         HStack {
            Text("\(rowContent.member!.lastName!) row: \(rowContent.row!)")
            Spacer()
            Text(">")
               .fixedSize(horizontal: true, vertical: true)
               .frame(width: 40, height: 30)
               .font(.system(size: 50, weight: .medium, design: .default))
               .foregroundColor(Color(white: 0.85))
               .onTapGesture {
                  moveAction = MoveMemberAction(sourceTable: 0, sourceSectionListNumber: 0, listMember: rowContent, direction: .right)
               }

         }
      }
      .gesture(drag)

   }
}

struct SpeakerTableList_Previews: PreviewProvider {


   static var previews: some View {
       let context = PersistenceController.preview.container.viewContext
       let member1 = Member(context: context)
       member1.lastName = "Name1"
       let member2 = Member(context: context)
       member2.lastName = "Name2"
       let listMember1 = ListMember(row:0, member: member1)
       let listMember2 = ListMember(row:1, member: member2)
       
       let testData = [
           SectionList(sectionNumber: 0, sectionType: .mainDebate, sectionMembers: [listMember1, listMember2])
          ]
       return RemainingTableList(viewModel: testData, moveAction: .constant(MoveMemberAction()))
           .environment(\.managedObjectContext, context)
    }
}


