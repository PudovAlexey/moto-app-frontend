//
//  moto_frontApp.swift
//  moto-front
//
//  Created by Алексей on 28.10.2025.
//

import SwiftUI

@main
struct moto_frontApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(MessageSlice())
        }
    }
}


