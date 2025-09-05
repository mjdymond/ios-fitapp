import SwiftUI

struct NotificationsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var notifications = MockNotifications.sampleNotifications
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            List {
                if notifications.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "bell.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary.opacity(0.5))
                        
                        VStack(spacing: 8) {
                            Text("No notifications")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("You're all caught up! New notifications will appear here.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 60)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(notifications) { notification in
                        NotificationRow(notification: notification) {
                            markAsRead(notification)
                        }
                    }
                    .onDelete(perform: deleteNotifications)
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                NotificationSettingsView()
            }
        }
    }
    
    private func markAsRead(_ notification: AppNotification) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications[index].isRead = true
        }
    }
    
    private func deleteNotifications(offsets: IndexSet) {
        notifications.remove(atOffsets: offsets)
    }
}

struct AppNotification: Identifiable {
    let id: String
    let title: String
    let body: String
    let type: NotificationType
    let timestamp: Date
    var isRead: Bool
    
    enum NotificationType {
        case workout, nutrition, achievement, reminder, system
        
        var icon: String {
            switch self {
            case .workout: return "dumbbell.fill"
            case .nutrition: return "fork.knife"
            case .achievement: return "trophy.fill"
            case .reminder: return "clock.fill"
            case .system: return "gear"
            }
        }
        
        var color: Color {
            switch self {
            case .workout: return .blue
            case .nutrition: return .green
            case .achievement: return .yellow
            case .reminder: return .orange
            case .system: return .gray
            }
        }
    }
}

struct NotificationRow: View {
    let notification: AppNotification
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Icon
                Image(systemName: notification.type.icon)
                    .foregroundColor(notification.type.color)
                    .frame(width: 24, height: 24)
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(notification.title)
                        .font(.body)
                        .fontWeight(notification.isRead ? .regular : .semibold)
                        .foregroundColor(.primary)
                    
                    Text(notification.body)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    Text(notification.timestamp.formatted(.relative(presentation: .numeric)))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Unread indicator
                if !notification.isRead {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 8, height: 8)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 4)
    }
}

struct NotificationSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var workoutReminders = true
    @State private var nutritionReminders = true
    @State private var achievementAlerts = true
    @State private var weeklyProgress = true
    
    var body: some View {
        NavigationView {
            Form {
                Section("Workout Notifications") {
                    Toggle("Workout Reminders", isOn: $workoutReminders)
                    Toggle("Rest Day Reminders", isOn: $workoutReminders)
                }
                
                Section("Nutrition Notifications") {
                    Toggle("Meal Logging Reminders", isOn: $nutritionReminders)
                    Toggle("Hydration Reminders", isOn: $nutritionReminders)
                }
                
                Section("Progress & Achievements") {
                    Toggle("Achievement Alerts", isOn: $achievementAlerts)
                    Toggle("Weekly Progress Summary", isOn: $weeklyProgress)
                }
            }
            .navigationTitle("Notification Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Save settings
                        dismiss()
                    }
                }
            }
        }
    }
}

struct MockNotifications {
    static let sampleNotifications = [
        AppNotification(
            id: "1",
            title: "Workout Complete! 🎉",
            body: "Great job finishing your upper body workout. You earned 50 points!",
            type: .achievement,
            timestamp: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date(),
            isRead: false
        ),
        AppNotification(
            id: "2",
            title: "Time for your workout",
            body: "Your scheduled leg day workout is coming up in 30 minutes.",
            type: .workout,
            timestamp: Calendar.current.date(byAdding: .hour, value: -4, to: Date()) ?? Date(),
            isRead: true
        ),
        AppNotification(
            id: "3",
            title: "Log your lunch",
            body: "Don't forget to track your afternoon meal to stay on target.",
            type: .nutrition,
            timestamp: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
            isRead: false
        ),
        AppNotification(
            id: "4",
            title: "Weekly Progress Report",
            body: "You've completed 4 out of 5 planned workouts this week. Keep it up!",
            type: .reminder,
            timestamp: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
            isRead: true
        )
    ]
}

#Preview {
    NotificationsView()
}
