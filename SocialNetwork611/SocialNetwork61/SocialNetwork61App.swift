//
//  SocialNetwork61App.swift
//  SocialNetwork61
//
//  Created by admin on 14.03.2024.
//

import SwiftUI

@main
struct SocialNetwork61App: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
