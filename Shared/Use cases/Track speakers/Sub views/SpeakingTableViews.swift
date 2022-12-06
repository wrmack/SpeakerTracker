//
//  SpeakingTableViews.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 18/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI

/**
 A list view for the speaking table
 
 Injected properties (except for bindings):
 - viewModel: the presenter's viewmodel for displaying list
 
 Bindings:
 - moveAction: passed to SpeakingTableRow
 - memberTimerActions: passed to SpeakingTableRow
 - longPressAction: passed to SpeakingTableRow
 
 */
struct SpeakingTableList: View {
    var title = "SPOKEN / SPEAKING"
    var viewModel: [SectionList]
    @Binding var moveAction: MoveMemberAction
    @Binding var memberTimerActions: MemberTimerActions
    @Binding var longPressAction: LongPressAction
    @Binding var showNote: Bool
    @Binding var isRecording: Bool
    @State var sectionIsCollapsed: [Int : Bool] = [0 : false]
    
    
    var body: some View {
        Print(">>>>>> SpeakingTableList body")
        VStack(spacing: 0) {
            
            // Table heading
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
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment:.leading, spacing:0) {
                        ForEach(viewModel, id: \.self){ item in
                            let sectionList = item as SectionList
                            Section {
                                if sectionIsCollapsed[sectionList.sectionNumber] != true || sectionList.sectionType == .mainDebate  {
                                        ForEach(sectionList.sectionMembers, id: \.row) { listMember in
                                            SpeakingTableRow(rowContent: listMember,
                                                             sectionNumber: sectionList.sectionNumber,
                                                             sectionType: sectionList.sectionType,
                                                             moveAction: $moveAction,
                                                             memberTimerActions: $memberTimerActions,
                                                             longPressAction: $longPressAction,
                                                             sectionIsCollapsed: $sectionIsCollapsed
                                            )
                                        }
                                }
                            }
                            header: {
                                VStack(spacing:0) {
                                    Spacer()
                                    HStack {
                                        Text((sectionList as SectionList).sectionHeader)
                                            .font(.headline)
                                            .foregroundColor(Color.black)

                                        Spacer()
                                        if (isRecording == true) &&
                                            ((sectionList as SectionList).sectionType == SectionType.mainDebate) &&
                                            ((sectionList as SectionList).sectionNumber  == 0) {
                                            Spacer()
                                            Button(action: {
                                                showNote.toggle()
                                            })
                                            {
                                                Image(systemName: "square.and.pencil")
                                            }
                                        }
                                        
                                        if (sectionList.sectionType == SectionType.amendment) {
                                            Spacer()
                                            Button(action: {
                                                withAnimation {
                                                    // Check if sectionIsCollapsed contains this section.
                                                    // If not, set to true.  Default is not-collapsed. User must want to collapse.
                                                    if sectionIsCollapsed.keys.contains(sectionList.sectionNumber) == false {
                                                        sectionIsCollapsed[sectionList.sectionNumber] = true
                                                    }
                                                    // If collapsed then user must want to expand it
                                                    else if sectionIsCollapsed[sectionList.sectionNumber]! == true {
                                                        sectionIsCollapsed[sectionList.sectionNumber] = false
                                                    }
                                                    // Otherwise collapse it
                                                    else {
                                                        sectionIsCollapsed[sectionList.sectionNumber] = true
                                                    }
                                                }
                                            })
                                            {
                                                Image(systemName: "chevron.right.circle")
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            .rotationEffect((sectionIsCollapsed[sectionList.sectionNumber] == true) ? .degrees(0) : .degrees(90))
                                            .imageScale(.large)

                                        }

                                    }
                                    Spacer()
                                    Divider()
                                }
                                .frame(height:44)
                                .padding(.horizontal,10)
                            }
                        }
                    }
                }
//                .listStyle(.plain)
                .colorScheme(.light)
                .onChange(of: viewModel, perform: { val in
                    if val.count > 0 {
                        if (val as [SectionList]).last!.sectionMembers.count > 0 {
                            let lastSectionMember = (val as [SectionList]).last!.sectionMembers.last!
                            proxy.scrollTo(lastSectionMember.row, anchor: .bottom)
                        }
                    }
                })
            }
        }
        .background(Color.white)
    }
}

/**
 A view for each member in the speaking table list.
 
 Injected properties (except bindings):
 - rowContent: the member to display
 
 Bindings:
 - moveActions: changes state in TrackSpeakersView when a member is moved by dragging or tapping left arrow
 - memberTimerActions: changes state in TrackSpeakersView when play or stop is tapped
 
 Environment:
 - trackSpeakersState:  listens for changes to the timer string and sets own property timerString
 
 Time display:
 
 Shows the time held by trackSpeakersState if the current member's timerIsActive property is true, otherwise
 displays the time held by each member.
*/

struct SpeakingTableRow: View {
    var rowContent: ListMember
    var sectionNumber = 0
    var sectionType: SectionType = .mainDebate
    @Binding var moveAction: MoveMemberAction
    @Binding var memberTimerActions: MemberTimerActions
    @Binding var longPressAction: LongPressAction
    @State var timerString = "00:00"
    @State var isDragging = false
    @EnvironmentObject var trackSpeakersState: TrackSpeakersState
    @Binding var sectionIsCollapsed: [Int : Bool]

#if os(iOS)
    var drag: some Gesture {
        DragGesture(minimumDistance: 60, coordinateSpace: .local)
            .onChanged { _ in self.isDragging = true }
            .onEnded { value in
                self.isDragging = false
                if value.translation.width < -60 {
                    moveAction = MoveMemberAction(sourceTable: 2, sourceSectionListNumber: 0, listMember: rowContent, direction: .left)
                }
            }
    }
#endif
    
    var body: some View {
        VStack(spacing:0) {
            Spacer()
            HStack {
                if rowContent.startTime == nil  {
                Text("<")
                    .fixedSize(horizontal: true, vertical: true)
                    .frame(width: 40, height: 30)
                    .font(.system(size: 50, weight: .medium, design: .default))
                    .foregroundColor(Color(white: 0.85))
                    .onTapGesture {
                        moveAction = MoveMemberAction(sourceTable: 2, sourceSectionListNumber: 0, listMember: rowContent, direction: .left)
                    }
                }
                Text("\(rowContent.member!.firstName!) \(rowContent.member!.lastName!)")
                
                Spacer()
                if trackSpeakersState.showMemberTimer == true {
                    Group {
                        // Display pause button before time
                        if rowContent.timerButtonMode == .pause_stop {
                            Image(systemName: "pause.fill")
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    print("Pause pressed")
                                    trackSpeakersState.memberTimerIsActive = false
                                    memberTimerActions = MemberTimerActions(listMember: rowContent, timerButtonMode: .play_stop, timerIsActive: true, speakingTime: trackSpeakersState.timerSeconds, timerButtonPressed: .pause)
                                }
                        }
                        
                        // Display play button before time
                        if rowContent.timerButtonMode == .play_stop {
                            Image(systemName: "play.fill")
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    print("Play pressed")
                                    trackSpeakersState.memberTimerIsActive = true
                                    memberTimerActions = MemberTimerActions(listMember: rowContent, timerButtonMode: .pause_stop, timerIsActive: true, speakingTime: trackSpeakersState.timerSeconds, timerButtonPressed: .play)
                                }
                        }
                        
                        // Display time
                        if rowContent.timerIsActive == true {
                            Text(self.timerString)
                        }
                        else {
                            Text(String(format: "%02d:%02d", (rowContent.speakingTime / 60), (rowContent.speakingTime % 60)))
                        }
                        
                        // Display play button after time
                        if rowContent.timerButtonMode == .play {
                            Image(systemName: "play.fill")
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    print("Play pressed")
                                    trackSpeakersState.memberTimerIsActive = true
                                    self.timerString = "00:00"
                                    var listMember = rowContent
                                    listMember.startTime = Date()
                                    memberTimerActions = MemberTimerActions(listMember: listMember, timerButtonMode: .pause_stop, timerIsActive: true, speakingTime: 0, timerButtonPressed: .play)
                                }
                        }
                        
                        // Display stop button after time
                        if (rowContent.timerButtonMode == .pause_stop) || (rowContent.timerButtonMode == .play_stop) {
                            Image(systemName: "stop.fill")
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    print("Stop pressed")
                                    trackSpeakersState.memberTimerIsActive = false
                                    memberTimerActions = MemberTimerActions(listMember: rowContent, timerButtonMode: .off, timerIsActive: false, speakingTime: trackSpeakersState.timerSeconds,  timerButtonPressed: .stop)
                                }
                        }
                        if rowContent.timerButtonMode == .off {
                            Text(verbatim: "")
                        }
                    }
                }

            }
            .padding(.horizontal,10)
            Spacer()
            Divider()
        }
        .frame(height:44)
        .contentShape(Rectangle())
        .onReceive(trackSpeakersState.$timerString, perform: { timerString in
            print("------ SpeakingTableRow onReceive $timerString")
            self.timerString = timerString
        })
#if os(iOS)
        .gesture(drag)
#endif
        .contextMenu {
            if sectionType == .mainDebate {
                Button("Moves amendment", action: { 
                    longPressAction = LongPressAction(type: .amendmentMover, listMember: rowContent)
                })
                Button("Speaks again", action: {
                    longPressAction = LongPressAction(type:.speakAgain,listMember: rowContent)
                })
            }
            if sectionType == .amendment {
                Button("Final speaker for amendment", action: {
                    longPressAction = LongPressAction(type: .amendmentFinal, listMember: rowContent)
                })
            }
            
        }
//        .animation(.none, value: sectionIsCollapsed[sectionNumber])
        
    }
    
}
