// © 2024 Ardyan | Pattern Matters. All Rights Reserved.

import SwiftUI

struct ChatRoomView: View {
    @ObservedObject private var viewModel: ChatRoomViewModel
    @State private var newMessage: String = ""
    
    init() {
        _viewModel = ObservedObject(initialValue: ChatRoomViewModel())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation Bar
            HStack {
                Text("Messages")
                    .font(.headline)
                Spacer()
            }
            .padding()
            .background(Color.white)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray.opacity(0.2)),
                alignment: .bottom
            )
            
            // Chat Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(groupedMessages(), id: \.key) { date, messages in
                            Text(date)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.vertical, 8)
                            
                            ForEach(messages, id: \.timestamp) { message in
                                ChatBubbleView(message: message)
                                    .id(message.id)
                            }
                        }
                    }
                    .padding(.vertical, 12)
                }
                .onChange(of: viewModel.messages) { _, _ in
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input Field
            ChatTextFieldView(message: $newMessage) {
                Task {
                    do {
                        try await viewModel.sendMessage(newMessage)
                        newMessage = ""
                    } catch {
                        dump(error)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.showingSessionSheet) {
            StartSessionSheet(isPresented: $viewModel.showingSessionSheet, session: $viewModel.session)
        }
    }
    
    private func groupedMessages() -> [(key: String, value: [Message])] {
        let grouped = Dictionary(grouping: viewModel.messages) { $0.formattedDate() }
        return grouped.sorted { $0.key < $1.key }
    }
}

#Preview {
    ChatRoomView()
}
