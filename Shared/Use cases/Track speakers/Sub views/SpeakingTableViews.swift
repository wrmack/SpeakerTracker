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
    @State var sectionIsCollapsed: [Int : Bool] = [0 : false]
    @State var currentSectionIsCollapsed = false
    
    
    var body: some View {
        Print(">>>>>> SpeakingTableList body")
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
                ForEach(viewModel, id: \.self){ sectionList in
                    Section(header: HStack {
                        Text((sectionList as SectionList).sectionHeader)
                            .font(.headline)
                            .foregroundColor(Color.black)
                            .padding(.vertical, 10.0)
                        
                        if ((sectionList as SectionList).sectionType == SectionType.amendment) {
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    if sectionIsCollapsed.keys.contains((sectionList as SectionList).sectionNumber) == false {
                                        sectionIsCollapsed[(sectionList as SectionList).sectionNumber] = true
                                        currentSectionIsCollapsed = true
                                    }

                                    else if sectionIsCollapsed[(sectionList as SectionList).sectionNumber]! == true {
                                        sectionIsCollapsed[(sectionList as SectionList).sectionNumber] = false
                                        currentSectionIsCollapsed = false
                                    }
                                    else {
                                        sectionIsCollapsed[(sectionList as SectionList).sectionNumber] = true
                                        currentSectionIsCollapsed = true
                                    }
                                }
                            })
                            {
                                Image(systemName: "chevron.right.circle")
                            }
                            .buttonStyle(PlainButtonStyle())
                            .rotationEffect((sectionIsCollapsed[(sectionList as SectionList).sectionNumber] == true) ? .degrees(0) : .degrees(90))
                            .imageScale(.large)

                        }
                    }) {

                        if currentSectionIsCollapsed == false || (sectionList as SectionList).sectionType == .mainDebate  {
                            ForEach((sectionList as SectionList).sectionMembers, id: \.self ) { listMember in
                                Print("SpeakingTableList listMember \(listMember)")
                                SpeakingTableRow(rowContent: listMember,
                                                 sectionNumber: (sectionList as SectionList).sectionNumber,
                                                 sectionType: (sectionList as SectionList).sectionType,
                                                 moveAction: $moveAction,
                                                 memberTimerActions: $memberTimerActions,
                                                 longPressAction: $longPressAction,
                                                 currentSectionIsCollapsed: $currentSectionIsCollapsed
                                )

                            }
                        }
                    }
//                    .listSectionSeparator(.visible)
                }
            }
            .colorScheme(.light)
        }
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
    @Binding var currentSectionIsCollapsed: Bool
    
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
    
    var body: some View {
        VStack {
            HStack {
                Text("<")
                    .fixedSize(horizontal: true, vertical: true)
                    .frame(width: 40, height: 30)
                    .font(.system(size: 50, weight: .medium, design: .default))
                    .foregroundColor(Color(white: 0.85))
                    .onTapGesture {
                        moveAction = MoveMemberAction(sourceTable: 2, sourceSectionListNumber: 0, listMember: rowContent, direction: .left)
                    }
                Text("\(rowContent.member!.lastName!) row: \(rowContent.row!)")
                
                Spacer()
                Group {
                    // Display pause button before time
                    if rowContent.timerButtonMode == .pause_stop {
                        Image(systemName: "pause.fill")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                print("Pause pressed")
                                memberTimerActions = MemberTimerActions(listMember: rowContent, timerButtonMode: .play_stop, timerIsActive: true, speakingTime: trackSpeakersState.timerSeconds, timerButtonPressed: .pause)
                            }
                    }
                    
                    // Display play button before time
                    if rowContent.timerButtonMode == .play_stop {
                        Image(systemName: "play.fill")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                print("Play pressed")
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
                                self.timerString = "00:00"
                                memberTimerActions = MemberTimerActions(listMember: rowContent, timerButtonMode: .pause_stop, timerIsActive: true, speakingTime: 0, timerButtonPressed: .play)
                                
                            }
                    }
                    
                    // Display stop button after time
                    if (rowContent.timerButtonMode == .pause_stop) || (rowContent.timerButtonMode == .play_stop) {
                        Image(systemName: "stop.fill")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                print("Stop pressed")
                                memberTimerActions = MemberTimerActions(listMember: rowContent, timerButtonMode: .off, timerIsActive: false, speakingTime: trackSpeakersState.timerSeconds,  timerButtonPressed: .stop)
                            }
                    }
                    if rowContent.timerButtonMode == .off {
                        Text(verbatim: "")
                    }
                }
            }.animation(.none,value: currentSectionIsCollapsed)

        }
        .onReceive(trackSpeakersState.$timerString, perform: { timerString in
            self.timerString = timerString
        })
        .gesture(drag)
        .contextMenu {
            if sectionType == .mainDebate {
                Button("Moves amendment", action: { 
                    longPressAction = LongPressAction(type: .amendmentMover, member: rowContent)
                })
                Button("Speaks again", action: {
                    print("Action2")
                })
            }
            if sectionType == .amendment {
                Button("Final speaker for amendment", action: {
                    longPressAction = LongPressAction(type: .amendmentFinal, member: rowContent)
                })
            }
            
        }
        
    }
    
}
