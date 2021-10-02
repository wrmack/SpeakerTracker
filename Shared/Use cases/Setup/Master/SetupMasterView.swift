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
    @Binding var selectedMasterRow: Int
   
   
   var body: some View {
      Print(">>>>>> SetupMaster body refreshed")
      TabView(selection: $selectedSetupTab) {
         
         VStack {
            DisplayEntitiesView(selectedTab: $selectedSetupTab, selectedMasterRow: $selectedMasterRow)
         }
         .tabItem {
             VStack {
                 Text("Entities")
             }
         }
         .tag(0)
         
         VStack {
            DisplayMembersView(selectedTab: $selectedSetupTab, selectedMasterRow: $selectedMasterRow)
         }
         .tabItem {
             VStack {
                 Text("Members")
             }
         }
         .tag(1)
         
         VStack {
            DisplayMeetingGroupsView(selectedTab: $selectedSetupTab, selectedMasterRow: $selectedMasterRow)
         }
         .tabItem {
             VStack {
                 Text("Meeting groups")
             }
         }
         .tag(2)
         
         VStack {
            DisplayEventsView(selectedTab: $selectedSetupTab, selectedMasterRow: $selectedMasterRow)
         }
         .tabItem {
             VStack {
                 Text("Events")
             }
         }
         .tag(3)
         
      }
      .border(Color(white: 0.85), width: 1)
      .onChange(of: selectedSetupTab, perform: { tag in
         print("########### Selected tab: \(self.selectedSetupTab)")
      })

   }
  
}

//struct SetupMaster_Previews: PreviewProvider {
//   static var previews: some View {
//      SetupMasterView()
//   }
//}
