import SwiftUI
import CoreData

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.createdAt, ascending: true)],
        animation: .default)
    private var users: FetchedResults<User>
    
    @State private var showingEditProfile = false
    @State private var showingDataExport = false
    @State private var unitSystem: UnitSystem = .imperial
    @State private var darkMode = false
    @State private var hapticFeedback = true
    
    enum UnitSystem: String, CaseIterable {
        case imperial = "Imperial"
        case metric = "Metric"
    }
    
    var currentUser: User? {
        users.first
    }
    
    var body: some View {
        NavigationView {
            List {
                // Profile Section
                if let user = currentUser {
                    Section {
                        HStack(spacing: 12) {
                            // Avatar
                            Circle()
                                .fill(LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Text(String(user.name?.first ?? "U"))
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                )
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(user.name ?? "User")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                
                                if let email = user.email {
                                    Text(email)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            Button("Edit") {
                                showingEditProfile = true
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                // App Preferences
                Section("Preferences") {
                    HStack {
                        Image(systemName: "ruler")
                            .foregroundColor(.blue)
                            .frame(width: 24)
                        
                        Text("Units")
                        
                        Spacer()
                        
                        Picker("Units", selection: $unitSystem) {
                            ForEach(UnitSystem.allCases, id: \.self) { system in
                                Text(system.rawValue).tag(system)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    HStack {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.purple)
                            .frame(width: 24)
                        
                        Text("Dark Mode")
                        
                        Spacer()
                        
                        Toggle("", isOn: $darkMode)
                    }
                    
                    HStack {
                        Image(systemName: "iphone.radiowaves.left.and.right")
                            .foregroundColor(.orange)
                            .frame(width: 24)
                        
                        Text("Haptic Feedback")
                        
                        Spacer()
                        
                        Toggle("", isOn: $hapticFeedback)
                    }
                }
                
                // Health & Fitness
                Section("Health & Fitness") {
                    SettingsRow(
                        icon: "heart.fill",
                        title: "Health Data",
                        subtitle: "Sync with Apple Health",
                        color: .red
                    ) {
                        // Navigate to health settings
                    }
                    
                    SettingsRow(
                        icon: "target",
                        title: "Goals",
                        subtitle: "Update your fitness targets",
                        color: .blue
                    ) {
                        // Navigate to goals
                    }
                    
                    SettingsRow(
                        icon: "bell.fill",
                        title: "Notifications",
                        subtitle: "Workout and meal reminders",
                        color: .orange
                    ) {
                        // Navigate to notifications
                    }
                }
                
                // Data & Privacy
                Section("Data & Privacy") {
                    SettingsRow(
                        icon: "square.and.arrow.up",
                        title: "Export Data",
                        subtitle: "Download your fitness data",
                        color: .green
                    ) {
                        showingDataExport = true
                    }
                    
                    SettingsRow(
                        icon: "lock.fill",
                        title: "Privacy",
                        subtitle: "Data usage and privacy settings",
                        color: .indigo
                    ) {
                        // Navigate to privacy settings
                    }
                }
                
                // Support
                Section("Support") {
                    SettingsRow(
                        icon: "questionmark.circle.fill",
                        title: "Help & Support",
                        subtitle: "Get help with the app",
                        color: .purple
                    ) {
                        // Navigate to support
                    }
                    
                    SettingsRow(
                        icon: "envelope.fill",
                        title: "Contact Us",
                        subtitle: "Send feedback or report issues",
                        color: .blue
                    ) {
                        // Navigate to contact
                    }
                    
                    SettingsRow(
                        icon: "info.circle.fill",
                        title: "About",
                        subtitle: "App version and info",
                        color: .gray
                    ) {
                        // Navigate to about
                    }
                }
                
                // Account Actions
                Section {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "arrow.right.square")
                                .foregroundColor(.red)
                                .frame(width: 24)
                            
                            Text("Sign Out")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(user: currentUser)
            }
            .sheet(isPresented: $showingDataExport) {
                DataExportView()
            }
        }
    }
}

struct DataExportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isExporting = false
    @State private var exportComplete = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                VStack(spacing: 16) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                    
                    Text("Export Your Data")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Download all your fitness data including workouts, nutrition logs, and progress photos.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                if exportComplete {
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.green)
                        
                        Text("Export Complete!")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("Your data has been saved to your Files app.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                } else {
                    VStack(spacing: 16) {
                        if isExporting {
                            ProgressView()
                                .scaleEffect(1.2)
                            
                            Text("Preparing your data...")
                                .font(.body)
                                .foregroundColor(.secondary)
                        } else {
                            Button(action: startExport) {
                                Text("Start Export")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(12)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Export Data")
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
    
    private func startExport() {
        isExporting = true
        
        // Simulate export process
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            isExporting = false
            exportComplete = true
        }
    }
}

struct MockNotifications {
    static let sampleNotifications = [
        AppNotification(
            id: "1",
            title: "Workout Reminder",
            body: "Time for your upper body workout! You've got this 💪",
            type: .workout,
            timestamp: Calendar.current.date(byAdding: .minute, value: -15, to: Date()) ?? Date(),
            isRead: false
        ),
        AppNotification(
            id: "2",
            title: "Achievement Unlocked!",
            body: "Congratulations! You've completed 7 days in a row. Keep up the great work!",
            type: .achievement,
            timestamp: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date(),
            isRead: false
        ),
        AppNotification(
            id: "3",
            title: "Meal Logging",
            body: "Remember to log your lunch to stay on track with your nutrition goals.",
            type: .nutrition,
            timestamp: Calendar.current.date(byAdding: .hour, value: -6, to: Date()) ?? Date(),
            isRead: true
        ),
        AppNotification(
            id: "4",
            title: "Weekly Check-in",
            body: "How are you feeling about your progress this week? Take a moment to reflect.",
            type: .reminder,
            timestamp: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
            isRead: true
        )
    ]
}

#Preview {
    SettingsView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
