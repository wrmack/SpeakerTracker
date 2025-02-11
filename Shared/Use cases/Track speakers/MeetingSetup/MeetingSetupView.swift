//
//  MeetingSetupSheet.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 17/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import SwiftUI





struct MeetingSetupView: View {
    @EnvironmentObject var entityState: EntityState
    @EnvironmentObject var eventState: EventState
    @EnvironmentObject var trackSpeakersState: TrackSpeakersState
    @StateObject var presenter = MeetingSetupPresenter()
    @State var showSetupInfo = false
    @State var showReportInfo = false
    @State var showIndividualInfo = false
    @State var entityNames = [String]()
    @State var meetingGroupNames = [String]()
    @State var meetingEventNames = [String]()
    @State var selectedMeetingEventIndex: Int?
    @State var selectedEntityName = ""
    @State var selectedMeetingGroupName = ""
    @State var selectedMeetingEventName = ""
    @State var showEvents = false
    @State var showIndividualTime = UserDefaults.standard.bool(forKey: "showIndividualTime")
    @Binding var showMeetingSetupSheet: Bool
    @Binding var isRecording: Bool
    
    
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack {
                VStack(alignment:.leading) {
                    Group {
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
                        
                        Text("Entity")
                            .fontWeight(.semibold)
                            .padding(.top, 40)
                        
                        Menu {
                            ForEach(entityNames.indices, id: \.self) { idx in
                                Button(entityNames[idx], action: { onChangeOfEntity(row: idx)})
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
                                    onChangeOfMeetingGroup(row: idx)})
                            }
                        } label: {
                            Label(selectedMeetingGroupName, systemImage:"bolt.fill")
                                .labelStyle(MyLabelStyle())
                        }
                        .menuStyle(MyMenuStyle())
                    }
                    Group {
                        Image(systemName: "info.circle")
                            .onTapGesture {
                                showIndividualInfo = showIndividualInfo ? false : true
                            }
                            .padding(.top, 40)
                        
                        Toggle(isOn: $showIndividualTime) {
                            Text("Show individual member times")
                                .fontWeight(.semibold)
                        }
                        .padding(.top, 20)
                        .padding(.trailing, 40)
                        .disabled(selectedEntityName == "None" ? true : false)
                        .onChange(of: showIndividualTime, perform: { newValue in
                            UserDefaults.standard.set(newValue, forKey:"showIndividualTime")
                            trackSpeakersState.showMemberTimer = newValue
                        }
                        )
                        
                        Image(systemName: "info.circle")
                            .onTapGesture {
                                showReportInfo = showReportInfo ? false : true
                            }
                            .padding(.top, 40)
                        
                        Toggle(isOn: $showEvents) {
                            Text("Create a record of speaking times for this meeting")
                                .fontWeight(.semibold)
                        }
                        .padding(.top, 20)
                        .padding(.trailing, 40)
                        .disabled(selectedEntityName == "None" || selectedMeetingGroupName == "None"  || showIndividualTime == false ? true : false)
                        
                        if showEvents == true {
                            //                        Spacer().fixedSize().frame(height: 40)
                            
                            Text("Meeting event")
                                .fontWeight(.semibold)
                                .padding(.top, 20)
                            
                            Menu  {
                                ForEach(meetingEventNames.indices, id: \.self) { idx in
                                    Button(meetingEventNames[idx], action: {  onChangeOfMeetingEvent(row: idx)})
                                }
                            } label: {
                                Label(selectedMeetingEventName, systemImage:"bolt.fill")
                                    .labelStyle(MyLabelStyle())
                            }
                            .menuStyle(MyMenuStyle())
                            
                        }
                        Spacer()
                    }
                }
                .frame(width:300)
                .padding(.leading, 30)
                .padding(.trailing, 30)
                #if os(iOS)
                .background(Color(uiColor: .systemGray4))
                #endif
                #if os(macOS)
                .background(Color(nsColor: NSColor.windowBackgroundColor))
                #endif
                .opacity(1.0)
                .border(Color(white: 0.4), width: 1)
                .onAppear(perform: {
                    entityNames = MeetingSetupInteractor.fetchEntityNames(entityState: entityState, presenter: presenter)
                    showIndividualTime = trackSpeakersState.showMemberTimer
                })
                .onReceive(presenter.$setupViewModel, perform: { viewModel in
                    selectedEntityName = viewModel.entityName
                    let selectedMeetingGroupNameWithId = viewModel.meetingGroupNameWithId
                    selectedMeetingGroupName = selectedMeetingGroupNameWithId.0
                    if (selectedEntityName != "") && (selectedMeetingGroupName != "") {
                        entityNames.enumerated().forEach{idx, entityName in
                            if entityName == selectedEntityName {
                                let selectedEntity = MeetingSetupInteractor.fetchEntityForRow(entityState: entityState, trackSpeakersState: trackSpeakersState, row: idx)
                                setMeetingGroupNames(selectedEntity: selectedEntity)
                                let mtgGroupNameIds = selectedEntity.1
                                mtgGroupNameIds.enumerated().forEach({ idx, mtgGpId in
                                    let name = mtgGpId.0
                                    let id = mtgGpId.1
                                    if (name == selectedMeetingGroupName) && (id == selectedMeetingGroupNameWithId.1) {
                                        onChangeOfMeetingGroup(row: idx)
                                    }
                                    
                                })
                            }
                        }
                    }
                })
                .onTapGesture {
                    withAnimation(.easeInOut(duration: EASEINOUT)) {
                        showSetupInfo = false
                        showReportInfo = false
                        showIndividualInfo = false
                    }
                }
                Spacer()
            }
            if showSetupInfo {
                HStack{
                    Text(
                """
                Display the members of a meeting group \
                by selecting the entity and the meeting group.
                
                To create an entity, its members and \
                its meeting groups, go to the 'Setup' tab.
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
            if showIndividualInfo {
                HStack {
                    Text(
                    """
                    After setting an Entity and Meeting group, \
                    turn on 'Show individual member times' to \
                    display each member's time alongside the member's \
                    name.
                    
                    Use the Play, Pause and Stop controls alongside \
                    the member's name to control the member's speaking time.
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
                    'Create a record of speaking times for this meeting' \
                    saves speaking times to the chosen meeting event \
                    (meeting events are created separately in Setup).
                    
                    The Entity and Meeting group must have been selected \
                    and 'Show individual member times' must be turned on .
                    
                    Press 'Save debate'to save the current debate and \
                    create a new one.
                    
                    Press 'End this meeting' to complete the report \
                    and reset.
                    
                    View the report in 'Reports'.
                    
                    To create a meeting event, go to the Setup tab then select Events.
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

    func setMeetingGroupNames(selectedEntity: (String, [(String, UUID)])) {
        let mtgGpNamesWithIds = selectedEntity.1
        var mtgGroupNames = [String]()
        mtgGpNamesWithIds.forEach { (nameWithId) in
            let name = nameWithId.0
            mtgGroupNames.append(name)
        }
        meetingGroupNames = mtgGroupNames
    }
    
    func onChangeOfEntity(row: Int) {
        let selectedEntity = MeetingSetupInteractor.fetchEntityForRow(entityState: entityState, trackSpeakersState: trackSpeakersState, row: row)
        selectedEntityName = selectedEntity.0
        setMeetingGroupNames(selectedEntity: selectedEntity)
    }
    
    func onChangeOfMeetingGroup(row: Int) {
        let selectedMeetingGroup = MeetingSetupInteractor.fetchMeetingGroupForRow(entityState: entityState, trackSpeakersState: trackSpeakersState, row: row)
        selectedMeetingGroupName = selectedMeetingGroup.0
        meetingEventNames = selectedMeetingGroup.1
    }
    
    func onChangeOfMeetingEvent(row: Int) {
        MeetingSetupInteractor.setCurrentMeetingEvent(entityState: entityState,
            trackSpeakersState: trackSpeakersState,
            eventState: eventState,
            row: row
        )
        isRecording = true
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
