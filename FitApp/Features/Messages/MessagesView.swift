import SwiftUI

struct MessagesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var messages = MockData.sampleMessages
    @State private var newMessageText = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Messages List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding()
                }
                
                // Message Input
                HStack(spacing: 12) {
                    TextField("Type a message...", text: $newMessageText, axis: .vertical)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                        .lineLimit(1...4)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .disabled(newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
                .background(Color(.systemBackground))
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func sendMessage() {
        let trimmedText = newMessageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        let newMessage = Message(
            id: UUID().uuidString,
            text: trimmedText,
            isFromUser: true,
            timestamp: Date()
        )
        
        messages.append(newMessage)
        newMessageText = ""
        
        // Simulate AI response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let aiResponse = Message(
                id: UUID().uuidString,
                text: generateAIResponse(to: trimmedText),
                isFromUser: false,
                timestamp: Date()
            )
            messages.append(aiResponse)
        }
    }
    
    private func generateAIResponse(to userMessage: String) -> String {
        let responses = [
            "Great question! I'm here to help you reach your fitness goals.",
            "That's a smart approach to your nutrition plan.",
            "I'd recommend focusing on consistency with your workouts.",
            "Your progress is looking good! Keep up the great work.",
            "Let me help you adjust your plan for better results."
        ]
        return responses.randomElement() ?? "Thanks for your message!"
    }
}

struct Message: Identifiable {
    let id: String
    let text: String
    let isFromUser: Bool
    let timestamp: Date
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer(minLength: 60)
            }
            
            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(message.isFromUser ? Color.blue : Color(.systemGray5))
                    .foregroundColor(message.isFromUser ? .white : .primary)
                    .cornerRadius(18)
                
                Text(message.timestamp.formatted(.dateTime.hour().minute()))
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
            }
            
            if !message.isFromUser {
                Spacer(minLength: 60)
            }
        }
    }
}

struct MockData {
    static let sampleMessages = [
        Message(
            id: "1",
            text: "Welcome to FitGoal AI! I'm here to help you achieve your fitness goals. How are you feeling about your progress so far?",
            isFromUser: false,
            timestamp: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date()
        ),
        Message(
            id: "2",
            text: "Thanks! I'm excited to get started. Can you help me understand my nutrition plan better?",
            isFromUser: true,
            timestamp: Calendar.current.date(byAdding: .hour, value: -1, to: Date()) ?? Date()
        ),
        Message(
            id: "3",
            text: "Absolutely! Your current plan focuses on a balanced approach with 2000 calories daily. The key is consistency with your macro targets: protein, carbs, and healthy fats.",
            isFromUser: false,
            timestamp: Calendar.current.date(byAdding: .minute, value: -30, to: Date()) ?? Date()
        )
    ]
}

#Preview {
    MessagesView()
}
