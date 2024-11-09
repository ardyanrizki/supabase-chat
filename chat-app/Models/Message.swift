// © 2024 Ardyan | Pattern Matters. All Rights Reserved.

import Foundation

struct Message: Identifiable, Equatable {
    let id: UUID = UUID()
    let username: String
    let content: String
    let isCurrentSession: Bool
    let timestamp: Date
    
    static let formatter = DateFormatter()
    
    func formattedTimestamp() -> String {
        Self.formatter.dateStyle = .none
        Self.formatter.timeStyle = .short
        return Self.formatter.string(from: timestamp)
    }
    
    func formattedDate() -> String {
        Self.formatter.dateStyle = .medium
        Self.formatter.timeStyle = .none
        return Self.formatter.string(from: timestamp)
    }
}
