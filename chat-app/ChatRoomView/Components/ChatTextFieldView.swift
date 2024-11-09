// © 2024 Ardyan | Pattern Matters. All Rights Reserved.

import SwiftUI

struct ChatTextFieldView: View {
    @Binding var message: String
    var onSend: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            TextField("Type a message...", text: $message)
                .padding(12)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Button(action: {
                if !message.trimmingCharacters(in: .whitespaces).isEmpty {
                    onSend()
                }
            }) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.2)),
            alignment: .top
        )
    }
}
