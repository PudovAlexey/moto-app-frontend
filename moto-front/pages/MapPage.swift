//
//  MapPage.swift
//  moto-front
//
//  Created by Алексей on 28.10.2025.
//

import SwiftUI


struct MapView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            VStack {
                Text("Карта")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("ridersConnect")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding(.top, 4)
                
                Spacer()
            }
            .padding(.top, 50)
        }
    }
}
