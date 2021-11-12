//
//  SetupMaster.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 9/08/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI

struct SetupHeaderText {
    var hdr: String
}

struct SetupMasterView: View {
    
    @State var selectedItemText = ""
    @Binding var selectedSetupTab: Int
    
    
    var body: some View {
        Print(">>>>>> SetupMaster body refreshed")
        TabView(selection: $selectedSetupTab) {
            
            DisplayEntitiesView(selectedTab: $selectedSetupTab)
                .tabItem {
//                    Label("Entities", image: "icon-entity")
//                        Image("icon-entity")
                        Text("Entities")
                }
                .tag(0)
            
            DisplayMembersView(selectedTab: $selectedSetupTab)
                .tabItem {
//                    Image("icon-members")
                    Text("Members")
                }
                .tag(1)
            
            DisplayMeetingGroupsView(selectedTab: $selectedSetupTab)
                .tabItem {
//                    Image("icon-committee")
                    Text("Meeting groups")
                }
                .tag(2)
            
            DisplayEventsView(selectedTab: $selectedSetupTab)
                .tabItem {
//                    Image("icon-events")
                    Text("Events")
                }
                .tag(3)
            
        }
        .padding(.top,10)
        //      .border(Color(white: 0.85), width: 1)
        .onAppear(perform: {
#if os(iOS)
            let itemAppearance = UITabBarItemAppearance(style: .stacked)
            itemAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.systemGray,
                .font : UIFont.systemFont(ofSize: 16)
            ]
//            itemAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 20, vertical: 10)

            let appearance = UITabBarAppearance()
            appearance.backgroundColor = UIColor.red
            appearance.stackedLayoutAppearance = itemAppearance
            appearance.inlineLayoutAppearance = itemAppearance
            appearance.compactInlineLayoutAppearance = itemAppearance
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().backgroundColor = .systemGray6
#endif
        })
        
        .onChange(of: selectedSetupTab, perform: { tag in
            print("########### Selected tab: \(self.selectedSetupTab)")
        })
        
    }
    
}

struct SetupMaster_Previews: PreviewProvider {
    static var previews: some View {
        SetupMasterView(selectedSetupTab: .constant(0))
            .environmentObject(EntityState())
    }
    
}
