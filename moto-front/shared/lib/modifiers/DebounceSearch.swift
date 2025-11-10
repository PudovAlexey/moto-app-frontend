//
//  DebounceSearch.swift
//  moto-front
//
//  Created by Алексей on 10.11.2025.
//
import SwiftUI

struct DebouncedSearch: ViewModifier {
    let text: Binding<String>
    let delay: TimeInterval
    let onSearch: (String) -> Void
    
    @State private var task: Task<Void, Never>?
    
    func body(content: Content) -> some View {
        content
            .onChange(of: text.wrappedValue) { oldValue, newValue in
                task?.cancel()
                task = Task {
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    guard !Task.isCancelled else { return }
                    onSearch(newValue)
                }
            }
    }
}

extension View {
    func debouncedSearch(
        text: Binding<String>,
        delay: TimeInterval = 0.5,
        onSearch: @escaping (String) -> Void
    ) -> some View {
        self.modifier(DebouncedSearch(text: text, delay: delay, onSearch: onSearch))
    }
}
