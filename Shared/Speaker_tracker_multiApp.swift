//
//  Speaker_tracker_multiApp.swift
//  Shared
//
//  Created by Warwick McNaughton on 1/10/21.
//

import SwiftUI

@main
struct Speaker_tracker_multiApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    // On iOS apps convert UIDocument data from previous app to CoreData
    #if os(iOS)
    let upgradeSuccess = Upgrade.convertEntityDocumentsToCoreData()
    #endif
    
    // CoreData persistence controller singleton
    let persistenceController = PersistenceController.shared
    
    // Creating EnvironmentObjects
    @StateObject var entityState = EntityState()
    @StateObject var eventState = EventState()
    @StateObject var reportsState = ReportsState()
    @StateObject var trackSpeakersState = TrackSpeakersState()
    
    // Flag which causes help to show
    @State var showHelp = false
    
    
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
        // In MacOS Help opens in separate window
        #if os(macOS)
        WindowGroup("Help") {
            ShowHelpViewMacOS(showHelp: $showHelp)
        }
        .handlesExternalEvents(matching: Set(arrayLiteral: "*"))
        #endif
    }
}
