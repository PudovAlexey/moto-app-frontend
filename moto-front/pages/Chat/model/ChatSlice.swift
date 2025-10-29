import SwiftUI
import Combine

struct Aponent: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let image: Image?
    
    init(name: String, imageName: String? = nil) {
        self.name = name
        if let imageName = imageName {
            self.image = Image(imageName) // Используем имя imageSet
        } else {
            self.image = nil
        }
    }
}

struct Message: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isMe: Bool
    let timestamp: Date
    let isFromCurrentUser: Bool
    let senderName: String
    
    
    init(text: String, timestamp: Date, isFromCurrentUser: Bool, senderName: String, isMe: Bool? = false) {
        self.text = text
        self.timestamp = timestamp
        self.isFromCurrentUser = isFromCurrentUser
        self.senderName = senderName
        self.isMe = isMe ?? false
    }
}


class MessageSlice: ObservableObject {
    @Published var messages: [Message] = []
    @Published var apponent: Aponent? = nil
    
    init() {
        self.apponent = Aponent(name: "Иван", imageName: "mock")
        
         let mockMessages = [
            Message(text: "Привет! Как дела?", timestamp: Date().addingTimeInterval(-300), isFromCurrentUser: false, senderName: "Иван"),
            Message(text: "Привет! Норм, ты как?", timestamp: Date().addingTimeInterval(-240), isFromCurrentUser: true, senderName: "Я"),
            Message(text: "Отлично! Го катать?", timestamp: Date().addingTimeInterval(-180), isFromCurrentUser: false, senderName: "Иван"),
            Message(text: "Ага, во сколько?", timestamp: Date().addingTimeInterval(-120), isFromCurrentUser: true, senderName: "Я", isMe: true),
            Message(text: "В 18:00 у гаража", timestamp: Date().addingTimeInterval(-60), isFromCurrentUser: false, senderName: "Иван")
        ]

        
        self.messages = mockMessages
    }
    
    func insertNewMessage(message: String) {
        messages.append(Message(
            text: message,
            timestamp: Date(),
            isFromCurrentUser: true,
            senderName: "Я",
            isMe: true
        ))
    }
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            ChatMessageBox()
//            ChatInput()
//        }
//        .environmentObject(MessageSlice())
//    }
//}
