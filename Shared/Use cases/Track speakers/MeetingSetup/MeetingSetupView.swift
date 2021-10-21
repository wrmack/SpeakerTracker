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
                        //                            .foregroundColor(.black)
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

                    Menu(selectedEntityName) {
                        ForEach(entityNames.indices, id: \.self) { idx in
                            Button(entityNames[idx], action: { changeEntity(row: idx)})
                        }
                    }
                    .frame(width: 200)

                    
                    Text("Meeting group")
                        .fontWeight(.semibold)
                        .padding(.top, 40)
                    
                    Menu(selectedMeetingGroupName) {
                        ForEach(meetingGroupNames.indices, id: \.self) { idx in
                            Button(meetingGroupNames[idx], action: {
                                changeMeetingGroup(row: idx)})
                        }
                    }
                    .frame(width: 200)
                    
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
                        
                        Menu(selectedMeetingEventName)  {
                            ForEach(meetingEventNames.indices, id: \.self) { idx in
                                Button(meetingEventNames[idx], action: {  changeMeetingEvent(row: idx)})
                            }
                        }
                        .frame(width: 200)
                    }
                    Spacer()
                }
                .frame(width:300)
                .padding(.leading, 30)
                .padding(.trailing, 30)
                //        .background(SETUP_SHEET_BACKGROUND_COLOR)
                .background(Color(white: 0.4, opacity: 1.0))
                .border(Color(white: 0.4), width: 1)
                .onAppear(perform: {
                    entityNames = MeetingSetupInteractor.fetchEntityNames(entityState: entityState, trackSpeakersState: trackSpeakersState,  presenter: presenter)
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
                Create entities, their members and \
                meeting groups in 'Entity setup'.
                
                Select an Entity and a Meeting group \
                in order to display members.
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
//        .background(Color.orange)
        
    }
    
    func changeEntity(row: Int) {
        let selectedEntity = MeetingSetupInteractor.fetchEntityForRow(entityState: entityState, trackSpeakersState: trackSpeakersState, row: row)
        selectedEntityName = selectedEntity.0
        meetingGroupNames = selectedEntity.1
        //        meetingGroups = selectedEntity.meetingGroups?.allObjects as? [MeetingGroup]
    }
    
    func changeMeetingGroup(row: Int) {
        selectedMeetingGroupName = MeetingSetupInteractor.fetchMeetingGroupForRow(trackSpeakersState: trackSpeakersState, row: row)
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
    
    @State static var showSetupInfo = false
    @State static var showMeetingSetupSheet = false
    @State static var selectedEntityName = ""
    @State static var selectedMeetingGroupName = ""
    @State static var isRecording = true
    
    
    static var previews: some View {
        MeetingSetupSheetView(showMeetingSetupSheet: $showMeetingSetupSheet, isRecording: $isRecording)
        //        .previewDevice("iPad Pro (12.9-inch) (4th generation)")
        //        .previewDisplayName("iPad Pro (12.9-inch)")
            .previewLayout(.fixed(width: 600, height: 1024))
            .environmentObject(TrackSpeakersState())
            .environmentObject(EntityState())
            .environmentObject(EventState())
    }
    
}
