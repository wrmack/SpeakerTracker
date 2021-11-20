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
    @Binding var reorderAction: ReorderAction
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
                #if os(iOS)
                Image("reordertemplate")
                    .foregroundColor(.white)
                    .onTapGesture {
                        isEditable.toggle()
                    }
                #endif
            }
            .frame(height:44)
            .background(Color.black)
            List {
                ForEach(viewModel, id: \.self) { sectionList in
                    ForEach(sectionList.sectionMembers, id: \.self) { listMember in
                        WaitingTableRow(rowContent: listMember, sectionNumber: sectionList.sectionNumber, moveAction: $moveAction)
                    }
                    .onMove(perform: { (indexSet, index) in
                        print("Moving: indexSet \(indexSet), index: \(index)")
                        reorderAction = ReorderAction(source:indexSet, destination: index)
                    })
                }
            }
            .listStyle(.plain)
            .colorScheme(.light)
#if os(iOS)
            .environment(\.editMode, isEditable ? .constant(.active) : .constant(.inactive))
#endif
            
        }
        .background(Color.white)
    }
    
}


struct WaitingTableRow: View {
    var rowContent: ListMember
    var sectionNumber = 0
    @State var isDragging = false
    @Binding var moveAction: MoveMemberAction
    @EnvironmentObject var trackSpeakersState: TrackSpeakersState
    
#if os (iOS)
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
#endif
    
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
                Text("\(rowContent.member!.firstName!) \(rowContent.member!.lastName!)")
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
        #if os(iOS)
            .gesture(drag)
        #endif
    }
    
}
