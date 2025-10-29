import SwiftUI


struct ChatPage: View {
    @EnvironmentObject var messageStore: MessageSlice
    let userId: UUID
    
    var body: some View {
        VStack {
            // Обернули в ScrollViewReader для автоматической прокрутки
            ScrollViewReader { proxy in
                ScrollView {
                    ChatMessageBox()
                        .onChange(of: messageStore.messages) { _ in
                            // Автоматически прокручиваем к последнему сообщению
                            if let lastMessage = messageStore.messages.last {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                        .onAppear {
                            // Прокручиваем к последнему сообщению при появлении
                            if let lastMessage = messageStore.messages.last {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                }
            }
            
            ChatInput()
        }
        .navigationTitle(Text("Chat"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if let image = messageStore.apponent?.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
