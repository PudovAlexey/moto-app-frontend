import SwiftUI

struct ChatMessageBox: View {
    @EnvironmentObject var messageStore: MessageSlice
    
    var body: some View {
        LazyVStack(spacing: 8) {
            ForEach(messageStore.messages) { message in
                HStack {
                    if message.isMe {
                        Spacer()
                    }
                    
                    VStack(alignment: message.isMe ? .trailing : .leading, spacing: 4) {
                        Text(message.text)
                            .padding(10)
                            .background(message.isMe ? Color.blue : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    if !message.isMe {
                        Spacer()
                    }
                }
                .id(message.id) // Важно для ScrollViewReader!
            }
        }
        .padding(.horizontal) // Убираем вертикальный padding чтобы лучше работала прокрутка
        .padding(.bottom, 8) // Добавляем немного отступа снизу
    }
}
