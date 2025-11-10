//
//  RidersConnect.swift
//  moto-front
//
//  Created by Алексей on 28.10.2025.
//

import SwiftUI

struct UserRow: View {
    let user: User
    let isContact: Bool
    let onMessageTap: (UUID) -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Аватар пользователя
            userAvatar
            
            // Информация о пользователе
            userInfo
            
            Spacer()
            
            // Действия
            actionButtons
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private var userAvatar: some View {
        ZStack {
            Circle()
                .fill(isContact ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
            
            Image(systemName: isContact ? "person.crop.circle.fill" : "person.crop.circle")
                .font(.title2)
                .foregroundColor(isContact ? .blue : .gray)
        }
        .frame(width: 50, height: 50)
    }
    
    private var userInfo: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(user.name)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundColor(.yellow)
                
                Text(isContact ? "Контакт" : "Пользователь")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var actionButtons: some View {
        HStack(spacing: 8) {
            // Кнопка сообщения
            Button(action: {
                onMessageTap(user.id)
            }) {
                Image(systemName: "message")
                    .font(.body)
                    .foregroundColor(.blue)
                    .frame(width: 40, height: 40)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            }
            
            // Кнопка звонка
            Button(action: {
                print("Звонок \(user.name)")
            }) {
                Image(systemName: "phone")
                    .font(.body)
                    .foregroundColor(.green)
                    .frame(width: 40, height: 40)
                    .background(Color.green.opacity(0.1))
                    .clipShape(Circle())
            }
        }
    }
}

struct SectionHeader: View {
    let title: String
    let count: Int
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text("\(count)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 8)
    }
}

struct SearchBar: View {
    @Binding var text: String
    let onSearch: (String) -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Поиск контактов...", text: $text)
                .debouncedSearch(text: $text, delay: 0.5) { query in
                    onSearch(query)
                                 }
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                    onSearch("")
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal, 16)
    }
}

struct LoadingView: View {
    @State private var isRotating = false
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Анимированный лоадер
            ZStack {
                // Внешнее кольцо
                Circle()
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue.opacity(0.3), .blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 4
                    )
                    .frame(width: 60, height: 60)
                
                // Вращающаяся часть
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 60, height: 60)
                    .rotationEffect(Angle(degrees: isRotating ? 360 : 0))
                    .onAppear {
                        withAnimation(
                            Animation.linear(duration: 1.5)
                                .repeatForever(autoreverses: false)
                        ) {
                            isRotating = true
                        }
                    }
                
                // Иконка мотоцикла
                Image(systemName: "figure.outdoor.cycle")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .scaleEffect(isAnimating ? 1.1 : 0.9)
                    .onAppear {
                        withAnimation(
                            Animation.easeInOut(duration: 0.8)
                                .repeatForever(autoreverses: true)
                        ) {
                            isAnimating = true
                        }
                    }
            }
            
            // Текст с пульсацией
            VStack(spacing: 8) {
                Text("Ищем контакты...")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Это может занять несколько секунд")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .opacity(isAnimating ? 0.6 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 40)
    }
}

struct ShimmerLoadingView: View {
    @State private var shimmerPosition = -200.0
    
    var body: some View {
        VStack(spacing: 16) {
            // Скелетон для карточек
            ForEach(0..<3, id: \.self) { _ in
                HStack(spacing: 16) {
                    // Скелетон аватара
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(.systemGray5),
                                            Color(.systemGray6),
                                            Color(.systemGray5)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .mask(Circle())
                                .offset(x: shimmerPosition)
                        )
                    
                    // Скелетон текста
                    VStack(alignment: .leading, spacing: 8) {
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .frame(height: 16)
                            .cornerRadius(8)
                            .overlay(
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(.systemGray5),
                                                Color(.systemGray6),
                                                Color(.systemGray5)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .mask(RoundedRectangle(cornerRadius: 8))
                                    .offset(x: shimmerPosition)
                            )
                            .frame(width: 120)
                        
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .frame(height: 12)
                            .cornerRadius(6)
                            .overlay(
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(.systemGray5),
                                                Color(.systemGray6),
                                                Color(.systemGray5)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .mask(RoundedRectangle(cornerRadius: 6))
                                    .offset(x: shimmerPosition)
                            )
                            .frame(width: 80)
                    }
                    
                    Spacer()
                    
                    // Скелетон кнопок
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 40, height: 40)
                        
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 40, height: 40)
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(Color(.systemBackground))
                .cornerRadius(12)
            }
        }
        .onAppear {
            withAnimation(
                Animation.linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
            ) {
                shimmerPosition = 200.0
            }
        }
    }
}

struct RidersConnectPage: View {
    @State private var selectedUserId: UUID? = nil
    @StateObject private var slice = RidersConnectSlice()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Фон
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                // Основной контент
                VStack(spacing: 0) {
                    // Поисковая строка
                    SearchBar(text: $searchText, onSearch: slice.fetchContacts)
                        .padding(.vertical, 16)
                    
                    if slice.isLoading {
                        // Красивый лоадер
                        if searchText.isEmpty {
                            LoadingView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            // Скелетон-лоадер при поиске
                            ScrollView {
                                LazyVStack(spacing: 8) {
                                    ShimmerLoadingView()
                                        .padding(.horizontal, 16)
                                }
                                .padding(.bottom, 20)
                            }
                        }
                    } else {
                        contentList
                    }
                }
            }
            .navigationTitle("Riders Connect")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var contentList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                // Секция контактов
                if !slice.contacts.isEmpty {
                    SectionHeader(title: "Мои контакты", count: slice.contacts.count)
                    
                    ForEach(slice.contacts) { user in
                        UserRow(
                            user: user,
                            isContact: true,
                            onMessageTap: handleMessageTap
                        )
                        .padding(.horizontal, 16)
                    }
                }
                
                // Секция пользователей
                if !slice.users.isEmpty {
                    SectionHeader(title: "Все пользователи", count: slice.users.count)
                    
                    ForEach(slice.users) { user in
                        UserRow(
                            user: user,
                            isContact: false,
                            onMessageTap: handleMessageTap
                        )
                        .padding(.horizontal, 16)
                    }
                }
                
                // Пустое состояние
                if slice.contacts.isEmpty && slice.users.isEmpty && !slice.isLoading {
                    emptyStateView
                }
            }
            .padding(.bottom, 20)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.2.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("Контакты не найдены")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Попробуйте изменить поисковый запрос")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
    
    private func handleMessageTap(userId: UUID) {
        selectedUserId = userId
        print("Переход в чат с: \(userId)")
    }
}

// Скрытый NavigationLink для навигации
extension RidersConnectPage {
    private var navigationLink: some View {
        NavigationLink(
            destination: Group {
                if let userId = selectedUserId {
                    ChatPage(userId: userId)
                }
            },
            tag: selectedUserId ?? UUID(),
            selection: $selectedUserId,
            label: { EmptyView() }
        )
        .hidden()
    }
}
