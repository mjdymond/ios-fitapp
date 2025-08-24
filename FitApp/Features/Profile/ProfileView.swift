import SwiftUI
import CoreData

struct ProfileView: View {
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
            .navigationTitle("Profile")
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

struct ProfileHeaderView: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 16) {
            // Avatar
            Circle()
                .fill(LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 80, height: 80)
                .overlay(
                    Text(String(user.name?.first ?? "U"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
            
            // User Info
            VStack(spacing: 8) {
                Text(user.name ?? "User")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                if let email = user.email {
                    Text(email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            // Stats
            HStack(spacing: 32) {
                StatView(
                    title: "Current",
                    value: "\(Int(user.currentWeight)) lbs",
                    color: .blue
                )
                
                StatView(
                    title: "Target",
                    value: "\(Int(user.targetWeight)) lbs",
                    color: .green
                )
                
                StatView(
                    title: "Height",
                    value: formatHeight(user.height),
                    color: .orange
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private func formatHeight(_ inches: Double) -> String {
        let feet = Int(inches / 12)
        let remainingInches = Int(inches.truncatingRemainder(dividingBy: 12))
        return "\(feet)'\(remainingInches)\""
    }
}

struct StatView: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct CreateProfilePrompt: View {
    let onCreate: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.circle")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("Create Your Profile")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Set up your profile to get personalized fitness recommendations")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: onCreate) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .padding()
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EditProfileView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let user: User?
    
    @State private var name = ""
    @State private var email = ""
    @State private var currentWeight = ""
    @State private var targetWeight = ""
    @State private var height = ""
    @State private var dateOfBirth = Date()
    @State private var activityLevel = "Moderate"
    
    let activityLevels = ["Sedentary", "Light", "Moderate", "Active", "Very Active"]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Personal Information") {
                    TextField("Full Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                }
                
                Section("Physical Information") {
                    HStack {
                        Text("Current Weight")
                        Spacer()
                        TextField("Weight", text: $currentWeight)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("lbs")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Target Weight")
                        Spacer()
                        TextField("Weight", text: $targetWeight)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("lbs")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Height")
                        Spacer()
                        TextField("Height", text: $height)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("inches")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Activity Level") {
                    Picker("Activity Level", selection: $activityLevel) {
                        ForEach(activityLevels, id: \.self) { level in
                            Text(level).tag(level)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            .navigationTitle(user == nil ? "Create Profile" : "Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                    }
                    .disabled(name.isEmpty || email.isEmpty)
                }
            }
            .onAppear {
                loadUserData()
            }
        }
    }
    
    private func loadUserData() {
        if let user = user {
            name = user.name ?? ""
            email = user.email ?? ""
            currentWeight = user.currentWeight > 0 ? String(user.currentWeight) : ""
            targetWeight = user.targetWeight > 0 ? String(user.targetWeight) : ""
            height = user.height > 0 ? String(user.height) : ""
            dateOfBirth = user.dateOfBirth ?? Date()
            activityLevel = user.activityLevel ?? "Moderate"
        }
    }
    
    private func saveProfile() {
        let userToSave: User
        if let existingUser = user {
            userToSave = existingUser
        } else {
            userToSave = User(context: viewContext)
            userToSave.id = UUID()
            userToSave.createdAt = Date()
        }
        
        userToSave.name = name
        userToSave.email = email
        userToSave.dateOfBirth = dateOfBirth
        userToSave.activityLevel = activityLevel
        
        if let weightValue = Double(currentWeight) {
            userToSave.currentWeight = weightValue
        }
        
        if let targetValue = Double(targetWeight) {
            userToSave.targetWeight = targetValue
        }
        
        if let heightValue = Double(height) {
            userToSave.height = heightValue
        }
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Failed to save profile: \(error)")
        }
    }
}

#Preview {
    ProfileView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
