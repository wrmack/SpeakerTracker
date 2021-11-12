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
    
    #if os(iOS)
    let upgradeSuccess = Upgrade.convertToCoreData()
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
    }
}
