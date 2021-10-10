//
//  MeetingSetupSheet.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 17/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import SwiftUI

struct MeetingSetupSheetView: View {
    @EnvironmentObject var entityState: EntityState
    @EnvironmentObject var eventState: EventState
    @EnvironmentObject var trackSpeakersState: TrackSpeakersState
    @StateObject var presenter = MeetingSetupPresenter()
    @Binding var showMeetingSetupSheet: Bool
    @State var showSetupInfo = false
    @State var showReportInfo = false
    @State var selectedEntityIndex: Int?
    @State var selectedMeetingGroupIndex: Int?
    @State var selectedMeetingEventIndex: Int?
    @State var selectedEntityName = ""
    @State var selectedMeetingGroupName = ""
    @State var selectedMeetingEventName = ""
    @State var meetingGroups: [MeetingGroup]?
    @Binding var selectedMeetingGroup: MeetingGroup?
    @Binding var isRecording: Bool
    
    var body: some View {
        VStack(alignment:.leading) {
            ZStack {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        Text("Meeting setup")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.top, 20)
                            .padding(.bottom,40)
                        Spacer()
                    }

                    Image(systemName: "info.circle")
                        .onTapGesture {
                            showSetupInfo = showSetupInfo ? false : true
                        }

                    HStack{
                    Text("Entity")
                        .fontWeight(.semibold)
                        .padding(.top, 30)
                    }
                    HStack {
                        Menu {
                            ForEach(entityState.sortedEntities!.indices, id: \.self) { idx in
                                Button(entityState.sortedEntities![idx].name!, action: { changeEntity(row: idx)})
                            }
                        } label: {
                            Text("Change")
                        }.padding(.trailing, 20)
                        TextField("Select an entity", text: $selectedEntityName)
                    }
                }
                if showSetupInfo {
                    Text(
                    """
                    Create entities, their members and \
                    meeting groups in 'Entity setup'.
                    
                    Select an Entity and a Meeting group \
                    in order to display members.
                    """
                    )
                    .frame(width: 300)
                    .font(Font.system(size: 14))
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10.0)
                }
                if showReportInfo {
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
                    .frame(width: 300)
                    .font(Font.system(size: 14))
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10.0)
                }
            }
            Text("Meeting group")
                .fontWeight(.semibold)
                .padding(.top, 40)
            HStack {
//                if meetingGroups != nil && meetingGroups!.count > 0 {
//                    Menu {
//                        ForEach(meetingGroups!.indices, id: \.self) { idx in
//                            Button(entityState.entities[selectedEntityIndex ?? 0].meetingGroups![idx].name!, action: {
//                                    changeMeetingGroup(row: idx)})
//                        }
//                    } label: {
//                        Text("Change")
//                    }.padding(.trailing, 20)
//                }
//
//                TextField("Select a meeting group", text: $selectedMeetingGroupName)
            }

            Toggle(isOn: $isRecording) {
                Text("Create a report of this meeting")
                    .fontWeight(.semibold)
            }
            .padding(.top, 40)
            .padding(.trailing, 40)
            
            if isRecording == true {
                Spacer().fixedSize().frame(height: 40)
                HStack {
//                    Menu {
//                        ForEach(eventState.events.indices, id: \.self) { idx in
//                            Button(eventState.events[idx].filename!, action: { changeMeetingEvent(row: idx)})
//                        }
//                    } label: {
//                        Text("Change")
//                    }.padding(.trailing, 20)
//                    TextField("Select an existing meeting event", text: $selectedMeetingEventName)
//                        .frame(width: 300)
//                    Image(systemName: "info.circle")
//                        .onTapGesture {
//                            showReportInfo = showReportInfo ? false : true
//                        }
//                    Spacer()
                }
                    
            }
            Spacer()

            Button("Done", action: {withAnimation(.easeInOut(duration: EASEINOUT)) {
                self.showMeetingSetupSheet = false
            }})
            .padding(.bottom,150)
            
        }
        .padding(.leading, 30)
        .background(SETUP_SHEET_BACKGROUND_COLOR)
        .border(Color(white: 0.4), width: 1)
        .onAppear(perform: {
            let interactor = MeetingSetupInteractor()
            interactor.fetchMeetingSetup(trackSpeakersState: trackSpeakersState,  presenter: presenter)
        })
        .onReceive(presenter.$setupViewModel, perform: { viewModel in
            selectedEntityName = viewModel.entityName
            selectedMeetingGroupName = viewModel.meetingGroupName
        })
    }
    
    func changeEntity(row: Int) {
//        let interactor = MeetingSetupInteractor()
//        let selectedEntity = interactor.fetchEntityForRow(entityState: entityState, trackSpeakersState: trackSpeakersState, row: row)
//        selectedEntityName = selectedEntity.name!
//        meetingGroups = selectedEntity.meetingGroups
//        selectedEntityIndex = row
    }

    func changeMeetingGroup(row: Int) {
//        let interactor = MeetingSetupInteractor()
//        let selectedMeetingGroup = interactor.fetchMeetingGroupForRow(entityState: entityState, trackSpeakersState: trackSpeakersState, selectedEntityIndex: selectedEntityIndex!, row: row)
//        self.selectedMeetingGroup = selectedMeetingGroup
//        selectedMeetingGroupName = selectedMeetingGroup.name!
//        selectedMeetingGroupIndex = row
    }
    
    func changeMeetingEvent(row: Int) {
//        let interactor = MeetingSetupInteractor()
//        let selectedMeetingEvent = interactor.fetchMeetingEventForRow(eventState: eventState, trackSpeakersState: trackSpeakersState, row: row)
//        selectedMeetingEventName = selectedMeetingEvent.filename!
//        selectedMeetingEventIndex = row
//        showMeetingSetupSheet = false
    }
}

struct MeetingSetupSheetView_Previews: PreviewProvider {
    @State static var showMeetingSetupSheet = false
    @State static var selectedEntityName = ""
    @State static var selectedMeetingGroupName = ""
    @State static var selectedMeetingGroup: MeetingGroup?
    @State static var isRecording = true
    @State static var showSetupInfo = true
    @EnvironmentObject static var trackSpeakersState: TrackSpeakersState
    @EnvironmentObject static var entityState: EntityState
    @EnvironmentObject static var eventState: EventState
    
    static var previews: some View {
        MeetingSetupSheetView(
            showMeetingSetupSheet: $showMeetingSetupSheet,
            showSetupInfo: showSetupInfo,
            selectedMeetingGroup: $selectedMeetingGroup,
            isRecording: $isRecording
        )
//        .previewDevice("iPad Pro (12.9-inch) (4th generation)")
//        .previewDisplayName("iPad Pro (12.9-inch)")
//        .previewLayout(.fixed(width: 1322, height: 1024))
        .environmentObject(TrackSpeakersState())
        .environmentObject(EntityState())
        .environmentObject(EventState())
    }
    
}
