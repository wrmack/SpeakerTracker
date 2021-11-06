//
//  MeetingSetupSheet.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 17/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import SwiftUI


struct MyMenuStyle: MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .background(Color(white: 0.65))
    }
}

struct MyLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        Label{
            configuration.title
        } icon: {
//            configuration.icon.frame(maxWidth:1)
        }
            .frame(width: 300, height:20)
            .contentShape(Rectangle())
    }
}


struct MeetingSetupView: View {
    @EnvironmentObject var entityState: EntityState
    @EnvironmentObject var eventState: EventState
    @EnvironmentObject var trackSpeakersState: TrackSpeakersState
    @StateObject var presenter = MeetingSetupPresenter()
    @State var showSetupInfo = false
    @State var showReportInfo = false
    @State var entityNames = [String]()
    @State var meetingGroupNames = [String]()
    @State var meetingEventNames = [String]()
    //    @State var selectedMeetingGroupIndex: Int?
    @State var selectedMeetingEventIndex: Int?
    @State var selectedEntityName = "Change"
    @State var selectedMeetingGroupName = "Change"
    @State var selectedMeetingEventName = "Change"
    //    @State var meetingGroups: [MeetingGroup]?
    //    @Binding var selectedMeetingGroup: MeetingGroup?
    @Binding var showMeetingSetupSheet: Bool
    @Binding var isRecording: Bool
    
    
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack {
                VStack(alignment:.leading) {
                    HStack {
                        Spacer()
                        Text("Meeting setup")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                            .padding(.bottom,40)
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "info.circle")
                            .onTapGesture {
                                showSetupInfo = showSetupInfo ? false : true
                            }
                        Spacer()
                        Button("Done", action: {withAnimation(.easeInOut(duration: EASEINOUT)) {
                            self.showMeetingSetupSheet = false
                        }})
                    }
                    .padding(.bottom, 30)
                    
                    Text("Entity")
                        .fontWeight(.semibold)
                        .padding(.top, 30)
                    
                    Menu {
                        ForEach(entityNames.indices, id: \.self) { idx in
                            Button(entityNames[idx], action: { changeEntity(row: idx)})
                        }
                    } label: {
                        Label(selectedEntityName, systemImage:"bolt.fill")
                        .labelStyle(MyLabelStyle())
                    }
                    .menuStyle((MyMenuStyle()))
                    
                    Text("Meeting group")
                        .fontWeight(.semibold)
                        .padding(.top, 40)
                    
                    Menu {
                        ForEach(meetingGroupNames.indices, id: \.self) { idx in
                            Button(meetingGroupNames[idx], action: {
                                changeMeetingGroup(row: idx)})
                        }
                    } label: {
                        Label(selectedMeetingGroupName, systemImage:"bolt.fill")
                            .labelStyle(MyLabelStyle())
                    }
                    .menuStyle(MyMenuStyle())
                    
                    Toggle(isOn: $isRecording) {
                        Text("Create a report")
                            .fontWeight(.semibold)
                    }
                    .padding(.top, 40)
                    .padding(.trailing, 40)
                    
                    if isRecording == true {
                        Spacer().fixedSize().frame(height: 40)
                        Image(systemName: "info.circle")
                            .onTapGesture {
                                showReportInfo = showReportInfo ? false : true
                            }
                        Text("Meeting")
                            .fontWeight(.semibold)
                            .padding(.top, 40)
                        
                        Menu  {
                            ForEach(meetingEventNames.indices, id: \.self) { idx in
                                Button(meetingEventNames[idx], action: {  changeMeetingEvent(row: idx)})
                            }
                        } label: {
                            Label(selectedMeetingEventName, systemImage:"bolt.fill")
                                .labelStyle(MyLabelStyle())
                        }
                        .menuStyle(MyMenuStyle())

                    }
                    Spacer()
                }
                .frame(width:300)
                .padding(.leading, 30)
                .padding(.trailing, 30)
                //        .background(SETUP_SHEET_BACKGROUND_COLOR)
                .background(Color(white: 0.6, opacity: 1.0))
                .border(Color(white: 0.4), width: 1)
                .onAppear(perform: {
                    entityNames = MeetingSetupInteractor.fetchEntityNames(entityState: entityState, presenter: presenter)
                })
                .onReceive(presenter.$setupViewModel, perform: { viewModel in
                    selectedEntityName = viewModel.entityName
                    selectedMeetingGroupName = viewModel.meetingGroupName
                })
                .onTapGesture {
                    withAnimation(.easeInOut(duration: EASEINOUT)) {
                        showSetupInfo = false
                        showReportInfo = false
                    }
                }
                Spacer()
            }
            if showSetupInfo {
                HStack{
                    Text(
                """
                Select an entity and a meeting group \
                in order to display the meeting group's
                members.
                
                To create entities, their members and \
                meeting groups go to the 'Setup' tab.
                """
                    )
                        .frame(width: 400)
                        .font(Font.system(size: 14))
                        .padding(10)
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .cornerRadius(10.0)
                }
                .padding(.leading,30)
            }
            if showReportInfo {
                HStack {
                    Text(
                    """
                    Speaking times for each debate are recorded.
                    
                    Create meeting events in Entity setup.
                    
                    A debate is saved and a new one created after \
                    'Save debate' is pressed.
                    Press 'End this meeting' to complete the report \
                    and reset.
                    
                    The report can be viewed in 'Reports'
                    """
                    )
                        .frame(width: 400)
                        .font(Font.system(size: 14))
                        .padding(10)
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .cornerRadius(10.0)
                }
                .padding(.leading,30)
            }
            
            
        }
        .frame(width:500)
        
        
    }
    
    func changeEntity(row: Int) {
        let selectedEntity = MeetingSetupInteractor.fetchEntityForRow(entityState: entityState, trackSpeakersState: trackSpeakersState, row: row)
        selectedEntityName = selectedEntity.0
        meetingGroupNames = selectedEntity.1
    }
    
    func changeMeetingGroup(row: Int) {
        let selectedMeetingGroup = MeetingSetupInteractor.fetchMeetingGroupForRow(entityState: entityState, trackSpeakersState: trackSpeakersState, row: row)
        selectedMeetingGroupName = selectedMeetingGroup.0
        meetingEventNames = selectedMeetingGroup.1
    }
    
    func changeMeetingEvent(row: Int) {
        MeetingSetupInteractor.setCurrentMeetingEvent(entityState: entityState,
            trackSpeakersState: trackSpeakersState,
            eventState: eventState,
            row: row
        )
        
        showMeetingSetupSheet = false
    }
}

struct MeetingSetupView_Previews: PreviewProvider {
    
    @State static var showSetupInfo = false
    @State static var showMeetingSetupSheet = false
    @State static var isRecording = true
    
    
    static var previews: some View {
        MeetingSetupView(showMeetingSetupSheet: $showMeetingSetupSheet, isRecording: $isRecording)
        //        .previewDevice("iPad Pro (12.9-inch) (4th generation)")
        //        .previewDisplayName("iPad Pro (12.9-inch)")
            .previewLayout(.fixed(width: 600, height: 1024))
            .environmentObject(TrackSpeakersState())
            .environmentObject(EntityState())
            .environmentObject(EventState())
    }
    
}
