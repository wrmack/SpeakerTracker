//
//  TrackSpeakersView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 14/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine

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



struct TrackSpeakersView: View {
    
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
    @State var memberTimerActions = MemberTimerActions()
    @State var longPressAction = LongPressAction()
    @Binding var showMeetingSetupSheet: Bool
    @Binding var selectedMeetingGroup: MeetingGroup?
    @Binding var isRecording: Bool
    
    
    var body: some View {
        Print(">>>>>> TrackSpeakersView body")
        VStack(){
            HStack {
                Spacer().fixedSize(horizontal: true, vertical: false).frame(width:100, height:1)
                HStack {
                    if let name = selectedMeetingGroup?.name {
                    Text(name)
                        .fontWeight(.regular)
                        .foregroundColor(Color.white)
                        .font(.system(size: 30))
                    }
                    else {
                        Text("No meeting group selected")
                            .fontWeight(.light)
                            .foregroundColor(Color(white: 0.7))
                            .font(.system(size: 30))
                    }
                    Spacer()
                    Text(self.timerString)
                        .fontWeight(.medium)
                        .foregroundColor(Color.white)
                        .font(.custom("Arial Rounded MT Bold", size: 92))
                        .onReceive(timer, perform: { input in
                            let secondsSinceStart: Int = abs(Int(startTime.timeIntervalSinceNow)) + self.secondsAtPause
                            let minutes = secondsSinceStart / 60
                            let seconds = secondsSinceStart - (minutes * 60)
                            timerString = String(format: "%02d:%02d", minutes, seconds)
                            trackSpeakersState.timerSeconds = secondsSinceStart
                            trackSpeakersState.timerString = timerString
                        })
                }
                .padding(.horizontal, 15.0)
                .background(Color.init(white: 0.5))
                .cornerRadius(7.0)
                
                Spacer()
                    .fixedSize(horizontal: true, vertical: false).frame(width:50, height:1)
                
                Group {
                    Button(action: {
                        playTimer()
                    })
                    {
                        Image(systemName: "play.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    .disabled(playButton.disabled)
                    .foregroundColor(playButton.color)
                    
                    Spacer().fixedSize().frame(width:40)
                    
                    Button(action: {
                        pauseTimer()
                    })
                    {
                        Image(systemName: "pause.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    .disabled(pauseButton.disabled)
                    .foregroundColor(pauseButton.color)
                    
                    Spacer().fixedSize().frame(width:40)
                    
                    Button(action: {
                        stopTimer()
                    })
                    {
                        Image(systemName: "stop.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    .disabled(stopButton.disabled)
                    .foregroundColor(stopButton.color)
                }
                
                Spacer()
                    .fixedSize(horizontal: true, vertical: false).frame(width:20, height:1)
                
            }
            
            HStack (alignment: .bottom, spacing: 20){
                RemainingTableList(viewModel: presenter.speakersViewModel.remainingList.sectionLists, moveAction: $moveAction)
                WaitingTableList(viewModel: presenter.speakersViewModel.waitingList.sectionLists, moveAction: $moveAction)
                SpeakingTableList(viewModel: presenter.speakersViewModel.speakingList.sectionLists, moveAction: $moveAction, memberTimerActions: $memberTimerActions, longPressAction: $longPressAction)
                VStack{
                    if isRecording {

                        Button(action:  {
                            saveDebate()
                        }) {
                            Text("End this debate")
                                .font(.system(size: 28))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .frame(alignment: .trailing)
                                .padding(.trailing, 10)
                                .padding(.top, 40)
                        }
                        Button(action: {
                            saveEvent()
                        }) {
                            Text("End this meeting")
                                .font(.system(size: 28))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .frame(alignment: .trailing)
                                .padding(.trailing, 10)
                                .padding(.top, 40)
                        }
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 60.0, height: 60.0)
                            .foregroundColor(.red)
                            .padding(.top, 50)
                        Text("Recording on")
                            .foregroundColor(.white)
                    }
                    else {
                        Text("Reset")
                            .font(.system(size: 28))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white)
                            .onTapGesture {
                                let interactor = TrackSpeakersInteractor()
                                interactor.reset(trackSpeakersState: trackSpeakersState)
                            }
                    
                        Spacer().fixedSize(horizontal: true, vertical: true).frame(width: 140, height: 50)
                        Button(action: {withAnimation(.easeInOut(duration: EASEINOUT)) {
                            self.showMeetingSetupSheet.toggle()
                        }}) {
                            Text("Meeting setup")
                                .font(.system(size: 28))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .frame(alignment: .trailing)
                                .padding(.trailing, 10)
                                .padding(.top, 40)
                        }
                    }
                        
                    Spacer().fixedSize(horizontal: true, vertical: true).frame(width: 140, height: 400)
                }
            }.padding(.leading, 20.0).padding(.bottom, 5).padding(.top,20)
        }
        .padding(.top, 15.0)
        .background(Color.gray)
        .onAppear(perform: {
            print("------ TrackSpeakersView .onAppear")
            print("****** fetching members on appear")
            let interactor = TrackSpeakersInteractor()
            interactor.fetchMembers(presenter: presenter, entityState: entityState, eventState: eventState, trackSpeakersState: trackSpeakersState)
            viewHasAppeared = true
        })
//        .onReceive(self.presenter.$presenterUp, perform: { _ in
//            // Once presenter is ready, set everything up
//            // Interactor: Fetch all members and send to presenter
//            // Presenter: Extract names in order to populate the Remaining list
//            print("------ TrackSpeakersView onReceive presenter.$presenterUp")
//            print("****** fetching members on presenter.$presenterUp")
//            let interactor = TrackSpeakersInteractor()
//            interactor.fetchMembers(presenter: presenter, entityState: entityState, trackSpeakersState: trackSpeakersState)
//        })
        .onReceive(self.trackSpeakersState.$tableCollection, perform: { newCollection in
            if viewHasAppeared == true {
            print("------ TrackSpeakersView onReceive trackSpeakersState.$tableCollection")
            print("****** fetching members on trackSpeakersState.$tableCollection")
            let interactor = TrackSpeakersInteractor()
            interactor.fetchMembers(presenter: presenter, tableCollection: newCollection)
            }
        })
        .onReceive(self.trackSpeakersState.$currentMeetingGroup) { meetingGroup in
            if viewHasAppeared == true {
            print("------ TrackSpeakersView onReceive trackSpeakersState.$currentMeetingGroup")
            print("****** fetching members on trackSpeakersState.$currentMeetingGroup")
            let interactor = TrackSpeakersInteractor()
            interactor.fetchMembers(presenter: presenter, trackSpeakersState: trackSpeakersState, meetingGroupForRemainingTable: meetingGroup)
            }
        }
        .onReceive(self.trackSpeakersState.$amendmentModeSet, perform: { set in
            if set == true {
                //            trackSpeakersState.resetForAmendment()
            }
        })
        .onChange(of: moveAction, perform: { action in
            let interactor = TrackSpeakersInteractor()
            interactor.moveMember(moveAction: action, trackSpeakersState: trackSpeakersState)
        })
        .onChange(of: memberTimerActions, perform: { action in
            print("member timer action")
            let interactor = TrackSpeakersInteractor()
            interactor.setCurrentMemberTimerState(trackSpeakersState: trackSpeakersState, memberTimerAction: action)
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
                let interactor = TrackSpeakersInteractor()
                interactor.addAmendment(trackSpeakersState: trackSpeakersState, action: action)
            }
            if action.type == .amendmentFinal {
                let interactor = TrackSpeakersInteractor()
                interactor.finaliseAmendment(trackSpeakersState: trackSpeakersState, action: action)
            }
        })
    }
    
    func saveDebate() {
        let interactor = TrackSpeakersInteractor()
        interactor.saveDebateToTrackSpeakersState(trackSpeakersState: trackSpeakersState)
    }
    
    func saveEvent() {
        let interactor = TrackSpeakersInteractor()
        interactor.saveEventToDisk(trackSpeakersState: trackSpeakersState)
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
    @State static var isRecording = true
    @EnvironmentObject static var trackSpeakersState: TrackSpeakersState
    @EnvironmentObject static var entityState: EntityState
    
    static var previews: some View {
        TrackSpeakersView(
            showMeetingSetupSheet: $showMeetingSetupSheet,
            selectedMeetingGroup: .constant(MeetingGroup(name: "Finance and Performance Committee", memberIDs: nil, fileName: nil)),
            isRecording: $isRecording
        )
        .previewDevice("iPad Pro (12.9-inch) (5th generation)")
        .previewDisplayName("iPad Pro (12.9-inch)")
        .previewLayout(.fixed(width: 1366, height: 1024))
        .environmentObject(EntityState())
        .environmentObject(EventState())
        .environmentObject(TrackSpeakersState())
    }
}
