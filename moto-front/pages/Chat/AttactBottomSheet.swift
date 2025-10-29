import SwiftUI

struct MockImageView: View {
    let index: Int
    
    var body: some View {
        Rectangle()
            .fill(Color.blue.opacity(0.3))
            .overlay(
                Text("\(index)")
                    .foregroundColor(.white)
                    .font(.caption)
                    .fontWeight(.bold)
            )
            .frame(height: 80)
            .cornerRadius(8)
    }
}

struct AttachBottomSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    // Массив данных для сетки (можно заменить на реальные изображения)
    let gridItems = Array(1...12)
    
    var body: some View {
        VStack(spacing: 20) {
            // Заголовок
            Text("Выберите изображение")
                .font(.title2)
                .fontWeight(.semibold)
            
            // Грид сетка
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(gridItems, id: \.self) { item in
                        MockImageView(index: item)
                            .onTapGesture {
                                print("Выбрано изображение \(item)")
                                // Действие при выборе изображения
                            }
                    }
                }
                .padding()
            }
            
            // Кнопка закрытия
            Button("Закрыть") {
                dismiss()
            }
            .buttonStyle(.bordered)
        }
        .padding(.vertical)
        .presentationDetents([.medium, .large])
    }
}
