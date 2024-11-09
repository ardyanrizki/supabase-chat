// © 2024 Ardyan | Pattern Matters. All Rights Reserved.

import SwiftUI

struct StartSessionSheet: View {
    @Binding var isPresented: Bool
    @Binding var session: Session?
    @State private var displayName: String = ""
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Create Session")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            TextField("Enter your display name...", text: $displayName)
                .padding(12)
                .frame(height: 50)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            
            Button(action: startSession) {
                Text("Start Chatting")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        displayName.trimmingCharacters(in: .whitespaces).isEmpty ?
                        Color.blue.opacity(0.5) : Color.blue
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(displayName.trimmingCharacters(in: .whitespaces).isEmpty)
            .padding(.horizontal)
        }
    }
    
    private func startSession() {
        let trimmedName = displayName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }
        
        session = Session(name: trimmedName)
        isPresented = false
    }
}
