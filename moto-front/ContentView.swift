//
//  ContentView.swift
//  moto-front
//
//  Created by Алексей on 28.10.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Лента")
                }
            
            MapView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Чаты")
                }
            
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Карn")
                }
            
            RidersConnectPage()
                .tabItem {
                    Image(systemName: "person")
                    Text("Профиль")
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView() // ← Просто вызываем инициализатор
        .environmentObject(MessageSlice())
}
