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
            Text("Setup the members for the selected entity")
                .font(.title)
                .padding(.bottom,2)
                .padding(.top,10)
            
        case 2:
            Text("Setup the meeting groups for the selected entity")
                .font(.title)
                .padding(.bottom,2)
                .padding(.top,10)
        case 3:
            Text("Setup meeting events for the selected meeting group")
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

/// The main parent view
///
/// Is a `TabView` with tabs for "Speakers", "Setup" and "Reports".
struct ContentView: View {
//    @Environment(\.managedObjectContext) var managedObjectContext // TODO: needed??

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
        
        TabView(selection: $selectedTab) {
            
            // Track speaker main scene
            
            GeometryReader { geo in
                ZStack(alignment:.topLeading) {
                    // Main track speakers view
                    TrackSpeakersView(
                        showMeetingSetupSheet: $showMeetingSetupSheet,
                        selectedMeetingGroup: $selectedMeetingGroup,
                        isRecording: $isRecording
                    )
                        .frame(maxHeight: geo.size.height)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: EASEINOUT)) {
                                if showMeetingSetupSheet == true {
                                    showMeetingSetupSheet = false
                                }
                            }
                        }
                    // Meeting setup
                    if self.showMeetingSetupSheet {
                        HStack {
                            MeetingSetupView(
                                showMeetingSetupSheet: self.$showMeetingSetupSheet,
                                isRecording: $isRecording
                            )
                                .frame(maxWidth:500, maxHeight: geo.size.height)
                        }
                        .zIndex(1)
                        .transition(.move(edge: .leading))
                        .background(Color.clear)
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
                
                // Master | Detail views
                HStack(spacing: 0) {
                    // Master
                    SetupMasterView(selectedSetupTab: $selectedSetupTab)
                        .frame(maxWidth: MASTERVIEW_WIDTH)
                    Divider().frame(width:10)
                    
                    // Detail
                    GeometryReader{ geo in
                        ZStack {
                            SetupDetailView(setupSheetState: setupSheetState, selectedSetupTab: $selectedSetupTab)
                                .frame(width: geo.size.width, height: geo.size.height)
                            Print("Detailview geo height: \(geo.size.height)")
                            if setupSheetState.showSheet {
                                Print("setupSheetView geo height: \(geo.size.height)")
                                SetupSheetView(setupSheetState: setupSheetState, presentMembersSheet: self.$presentMembersSheet, selectedSetupTab: $selectedSetupTab)
                                    .zIndex(1)
                                    .transition(.move(edge: .trailing))
                                    .frame(idealWidth:geo.size.width, idealHeight:geo.size.height)
                            }
                            if setupSheetState.showMembersSheet {
                                MeetingGroupSheetView(setupSheetState: setupSheetState)
                                    .transition(.move(edge: .trailing))
                                    .frame(idealWidth:geo.size.width, idealHeight:geo.size.height)
                                    .zIndex(1)  // In order to see animation on close, zindex must be set or view goes to back.
                            }
                        }
                        .frame(maxWidth:.infinity, maxHeight: .infinity)
                    }
                }
            }
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
            .edgesIgnoringSafeArea([.top])
            .tabItem {
                Text("Reports")
            }
            .tag(2)
        }
        .opacity(1.0)
#if os(macOS)
        .frame(minWidth: 1100, minHeight: 600)
#endif
        .padding(.top,10)
        .onAppear(perform: {
            // Customise UITabBarItems on iOS
            #if os(iOS)
            let itemAppearance = UITabBarItemAppearance()
            itemAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.systemGray,
                .font : UIFont.systemFont(ofSize: 20)
            ]
            let appearance = UITabBarAppearance()
            appearance.stackedLayoutAppearance = itemAppearance
            appearance.inlineLayoutAppearance = itemAppearance
            appearance.compactInlineLayoutAppearance = itemAppearance
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().backgroundColor = .systemBackground
            #endif
            
            // Print debugging info
            print(DebugReference.consolePrint)
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
//            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
        //            .previewDisplayName("iPad Pro (12.9-inch)")
//            .previewLayout(.fixed(width: 1024, height: 768))
            .previewInterfaceOrientation(.landscapeRight)
            .environmentObject(EntityState())
            .environmentObject(EventState())
            .environmentObject(TrackSpeakersState())
        //            .environment(\.colorScheme, .light)
    }
}
