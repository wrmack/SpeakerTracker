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
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(EntityState())
                .environmentObject(EventState())
                .environmentObject(SetupState())
                .environmentObject(TrackSpeakersState())
                .environmentObject(ReportsState())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
