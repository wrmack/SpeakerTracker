//
//  ContentView.swift
//  Shared
//
//  Created by Warwick McNaughton on 1/10/21.
//
import SwiftUI

struct SheetState {
    var showSheet = false
    var editMode = 0  // 0 = add, 1 = edit, 2 = delete
}



struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var sheetState = SheetState()
    @State private var showMeetingSetupSheet = false
    @State private var presentMembersSheet = false
    @State private var selectedMeetingGroup: MeetingGroup?
    @State private var isRecording = false
    @State private var selectedSetupTab = 0
    @State private var selectedSetupMasterRow = 0
    
    
    var speakers:[Member] = []
    
    var body: some View {
        Print(">>>>>> ContentView body refreshed")
        VStack(spacing: 0) {
            
            TabView {
                
                // Track speaker main scene
                VStack {
                    GeometryReader { geo in
                        TrackSpeakersView(showMeetingSetupSheet: $showMeetingSetupSheet, selectedMeetingGroup: $selectedMeetingGroup, isRecording: $isRecording)
                        ZStack {
                            if self.showMeetingSetupSheet {
                                HStack {
                                    MeetingSetupSheetView(
                                        showMeetingSetupSheet: self.$showMeetingSetupSheet,
                                        selectedMeetingGroup: $selectedMeetingGroup,
                                        isRecording: $isRecording
                                    )
                                    .frame(maxWidth:500, minHeight:geo.size.height)
                                    .background(Color.white)
                                }
                                .transition(.move(edge: .leading))
                            }
                        }
                    }
                }
                .tabItem {
                    Text("Speakers")
                }
                .tag(0)
                
                // Setup tab
                
                VStack(alignment:.leading, spacing:0) {
                    HStack {
                        Spacer()
                        Text("Entity setup")
                            .font(.title)
                            .padding(.bottom,2)
                            .padding(.top,10)
                            .background(SETUP_BAR_COLOR)
                        Spacer()
                    }
                    
                    SetupHeaderView(sheetState: $sheetState, selectedSetupTab: $selectedSetupTab)
                    
                    Divider().frame(height: 2).background(Color(white: 0.85, opacity: 1.0))
                    
                    HStack(spacing: 0) {
                        SetupMasterView(selectedSetupTab: $selectedSetupTab, selectedMasterRow: $selectedSetupMasterRow).frame(width: MASTERVIEW_WIDTH)
                        GeometryReader{ geo in
                            SetupDetailView(selectedSetupTab: $selectedSetupTab, selectedMasterRow: $selectedSetupMasterRow)
                            ZStack {
                                if self.sheetState.showSheet {
                                    SetupSheetView(sheetState: self.$sheetState, presentMembersSheet: self.$presentMembersSheet, selectedSetupTab: $selectedSetupTab, selectedMasterRow: $selectedSetupMasterRow)
                                        .transition(.move(edge: .trailing))
                                        .frame(minWidth:geo.size.width, minHeight:geo.size.height)
                                }
                                if self.presentMembersSheet {
                                    MeetingGroupSheetView(presentMembersSheet: self.$presentMembersSheet)
                                        .transition(.move(edge: .trailing))
                                        .frame(minWidth:geo.size.width, minHeight:geo.size.height)
                                        .background(Color.white)
                                        .zIndex(1)  // In order to see animation on close, zindex must be set or view goes to back.
                                }
                            }
                        }
                    }
                }
                .background(SETUP_BAR_COLOR)
                .edgesIgnoringSafeArea([.top])
                .tabItem {
                    Text("Entity setup")
                }
                .tag(1)
                
                // Reports tab
                VStack {
                    HStack {
                        Spacer()
                        Text("Reports")
                            .font(.title)
                            .padding(.bottom,2)
                            .padding(.top,10)
                            .background(SETUP_BAR_COLOR)
                        Spacer()
                    }
                    ReportsHeaderView()
                    Divider().frame(height: 2).background(Color(white: 0.85, opacity: 1.0))
                    
                    HStack(spacing: 0) {
                        DisplayMeetingGroupsForReportsView(selectedMasterRow: $selectedSetupMasterRow).frame(width: MASTERVIEW_WIDTH)
                        GeometryReader{ geo in
//                            DisplayReportsForMeetingGroupView()
                        }
                    }
                }
                .background(SETUP_BAR_COLOR)
                .edgesIgnoringSafeArea([.top])
                .tabItem {
                    Text("Reports")
                }
                .tag(2)
            }
        }
        .onAppear(perform: {
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
             print("Error: Document directory not found")
                return
            }
            print("Documents directory:\n \(documentsDirectory)")
        })
    }
}
 

struct ContentView_Previews: PreviewProvider {
    static var testData = [Member]()
    /*
     Size specs here:
     https://developer.apple.com/library/archive/documentation/DeviceInformation/Reference/iOSDeviceCompatibility/Displays/Displays.html
     */
    static var previews: some View {
        ContentView(speakers: testData)
            .previewDevice("iPad Pro (12.9-inch) (4th generation)")
            .previewDisplayName("iPad Pro (12.9-inch)")
            .previewLayout(.fixed(width: 1366, height: 1024))
            .environmentObject(EntityState())
            .environmentObject(EventState())
            .environmentObject(SetupState())
            .environmentObject(TrackSpeakersState())
    }
}