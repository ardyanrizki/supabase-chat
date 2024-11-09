// © 2024 Ardyan | Pattern Matters. All Rights Reserved.

import Supabase
import SwiftUI

fileprivate let url = "YOUR_SUPABASE_URL"
fileprivate let apiKey = "YOUR_SUPABASE_ANON_KEY"

@MainActor
final class ChatRoomViewModel: ObservableObject {

    private let supabase = SupabaseClient(
      supabaseURL: URL(string: url)!,
      supabaseKey: apiKey
    )
    
    var session: Session? = nil {
        didSet {
            if session != nil {
                Task {
                    await fetchMessages()
                    subscribeMessages()
                }
            }
        }
    }
    
    @Published var messages: [Message] = []
    @Published var showingSessionSheet: Bool = false
    
    init() {
        if session == nil {
            showingSessionSheet = true
        }
    }
    
    func fetchMessages() async {
        do {
            guard let sessionId = session?.id else { return }
            let data: [MessageDTO] = try await supabase.from("messages").select().limit(100).execute().value
            messages = data.compactMap { $0.toModel(currentSessionId: sessionId) }
        } catch {
            dump(error)
        }
    }
    
    func sendMessage(_ content: String) async throws {
        do {
            guard let session else { return }
            let data = MessageDTO(session_id: session.id, session_name: session.name, content: content, created_at: Date())
            let _ = try await supabase.from("messages").insert(data).execute()
        } catch {
            throw error
        }
    }
    
    func subscribeMessages() {
        let channel = supabase.realtimeV2.channel("public:messages")
        let insertions = channel.postgresChange(InsertAction.self, table: "messages")
        Task {
            await channel.subscribe()
            for await insertion in insertions {
                await handleInserted(insertion)
            }
        }
    }
    
    func handleInserted(_ action: HasRecord) async {
        do {
            guard let sessionId = session?.id else { return }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedMessage = try action.decodeRecord(decoder: decoder) as MessageDTO
            let message = decodedMessage.toModel(currentSessionId: sessionId)
            messages.append(message)
        } catch {
            dump(error)
        }
    }
    
}
