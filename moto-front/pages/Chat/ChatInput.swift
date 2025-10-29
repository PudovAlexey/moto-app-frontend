import SwiftUI

struct ChatInput: View {
    @EnvironmentObject var messageStore: MessageSlice
    @State private var message: String = ""
    @State private var isOpen: Bool = false
    
    private func sendMessage() {
        guard !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        messageStore.insertNewMessage(message: message)
        message = "" // Очищаем поле ввода после отправки
    }
    
    private func attachFile() {
        isOpen.toggle()
    }
    
    var body: some View {
        HStack {
            Button(action: attachFile) {
                Image(systemName: "paperclip")
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
            TextField("Напишите сообщение", text: $message)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
        }
        .padding()
        .sheet(isPresented: $isOpen) {
            AttachBottomSheet()
        }
    }
}
