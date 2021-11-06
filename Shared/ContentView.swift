//
//  ContentView.swift
//  Shared
//
//  Created by Warwick McNaughton on 1/10/21.
//
import SwiftUI

struct SetupTitle: View {
    @Binding var selectedSetupTab: Int
    
    var body: some View {
        switch selectedSetupTab {
        case 0:
            Text("Setup entities")
                .font(.title)
                .padding(.bottom,2)
                .padding(.top,10)
        case 1:
            Text("Setup the members of a selected entity")
                .font(.title)
                .padding(.bottom,2)
                .padding(.top,10)
            
        case 2:
            Text("Setup the meeting groups of a selected entity")
                .font(.title)
                .padding(.bottom,2)
                .padding(.top,10)
        case 3:
            Text("Setup meeting events for a selected meeting group")
                .font(.title)
                .padding(.bottom,2)
                .padding(.top,10)
        default:
            Text("Setup parent entities")
                .font(.title)
                .padding(.bottom,2)
                .padding(.top,10)
        }
    }
}


struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext // TODO: needed??
    
    @StateObject var setupSheetState = SetupSheetState()
    @State private var showMeetingSetupSheet = false
    @State private var presentMembersSheet = false
    @State private var selectedMeetingGroup: MeetingGroup?
    @State private var isRecording = false
    @State private var selectedSetupTab = 0
    @State private var selectedTab = 0
    
    
    var speakers:[Member] = []
    
    var body: some View {
        Print(">>>>>> ContentView body refreshed")
        //        VStack(spacing: 0) {
        
        TabView(selection: $selectedTab) {
            
            // Track speaker main scene
            
            GeometryReader { geo in
                ZStack(alignment:.topLeading) {
                    TrackSpeakersView(
                        showMeetingSetupSheet: $showMeetingSetupSheet,
                        selectedMeetingGroup: $selectedMeetingGroup,
                        isRecording: $isRecording
                    )
                        .frame(maxHeight: geo.size.height > 30 ? geo.size.height - 30 : geo.size.height)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: EASEINOUT)) {
                                if showMeetingSetupSheet == true {
                                    showMeetingSetupSheet = false
                                }
                            }
                        }
                    
                    if self.showMeetingSetupSheet {
                        HStack {
                            MeetingSetupView(
                                showMeetingSetupSheet: self.$showMeetingSetupSheet,
                                isRecording: $isRecording
                            )
                                .frame(maxWidth:500, maxHeight: geo.size.height - 30)
                        }
                        .zIndex(1)
                        .transition(.move(edge: .leading))
                        .background(Color.clear)
//                        .environment(\.colorScheme, .light)
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
                    SetupTitle(selectedSetupTab: $selectedSetupTab)
                    Spacer()
                }
                
                SetupHeaderView(setupSheetState: setupSheetState, selectedSetupTab: $selectedSetupTab)
                
                Divider().frame(height: 2).background(Color(white: 0.85, opacity: 1.0))
                
                HStack(spacing: 0) {
                    SetupMasterView(selectedSetupTab: $selectedSetupTab)
                        .frame(maxWidth: MASTERVIEW_WIDTH)
                    Divider().frame(width:10)
                    GeometryReader{ geo in
                        ZStack {
                            SetupDetailView(selectedSetupTab: $selectedSetupTab)
                            
                            if setupSheetState.showSheet {
                                SetupSheetView(setupSheetState: setupSheetState, presentMembersSheet: self.$presentMembersSheet, selectedSetupTab: $selectedSetupTab)
                                    .zIndex(1)
                                    .transition(.move(edge: .trailing))
                                    .frame(minWidth:geo.size.width, minHeight:geo.size.height)
                            }
                            if setupSheetState.showMembersSheet {
                                MeetingGroupSheetView(setupSheetState: setupSheetState)
                                    .transition(.move(edge: .trailing))
                                    .frame(minWidth:geo.size.width, minHeight:geo.size.height)
                                //                                        .background(Color.white)
                                    .zIndex(1)  // In order to see animation on close, zindex must be set or view goes to back.
                            }
                        }
                        .frame(maxWidth:.infinity, maxHeight: .infinity)
                    }
                }
                //                    .onReceive(setupSheetState.showSheet, perform: {val in
                //                        showMeetingSetupSheet = val
                //                    })
            }
            //                .background(SETUP_BAR_COLOR)
            .edgesIgnoringSafeArea([.top])
            .tabItem {
                Text("Setup")
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
                    //                            .background(SETUP_BAR_COLOR)
                    Spacer()
                }
                ReportsHeaderView()
                Divider().frame(height: 2).background(Color(white: 0.85, opacity: 1.0))
                
                HStack(spacing: 0) {
                    DisplayMeetingGroupsForReportsView(selectedTab: $selectedTab).frame(width: MASTERVIEW_WIDTH)
                    Divider().frame(width:10)
                    GeometryReader{ geo in
                        DisplayReportsForMeetingGroupView()
                    }
                }
            }
            //                .background(SETUP_BAR_COLOR)
            .edgesIgnoringSafeArea([.top])
            .tabItem {
                Text("Reports")
            }
            .tag(2)
        }
        .opacity(1.0)

        
        //        }
#if os(macOS)
        .frame(minWidth: 1100)
#endif
        .padding(.top,10)
        .onAppear(perform: {
            print("\nReference ******************************")
            print(DebugReference.console)
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Error: Document directory not found")
                return
            }
            print("Documents directory:\n \(documentsDirectory)")
            print("****************************************\n")
        })
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var testData = [Member]()
    static var showMeetingSetupSheet = true
    /*
     Size specs here:
     https://developer.apple.com/library/archive/documentation/DeviceInformation/Reference/iOSDeviceCompatibility/Displays/Displays.html
     */
    static var previews: some View {
        ContentView(speakers: testData)
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
        //            .previewDisplayName("iPad Pro (12.9-inch)")
            .previewLayout(.fixed(width: 1366, height: 1024))
            .environmentObject(EntityState())
            .environmentObject(EventState())
            .environmentObject(TrackSpeakersState())
        //            .environment(\.colorScheme, .light)
    }
}
