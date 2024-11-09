// © 2024 Ardyan | Pattern Matters. All Rights Reserved.

import Foundation

struct MessageDTO: Codable {
    let session_id: UUID
    let session_name: String
    let content: String
    let created_at: Date?
    
    func toModel(currentSessionId: UUID) -> Message {
        .init(
            username: session_name,
            content: content,
            isCurrentSession: session_id == currentSessionId,
            timestamp: created_at ?? Date()
        )
    }
}
