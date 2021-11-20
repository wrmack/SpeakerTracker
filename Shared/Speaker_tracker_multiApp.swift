//
//  Speaker_tracker_multiApp.swift
//  Shared
//
//  Created by Warwick McNaughton on 1/10/21.
//

import SwiftUI

@main
struct Speaker_tracker_multiApp: App {
    
    @State var showHelp = false
    
    @Environment(\.scenePhase) var scenePhase
    
    #if os(iOS)
    let upgradeSuccess = Upgrade.convertEntityDocumentsToCoreData()
    #endif
    
    let persistenceController = PersistenceController.shared
    @StateObject var entityState = EntityState()
    @StateObject var eventState = EventState()
    @StateObject var reportsState = ReportsState()
    @StateObject var trackSpeakersState = TrackSpeakersState()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(entityState)
                .environmentObject(eventState)
                .environmentObject(trackSpeakersState)
                .environmentObject(reportsState)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
        #if os(macOS)
        WindowGroup("Help") { // other scene
            ShowHelpViewMacOS(showHelp: $showHelp)
        }
        .handlesExternalEvents(matching: Set(arrayLiteral: "*"))
        #endif
    }
}
