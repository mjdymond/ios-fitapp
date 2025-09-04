import SwiftUI
import CoreData

struct FitnessProgressView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WeightEntry.date, ascending: false)],
        animation: .default)
    private var weightEntries: FetchedResults<WeightEntry>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.createdAt, ascending: false)],
        animation: .default)
    private var users: FetchedResults<User>
    
    @State private var showingWeightEntry = false
    @State private var selectedTimeRange = TimeRange.ninetyDays
    @State private var selectedWeekRange = "This week"
    
    enum TimeRange: String, CaseIterable {
        case ninetyDays = "90 Days"
        case sixMonths = "6 Months" 
        case oneYear = "1 Year"
        case allTime = "All time"
    }
    
    private var currentUser: User? {
        users.first
    }
    
    private var currentWeight: Double {
        currentUser?.currentWeight ?? 212.0
    }
    
    private var goalWeight: Double {
        currentUser?.targetWeight ?? 190.0
    }
    
    private var bmiValue: Double {
        let heightInMeters = (currentUser?.height ?? 70) * 0.0254 // Convert inches to meters
        let weightInKg = currentWeight * 0.453592 // Convert lbs to kg
        return weightInKg / (heightInMeters * heightInMeters)
    }
    
    private var bmiStatus: (text: String, color: Color) {
        switch bmiValue {
        case ..<18.5:
            return ("Underweight", Color.blue)
        case 18.5..<25:
            return ("Healthy", Color.green)
        case 25..<30:
            return ("Overweight", Color.orange)
        default:
            return ("Obese", Color.red)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                headerSection
                
                // Top Cards Section (Weight + Streak)
                topCardsSection
                
                // Time Filter Section
                timeFilterSection
                
                // Goal Progress Section
                goalProgressSection
                
                // Weekly Filter Section
                weeklyFilterSection
                
                // Total Calories Section
                caloriesSection
                
                // BMI Section
                bmiSection
                
                // Bottom padding for tab bar
                Spacer()
                    .frame(height: 100)
            }
        }
        .background(Color(hex: "F2F2F7"))
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $showingWeightEntry) {
            WeightEntrySheet()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Text("Progress")
                .font(.system(size: 34, weight: .bold, design: .default))
                .foregroundColor(.black)
                .tracking(-0.4)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 24)
        .background(Color(hex: "F2F2F7"))
    }
    
    // MARK: - Top Cards Section
    private var topCardsSection: some View {
        HStack(spacing: 12) {
            // Weight Card
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("My Weight")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color(hex: "8E8E93"))
                    
                    Text("\(Int(currentWeight)) lbs")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(.black)
                        .tracking(-0.3)
                        .padding(.bottom, 8)
                    
                    Text("Goal \(Int(goalWeight)) lbs")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color(hex: "8E8E93"))
                }
                
                Spacer()
                
                Button(action: { showingWeightEntry = true }) {
                    HStack(spacing: 6) {
                        Text("Log weight")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.black)
                    .cornerRadius(12)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 164)
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
            
            // Streak Card
            VStack(spacing: 0) {
                // Fire icon with sparkles
                ZStack {
                    // Sparkles
                    sparkleIcon(size: 4, x: 8, y: 12)
                    sparkleIcon(size: 3, x: 36, y: 8)
                    sparkleIcon(size: 2, x: 40, y: 24)
                    
                    // Fire icon
                    Image(systemName: "flame.fill")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(Color(hex: "FF8C00"))
                }
                .frame(width: 48, height: 48)
                .padding(.bottom, 8)
                
                Text("0")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(Color(hex: "FF8C00"))
                    .padding(.bottom, 2)
                
                Text("Day Streak")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "FF8C00"))
                    .padding(.bottom, 12)
                
                // Week calendar
                VStack(spacing: 4) {
                    HStack(spacing: 0) {
                        ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                            Text(day)
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(Color(hex: "8E8E93"))
                                .frame(width: 14)
                        }
                    }
                    
                    HStack(spacing: 0) {
                        ForEach(0..<7) { _ in
                            Circle()
                                .fill(Color(hex: "E5E5EA"))
                                .frame(width: 8, height: 8)
                                .frame(width: 14)
                        }
                    }
                }
            }
            .frame(width: 140, height: 164)
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    // MARK: - Time Filter Section
    private var timeFilterSection: some View {
        let filterButtons = ForEach(TimeRange.allCases, id: \.self) { range in
            timeFilterButton(for: range)
        }
        
        return HStack(spacing: 2) {
            filterButtons
        }
        .padding(2)
        .background(Color(hex: "E5E5EA"))
        .cornerRadius(10)
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }
    
    private func timeFilterButton(for range: TimeRange) -> some View {
        let isSelected = selectedTimeRange == range
        
        return Button(action: { selectedTimeRange = range }) {
            Text(range.rawValue)
                .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .black : Color(hex: "8E8E93"))
                .frame(maxWidth: .infinity)
                .frame(height: 32)
                .background(isSelected ? Color.white : Color.clear)
                .cornerRadius(8)
        }
    }
    
    // MARK: - Goal Progress Section
    private var goalProgressSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Goal Progress")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .tracking(-0.2)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "flag.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "8E8E93"))
                    
                    Text("0% of goal")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color(hex: "8E8E93"))
                }
            }
            .padding(.bottom, 24)
            
            // Chart area
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    VStack(alignment: .trailing, spacing: 0) {
                        Text("216")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color(hex: "8E8E93"))
                        Spacer()
                        Text("214")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color(hex: "8E8E93"))
                        Spacer()
                        Text("212")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color(hex: "8E8E93"))
                        Spacer()
                        Text("210")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color(hex: "8E8E93"))
                        Spacer()
                        Text("208")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color(hex: "8E8E93"))
                    }
                    .frame(width: 30, height: 100)
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.black)
                            .frame(height: 2)
                            .position(x: 150, y: 50)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 100)
                }
            }
            .padding(.bottom, 20)
            
            // Motivational message
            HStack {
                Spacer()
                Text("Getting started is the hardest part. You're ready for this!")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(hex: "34C759"))
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .padding(16)
            .background(Color(hex: "34C759").opacity(0.1))
            .cornerRadius(12)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }
    
    // MARK: - Weekly Filter Section
    private var weeklyFilterSection: some View {
        let weeks = ["This week", "Last week", "2 wks. ago", "3 wks. ago"]
        let weekButtons = ForEach(weeks, id: \.self) { week in
            weekFilterButton(for: week)
        }
        
        return HStack(spacing: 2) {
            weekButtons
        }
        .padding(2)
        .background(Color(hex: "E5E5EA"))
        .cornerRadius(10)
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }
    
    private func weekFilterButton(for week: String) -> some View {
        let isSelected = selectedWeekRange == week
        
        return Button(action: { selectedWeekRange = week }) {
            Text(week)
                .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .black : Color(hex: "8E8E93"))
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .background(isSelected ? Color.white : Color.clear)
                .cornerRadius(8)
        }
    }
    
    // MARK: - Total Calories Section
    private var caloriesSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Total Calories")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black)
                .tracking(-0.2)
                .padding(.bottom, 40)
            
            // Empty state
            VStack(spacing: 16) {
                // Chart icon
                VStack(spacing: 2) {
                    Rectangle()
                        .fill(Color(hex: "8E8E93").opacity(0.3))
                        .frame(width: 24, height: 18)
                        .cornerRadius(2)
                    
                    HStack(spacing: 2) {
                        ForEach(0..<6) { index in
                            Rectangle()
                                .fill(Color(hex: "8E8E93").opacity(0.3))
                                .frame(width: 3, height: [4, 6, 8, 5, 7, 4][index])
                                .cornerRadius(1)
                        }
                    }
                }
                .frame(width: 32, height: 32)
                
                VStack(spacing: 8) {
                    Text("No data to show")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("This will update as you log more food.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color(hex: "8E8E93"))
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 120)
            .padding(.vertical, 20)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }
    
    // MARK: - BMI Section
    private var bmiSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Your BMI")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .tracking(-0.2)
                
                Spacer()
                
                Button(action: {}) {
                    Text("i")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "8E8E93"))
                        .frame(width: 20, height: 20)
                        .overlay(
                            Circle()
                                .stroke(Color(hex: "8E8E93"), lineWidth: 1.5)
                        )
                }
            }
            .padding(.bottom, 16)
            
            // BMI Value
            Text(String(format: "%.1f", bmiValue))
                .font(.system(size: 48, weight: .semibold))
                .foregroundColor(.black)
                .tracking(-0.5)
                .padding(.bottom, 8)
            
            // Status
            HStack(spacing: 0) {
                Text("Your weight is ")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(Color(hex: "8E8E93"))
                
                Text(bmiStatus.text)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(bmiStatus.color)
                    .cornerRadius(12)
            }
            .padding(.bottom, 20)
            
            // BMI Scale
            VStack(spacing: 12) {
                ZStack(alignment: .leading) {
                    // Scale background with gradient
                    LinearGradient(
                        colors: [
                            Color.blue,      // Underweight
                            Color.green,     // Healthy
                            Color.yellow,    // Overweight
                            Color.orange,    // Overweight
                            Color.red        // Obese
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(height: 8)
                    .cornerRadius(4)
                    
                    // BMI indicator
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 2, height: 12)
                        .cornerRadius(1)
                        .offset(x: getBMIIndicatorPosition(), y: -2)
                }
                .frame(height: 8)
                
                // Legend
                HStack {
                    legendItem(color: .blue, text: "Under")
                    Spacer()
                    legendItem(color: .green, text: "Healthy")
                    Spacer()
                    legendItem(color: .yellow, text: "Over")
                    Spacer()
                    legendItem(color: .red, text: "Obese")
                }
                .padding(.horizontal, 2)
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        .padding(.horizontal, 20)
        .padding(.bottom, 100)
    }
    
    // MARK: - Helper Views
    private func sparkleIcon(size: CGFloat, x: CGFloat, y: CGFloat) -> some View {
        Image(systemName: "sparkle")
            .font(.system(size: size, weight: .medium))
            .foregroundColor(Color(hex: "FFD700"))
            .offset(x: x - 24, y: y - 24)
    }
    
    private func legendItem(color: Color, text: String) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
            
            Text(text)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(Color(hex: "8E8E93"))
        }
    }
    
    private func getBMIIndicatorPosition() -> CGFloat {
        let minBMI: Double = 15
        let maxBMI: Double = 35
        let normalizedBMI = min(max(bmiValue, minBMI), maxBMI)
        let percentage = (normalizedBMI - minBMI) / (maxBMI - minBMI)
        return CGFloat(percentage) * 300 // Approximate width of the scale
    }
}

// MARK: - Weight Entry Sheet
struct WeightEntrySheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @State private var weightValue: Double = 212
    @State private var selectedDate = Date()
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Text("Log Weight")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("\(Int(weightValue))")
                                .font(.system(size: 48, weight: .semibold))
                                .foregroundColor(.black)
                            Text("lbs")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(Color(hex: "8E8E93"))
                        }
                        
                        Slider(value: $weightValue, in: 100...400, step: 1)
                            .accentColor(.black)
                    }
                }
                
                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes (Optional)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    TextField("Add a note...", text: $notes)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Spacer()
                
                Button("Save Weight") {
                    saveWeightEntry()
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.black)
                .cornerRadius(12)
            }
            .padding(20)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func saveWeightEntry() {
        guard let user = fetchOrCreateUser() else { return }
        
        let entry = WeightEntry(context: viewContext)
        entry.id = UUID()
        entry.weight = weightValue
        entry.date = selectedDate
        entry.notes = notes.isEmpty ? nil : notes
        entry.user = user
        
        // Update user's current weight if this is the most recent entry
        if selectedDate >= (user.weightEntries?.compactMap { ($0 as? WeightEntry)?.date }.max() ?? Date.distantPast) {
            user.currentWeight = weightValue
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Error saving weight entry: \(error)")
        }
    }
    
    private func fetchOrCreateUser() -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchLimit = 1
        
        do {
            let users = try viewContext.fetch(request)
            if let existingUser = users.first {
                return existingUser
            } else {
                // Create a new user if none exists
                let newUser = User(context: viewContext)
                newUser.id = UUID()
                newUser.name = "User"
                newUser.email = ""
                newUser.createdAt = Date()
                newUser.currentWeight = weightValue
                newUser.targetWeight = 190
                newUser.height = 70 // Default height in inches
                return newUser
            }
        } catch {
            print("Error fetching user: \(error)")
            return nil
        }
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    FitnessProgressView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}