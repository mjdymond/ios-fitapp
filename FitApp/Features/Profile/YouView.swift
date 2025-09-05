import SwiftUI
import CoreData

struct YouView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.createdAt, ascending: true)],
        animation: .default)
    private var users: FetchedResults<User>
    
    @State private var showingEditProfile = false
    
    var currentUser: User? {
        users.first
    }
    
    var body: some View {
        NavigationView {
            List {
                // Profile Header
                if let user = currentUser {
                    ProfileHeaderView(user: user)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                } else {
                    CreateProfilePrompt {
                        showingEditProfile = true
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                
                // Settings Sections
                Section("Health") {
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
                        subtitle: "Set your fitness targets",
                        color: .blue
                    ) {
                        // Navigate to goals
                    }
                }
                
                Section("App") {
                    SettingsRow(
                        icon: "bell.fill",
                        title: "Notifications",
                        subtitle: "Workout reminders",
                        color: .orange
                    ) {
                        // Navigate to notifications
                    }
                    
                    SettingsRow(
                        icon: "square.and.arrow.up",
                        title: "Export Data",
                        subtitle: "Download your fitness data",
                        color: .green
                    ) {
                        // Export functionality
                    }
                }
                
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
                        icon: "info.circle.fill",
                        title: "About",
                        subtitle: "App version and info",
                        color: .gray
                    ) {
                        // Navigate to about
                    }
                }
            }
            .navigationTitle("You")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if currentUser != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Edit") {
                            showingEditProfile = true
                        }
                    }
                }
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(user: currentUser)
            }
        }
    }
}

#Preview {
    YouView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
