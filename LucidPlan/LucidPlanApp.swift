//
//  LucidPlanApp.swift
//  LucidPlan
//
//  Created by Ludmila Rezunic on 17.03.2021.
//

import SwiftUI

@main
struct LucidPlanApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
