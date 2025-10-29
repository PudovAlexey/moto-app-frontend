//
//  RidersConnect.swift
//  moto-front
//
//  Created by Алексей on 28.10.2025.
//

import SwiftUI

struct UserRow: View {
    let user: User
    let onMessageTap: (UUID) -> Void
    
    var body: some View {
        HStack {
            // Слева - иконка мобильного телефона
            Image(systemName: "iphone")
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 40, height: 40)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
            
            // Центр - информация о пользователе
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundColor(.yellow)
                }
            }
            
            Spacer()
            
            // Справа - две иконки действий
            HStack(spacing: 12) {
                // Иконка чата
                Button(action: {
                    onMessageTap(user.id)
                }) {
                    Image(systemName: "message")
                        .font(.title3)
                        .foregroundColor(.blue)
                        .frame(width: 44, height: 44)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
                
                // Иконка телефона
                Button(action: {
                    print("Звонок \(user.name)")
                }) {
                    Image(systemName: "phone")
                        .font(.title3)
                        .foregroundColor(.green)
                        .frame(width: 44, height: 44)
                        .background(Color.green.opacity(0.1))
                        .clipShape(Circle())
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}

struct RidersConnectPage: View {
    @State private var selectedUserId: UUID? = nil

    
    var body: some View {
        NavigationView {
            ZStack {
                // Основной список
                List(mockUsers) { user in
                    UserRow(user: user, onMessageTap: handleMessageTap)
                }
                .navigationTitle("ridersConnect")
                .navigationBarTitleDisplayMode(.large)
                
                // Скрытый NavigationLink для навигации
                NavigationLink(
                    destination: selectedUserId != nil ? ChatPage(userId: selectedUserId!) : nil,
                    tag: selectedUserId ?? UUID(), // Уникальный тег
                    selection: $selectedUserId,
                    label: { EmptyView() }
                )
                .hidden()
            }
        }
    }
    
    private func handleMessageTap(userId: UUID) {
        selectedUserId = userId
        print("Переход в чат с: \(userId)")
    }
}
