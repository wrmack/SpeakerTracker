//
//  TrackSpeakersView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 14/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

struct PlayButtonState {
    var disabled = false
    var color = ENABLED_COLOR
    init(disabled: Bool) {
        self.disabled = disabled
        self.color = disabled ? DISABLED_COLOR : ENABLED_COLOR
    }
}

struct PauseButtonState {
    var disabled = true
    var color = DISABLED_COLOR
    init(disabled: Bool) {
        self.disabled = disabled
        self.color = disabled ? DISABLED_COLOR : ENABLED_COLOR
    }
}

struct StopButtonState {
    var disabled = true
    var color = DISABLED_COLOR
    init(disabled: Bool) {
        self.disabled = disabled
        self.color = disabled ? DISABLED_COLOR : ENABLED_COLOR
    }
}


/// The main view for showing the tables of speakers and the timer
///
///
struct TrackSpeakersView: View {
    
#if os(macOS)
    @Environment(\.openURL) var openURL
#endif
    
    @EnvironmentObject var entityState: EntityState
    @EnvironmentObject var eventState: EventState
    @EnvironmentObject var trackSpeakersState: TrackSpeakersState
    @StateObject var presenter = TrackSpeakersPresenter()
    @State var viewHasAppeared = false
    @State var startTime = Date()
    @State var timerString = "00:00"
    @State var pausePressed = false
    @State var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State var playButton = PlayButtonState(disabled: false)
    @State var pauseButton = PauseButtonState(disabled: true)
    @State var stopButton = StopButtonState(disabled: true)
    @State var secondsAtPause = 0
    @State var moveAction = MoveMemberAction()
    @State var reorderAction = ReorderAction()
    @State var memberTimerActions = MemberTimerActions()
    @State var longPressAction = LongPressAction()
    @State var selectedMeetingGroupName: String?
    @State var showHelp = false
    @Binding var showMeetingSetupSheet: Bool
    @Binding var selectedMeetingGroup: MeetingGroup?
    @Binding var isRecording: Bool
    @State var showClock = false
    @State var showNote = false
    @State var noteText = ""
    
    
    var body: some View {
        Print(">>>>>> TrackSpeakersView body")
        GeometryReader { geo in
            ZStack(alignment:.topLeading) {
                // VStack has two HStacks: top row - controls, second row - speaker tables
                VStack {
                    // Top row: Box with committee name and clock; timer controls
                    HStack {
                        Spacer().fixedSize(horizontal: true, vertical: false).frame(width:100, height:1)
                        
                        // Committee name, timer display, timer buttons
                        HStack {
                            if let name = selectedMeetingGroupName {
                                Text(name)
                                    .fontWeight(.regular)
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 24))
                            }
                            else {
                                Text("No meeting group selected")
                                    .fontWeight(.light)
                                    .foregroundColor(Color(white: 0.7))
                                    .font(.system(size: 24))
                            }
                            Spacer()
                            Text(self.timerString)
                                .fontWeight(.medium)
                                .foregroundColor(Color.white)
                                .font(.custom("Arial Rounded MT Bold", size: 92))
                                .frame(minWidth: 300)
                                .onReceive(timer, perform: { input in
                                    let secondsSinceStart: Int = abs(Int(startTime.timeIntervalSinceNow)) + self.secondsAtPause
                                    let minutes = secondsSinceStart / 60
                                    let seconds = secondsSinceStart - (minutes * 60)
                                    timerString = String(format: "%02d:%02d", minutes, seconds)
                                    trackSpeakersState.timerSeconds = secondsSinceStart
                                    trackSpeakersState.timerString = timerString
                                })
                        }
                        .frame(maxWidth: 800)
                        .frame(height: 100)
                        .padding(.horizontal, 15.0)
                        .background(Color.init(white: 0.5))
                        .cornerRadius(7.0)
                        .padding(.trailing,50)
                        
                        
                        Spacer()
                        
                        
                        Group {
                            Button(action: {
                                playTimer()
                            })
                            {
                                Image(systemName: "play.fill")
                                    .resizable()
                            }
                            .buttonStyle(PlainButtonStyle())
                            .frame(width: 80, height: 80)
                            .disabled(playButton.disabled)
                            .foregroundColor(playButton.color)
                            
                            Spacer().fixedSize().frame(width:40)
                            
                            Button(action: {
                                pauseTimer()
                            })
                            {
                                Image(systemName: "pause.fill")
                                    .resizable()
                            }
                            .buttonStyle(PlainButtonStyle())
                            .frame(width: 80, height: 80)
                            .disabled(pauseButton.disabled)
                            .foregroundColor(pauseButton.color)
                            
                            Spacer().fixedSize().frame(width:40)
                            
                            Button(action: {
                                stopTimer()
                            })
                            {
                                Image(systemName: "stop.fill")
                                    .resizable()
                            }
                            .buttonStyle(PlainButtonStyle())
                            .frame(width: 80, height: 80)
                            .disabled(stopButton.disabled)
                            .foregroundColor(stopButton.color)
                        }
                        
                        Spacer()
                            .frame(width:40)
                        
                    }
                    
                    // The tables of speakers
                    HStack (alignment: .bottom, spacing: 20){
                        RemainingTableList(viewModel: presenter.speakersViewModel.remainingList.sectionLists, moveAction: $moveAction)
                        WaitingTableList(viewModel: presenter.speakersViewModel.waitingList.sectionLists, moveAction: $moveAction, reorderAction: $reorderAction)
                        SpeakingTableList(
                            viewModel: presenter.speakersViewModel.speakingList.sectionLists,
                            moveAction: $moveAction,
                            memberTimerActions: $memberTimerActions,
                            longPressAction: $longPressAction,
                            showNote: $showNote,
                            isRecording: $isRecording
                        )
                        
                        // Controls down right-hand side
                        VStack{
                            
                            Image(showClock == false ? "expand3" : "shrink3")
                                .resizable()
                                .frame(width:50, height: 50)
                                .padding(.top,40)
                                .foregroundColor(.white)
                                .onTapGesture(perform: {
                                    showClock.toggle()
                                })
                            
                            if isRecording {
                                
                                Button(action:  {
                                    saveDebate()
                                }) {
                                    Text("Save this\ndebate")
                                        .font(.system(size: 22))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .frame(alignment: .center)
                                        .padding(.top, 50)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Button(action: {
                                    saveEvent()
                                }) {
                                    Text("End this\nmeeting")
                                        .font(.system(size: 22))
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.white)
                                        .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .frame(alignment: .center)
                                        .padding(.top, 40)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .frame(width: 50.0, height: 50.0)
                                    .foregroundColor(.red)
                                    .padding(.top, 80)
                                Text("Recording on")
                                    .foregroundColor(.white)
                            }
                            else {
                                Text("Reset")
                                    .font(.system(size: 24))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.white)
                                    .frame(alignment: .center)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 50)
                                    .onTapGesture {
                                        stopTimer()
                                        timerString = "00:00"
                                        TrackSpeakersInteractor.reset(trackSpeakersState: trackSpeakersState)
                                    }
                                
                                Button(action: {withAnimation(.easeInOut(duration: EASEINOUT)) {
                                    self.showMeetingSetupSheet.toggle()
                                }}) {
                                    Text("Meeting\nsetup")
                                        .font(.system(size: 24))
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.white)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .multilineTextAlignment(.center)
                                        .padding(.top, 40)
                                }
                                .buttonStyle(PlainButtonStyle())

                                                                
                                Spacer().frame(height:100)
                                
#if os(iOS)
                                Image(systemName: "info.circle")
                                    .font(Font.system(size: 24))
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        showHelp.toggle()
                                    }
                                    .sheet(isPresented: $showHelp, content: {
                                        ShowHelpViewiOS(showHelp: $showHelp)
                                    })
#endif
                                //#if os(macOS)
                                //                                Button{
                                //                                    if let url = URL(string: "speakertracker://help") {
                                //                                        openURL(url)
                                //                                    }
                                //                                } label: {
                                //                                    Label("",systemImage: "info.circle").font(Font.system(size: 24))
                                //                                }
                                //                                .buttonStyle(PlainButtonStyle())
                                //#endif
#if os(macOS)
                                Image(systemName: "info.circle")
                                    .font(Font.system(size: 24))
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        showHelp.toggle()
                                    }
                                    .sheet(isPresented: $showHelp, content: {
                                        ShowHelpViewMacOS(showHelp: $showHelp)
                                    })
#endif
                            }
                            
                            
                            // Determines width of right-sidebar
                            Spacer().frame(width:130)
                            
                        }
                    }.padding(.leading, 20.0).padding(.bottom, 5).padding(.top,20)
                }
                .padding(.top, 15.0)
                //        .preferredColorScheme(.light)
                .background(Color(white: 0.4))
                .onAppear(perform: {
                    print("------ TrackSpeakersView .onAppear")
                    TrackSpeakersInteractor.fetchMembers(presenter: presenter, entityState: entityState, eventState: eventState, trackSpeakersState: trackSpeakersState)
                    if entityState.currentMeetingGroupIndex != nil {
                        selectedMeetingGroup = EntityState.meetingGroupWithIndex(index: entityState.currentMeetingGroupIndex!)
                        if selectedMeetingGroup != nil {
                            selectedMeetingGroupName = selectedMeetingGroup!.name
                        }
                    }
                    viewHasAppeared = true
                })
                .onReceive(self.trackSpeakersState.$tableCollection, perform: { newCollection in
                    if viewHasAppeared == true {
                        print("------ TrackSpeakersView onReceive trackSpeakersState.$tableCollection")
                        TrackSpeakersInteractor.fetchMembers(presenter: presenter, tableCollection: newCollection)
                    }
                })
                .onReceive(trackSpeakersState.$meetingGroupHasChanged, perform: { val in
                    if val == true {
                        print("------ TrackSpeakersView onReceive trackSpeakersState.$meetingGroupHasChanged")
                        trackSpeakersState.meetingGroupHasChanged = false
                        let meetingGroup = entityState.currentMeetingGroup!
                        selectedMeetingGroupName = meetingGroup.name
                        TrackSpeakersInteractor.fetchMembers(presenter: presenter, trackSpeakersState: trackSpeakersState, meetingGroupForRemainingTable: meetingGroup)
                    }
                })
                .onReceive(self.trackSpeakersState.$amendmentModeSet, perform: { set in
                    if set == true {
                        //            trackSpeakersState.resetForAmendment()
                    }
                })
                .onChange(of: moveAction, perform: { action in
                    print("------ onChange moveAction")
                    let interactor = TrackSpeakersInteractor()
                    interactor.moveMember(moveAction: action, trackSpeakersState: trackSpeakersState)
                })
                .onChange(of: reorderAction, perform: { action in
                    TrackSpeakersInteractor.reorderWaitingTable(reorderAction: action, trackSpeakersState: trackSpeakersState)
                })
                .onChange(of: memberTimerActions, perform: { action in
                    print("------ onChange memberTimerActions")
                    TrackSpeakersInteractor.setCurrentMemberTimerState(eventState: eventState, trackSpeakersState: trackSpeakersState, memberTimerAction: action)
                    if memberTimerActions.timerButtonPressed == .play {
                        playTimer()
                    }
                    if memberTimerActions.timerButtonPressed == .stop  {
                        stopTimer()
                    }
                    if memberTimerActions.timerButtonPressed == .pause  {
                        pauseTimer()
                    }
                })
                .onChange(of: longPressAction, perform: { action in
                    if action.type == .amendmentMover {
                        TrackSpeakersInteractor.addAmendment(trackSpeakersState: trackSpeakersState, entityState: entityState, action: action)
                    }
                    if action.type == .amendmentFinal {
                        TrackSpeakersInteractor.finaliseAmendment(trackSpeakersState: trackSpeakersState, action: action)
                    }
                    if action.type == .speakAgain {
                        TrackSpeakersInteractor().copyMemberToListEnd(trackSpeakersState: trackSpeakersState, action: action)
                    }
                })
                
                if self.showClock {
                    ClockOverlayView(timerString: $timerString)
                        .frame(width: geo.size.width - 150, height: geo.size.height - 140)
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(Color.gray, lineWidth: 3)
                                        .background(Color(white: 0.3, opacity: 0.98))
                        )
                        .offset(x: 10, y: 140)
                }
                
                if self.showNote {
                    VStack(spacing:0){
                        HStack {
                            Spacer()
                            Text("Add a note")
                            Spacer()
                        }
                        .background(.gray)
                        
                        TextEditor(text: $noteText)
                            .disableAutocorrection(true)
                    }
                    .frame(width: 300, height:200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .background(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color.gray, lineWidth: 2))
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    .onAppear(perform: {
                        noteText = ""
                    })
                    .onDisappear(perform: {
                        TrackSpeakersInteractor.addNoteToDebate(eventState: eventState, note: noteText)
                    })
                    
                }
            }
        }
    }
    
    func saveDebate() {
        TrackSpeakersInteractor.saveDebate(eventState: eventState, trackSpeakersState: trackSpeakersState)
    }
    
    func saveEvent() {
        TrackSpeakersInteractor.saveMeetingEvent(eventState: eventState)
        isRecording = false
    }
    
    func playTimer() {
        if self.pausePressed == true {
            self.pausePressed = false
        }
        //      self.secondsAtPause = 0
        self.startTime = Date()
        self.playButton = PlayButtonState(disabled: true)
        self.pauseButton = PauseButtonState(disabled: false)
        self.stopButton = StopButtonState(disabled: false)
        self.timer = Timer.publish(every: 1, on: .main, in: .common)
        let _ = self.timer.connect()
    }
    
    func pauseTimer() {
        self.pausePressed = true
        self.playButton = PlayButtonState(disabled: false)
        self.pauseButton = PauseButtonState(disabled: true)
        self.stopButton = StopButtonState(disabled: false)
        self.secondsAtPause = abs(Int(startTime.timeIntervalSinceNow)) + self.secondsAtPause
        self.timer.connect().cancel()
    }
    
    func stopTimer() {
        self.playButton = PlayButtonState(disabled: false)
        self.pauseButton = PauseButtonState(disabled: true)
        self.stopButton = StopButtonState(disabled: true)
        self.secondsAtPause = 0
        self.timer.connect().cancel()
    }
}

struct TrackSpeakersView_Previews: PreviewProvider {
    @State static var showMeetingSetupSheet = false
    @State static var selectedEntityName = ""
    @State static var isRecording = false
    @State static var selectedMeetingGroup: MeetingGroup?
    
    //    @EnvironmentObject static var trackSpeakersState: TrackSpeakersState
    //    static var viewContext = PersistenceController.preview.container.viewContext
    
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let meetingGroup = MeetingGroup(context: context)
        meetingGroup.name = "Test meeting group"
        
        return TrackSpeakersView(
            showMeetingSetupSheet: $showMeetingSetupSheet,
            selectedMeetingGroup: .constant(meetingGroup),
            isRecording: $isRecording
        )
            .previewInterfaceOrientation(.landscapeRight)
            .environmentObject(EventState())
            .environmentObject(EntityState())
            .environmentObject(TrackSpeakersState())
            .environment(\.managedObjectContext, context)
            .environment(\.colorScheme, .light)
    }
    
    //    static var previews: some View {
    //        Text("Testing")
    //            .previewInterfaceOrientation(.landscapeRight)
    //    }
}
