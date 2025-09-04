import SwiftUI
import CoreData
import Foundation

// MARK: - Notification Names

extension Notification.Name {
    static let onboardingCompleted = Notification.Name("onboardingCompleted")
}

// MARK: - Onboarding Data Model

class OnboardingData: ObservableObject {
    // MARK: - Published Properties
    
    // Page 2: Gender Selection
    @Published var selectedGender: Gender?
    
    // Page 3: Workout Frequency
    @Published var workoutFrequency: WorkoutFrequency?
    
    // Page 4: Demographics
    @Published var referralSource: ReferralSource?
    @Published var hasPriorAppUsage: Bool?
    @Published var isImperialSystem = true
    @Published var heightFeet: Int = 5
    @Published var heightInches: Int = 8
    @Published var heightCentimeters: Int = 170
    @Published var weightPounds: Double = 150
    @Published var weightKilograms: Double = 68
    @Published var dateOfBirth: Date = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()
    
    // Page 5: Goal Setting
    @Published var goalType: GoalType?
    @Published var currentWeight: Double = 150
    @Published var targetWeight: Double = 140
    @Published var weightLossSpeed: WeightLossSpeed = .moderate
    
    // Page 6: Obstacles & Preferences
    @Published var selectedObstacles: Set<Obstacle> = []
    @Published var dietType: DietType?
    @Published var selectedAccomplishments: Set<Accomplishment> = []
    
    // Page 7: Plan Generation Settings
    @Published var connectToAppleHealth = false
    @Published var addCaloriesBurnedBack = false
    @Published var rolloverExtraCalories = false
    @Published var enableNotifications = false
    @Published var referralCode: String = ""
    @Published var appRating: Int = 0
    
    // MARK: - Computed Properties
    
    var currentWeightInPounds: Double {
        isImperialSystem ? weightPounds : weightKilograms * 2.20462
    }
    
    var heightInInches: Double {
        isImperialSystem ? Double(heightFeet * 12 + heightInches) : Double(heightCentimeters) / 2.54
    }
    
    var weightDifference: Double {
        currentWeight - targetWeight
    }
    
    var isWeightLoss: Bool {
        goalType == .lose
    }
    
    var targetWeightLossPerWeek: Double {
        switch weightLossSpeed {
        case .slow: return 0.5
        case .moderate: return 1.0
        case .fast: return 1.5
        }
    }
    
    // MARK: - Validation
    
    func isPageValid(_ page: OnboardingPage) -> Bool {
        switch page {
        case .welcome:
            return true
        case .genderSelection:
            return selectedGender != nil
        case .workoutFrequency:
            return workoutFrequency != nil
        case .referralSource:
            return referralSource != nil
        case .priorAppUsage:
            return hasPriorAppUsage != nil
        case .weightHeight:
            return true // Always valid since we have defaults
        case .dateOfBirth:
            return true // Always valid since we have defaults
        case .goalType:
            return goalType != nil
        case .desiredWeight:
            return targetWeight > 0
        case .weightLossSpeed:
            return true // Always valid since we have defaults
        case .obstacles:
            return !selectedObstacles.isEmpty
        case .dietType:
            return dietType != nil
        case .accomplishments:
            return !selectedAccomplishments.isEmpty
        default:
            return true
        }
    }
}

// MARK: - Enums

enum Gender: String, CaseIterable {
    case male = "Male"
    case female = "Female"
    case other = "Other"
}

enum WorkoutFrequency: String, CaseIterable {
    case low = "0-2 Workouts now and then"
    case moderate = "3-5 A few workouts per week"  
    case high = "6+ Dedicated athlete"
}

enum ReferralSource: String, CaseIterable {
    case tv = "TV"
    case youtube = "YouTube"
    case instagram = "Instagram"
    case facebook = "Facebook"
    case tiktok = "TikTok"
    case friend = "Friend or Family"
    case appStore = "App Store"
    case google = "Google Search"
    case other = "Other"
}

enum GoalType: String, CaseIterable {
    case lose = "Lose weight"
    case maintain = "Maintain"
    case gain = "Gain weight"
}

enum WeightLossSpeed: String, CaseIterable {
    case slow = "Slow & Steady"
    case moderate = "Moderate"
    case fast = "Fast Track"
    
    var emoji: String {
        switch self {
        case .slow: return "🐌"
        case .moderate: return "🐰"
        case .fast: return "🐆"
        }
    }
    
    var weeklyLoss: Double {
        switch self {
        case .slow: return 0.5
        case .moderate: return 1.0
        case .fast: return 1.5
        }
    }
}

enum Obstacle: String, CaseIterable {
    case consistency = "Lack of consistency"
    case unhealthyEating = "Unhealthy eating habits"
    case timeManagement = "Time management"
    case motivation = "Staying motivated"
    case socialPressure = "Social eating pressure"
    case emotionalEating = "Emotional eating"
    case plateaus = "Weight loss plateaus"
    case cravings = "Food cravings"
    
    var icon: String {
        switch self {
        case .consistency: return "clock"
        case .unhealthyEating: return "fork.knife"
        case .timeManagement: return "calendar"
        case .motivation: return "heart"
        case .socialPressure: return "person.2"
        case .emotionalEating: return "face.smiling"
        case .plateaus: return "chart.line.flattrend.xyaxis"
        case .cravings: return "brain"
        }
    }
}

enum DietType: String, CaseIterable {
    case classic = "Classic"
    case pescatarian = "Pescatarian"
    case vegetarian = "Vegetarian"
    case vegan = "Vegan"
}

enum Accomplishment: String, CaseIterable {
    case healthierLiving = "Eat and live healthier"
    case boostEnergy = "Boost my energy and mood"
    case improveConfidence = "Improve my confidence"
    case betterSleep = "Get better sleep"
    case buildHabits = "Build sustainable habits"
    case feelStronger = "Feel stronger and fitter"
    case reduceStress = "Reduce stress levels"
    case improveHealth = "Improve overall health markers"
    
    var icon: String {
        switch self {
        case .healthierLiving: return "leaf"
        case .boostEnergy: return "bolt"
        case .improveConfidence: return "star"
        case .betterSleep: return "bed.double"
        case .buildHabits: return "repeat"
        case .feelStronger: return "figure.strengthtraining.traditional"
        case .reduceStress: return "heart.circle"
        case .improveHealth: return "cross.case"
        }
    }
}

enum OnboardingPage: String, CaseIterable {
    case welcome
    case genderSelection
    case workoutFrequency
    case referralSource
    case priorAppUsage
    case weightHeight
    case dateOfBirth
    case goalType
    case desiredWeight
    case weightLossSpeed
    case obstacles
    case dietType
    case accomplishments
    case planGeneration
    case appleHealth
    case calorieSettings
    case rating
    case notifications
    case referralCode
    case loading
    case planSummary
    case authentication
    case trialOffer
    case discountWheel
    case payment
}

// MARK: - Main Onboarding Coordinator

struct OnboardingCoordinator: View {
    @StateObject private var onboardingData = OnboardingData()
    @State private var currentPage: OnboardingPage = .welcome
    @State private var pageStack: [OnboardingPage] = []
    @State private var isCompleted = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color.black.ignoresSafeArea()
                
                // Current Page Content
                currentPageView
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
            .animation(.easeInOut(duration: 0.3), value: currentPage)
        }
        .navigationBarHidden(true)
        .environmentObject(onboardingData)
    }
    
    @ViewBuilder
    private var currentPageView: some View {
        switch currentPage {
        case .welcome:
            OnboardingWelcomeView(onNext: { navigateToNext() })
        case .genderSelection:
            OnboardingGenderSelectionView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .workoutFrequency:
            OnboardingWorkoutFrequencyView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .goalType:
            OnboardingGoalTypeView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        default:
            OnboardingCompletionView(onComplete: { completeOnboarding() })
        }
    }
    
    // MARK: - Navigation Methods
    
    private func navigateToNext() {
        let nextPage = getNextPage(from: currentPage)
        if let nextPage = nextPage {
            pageStack.append(currentPage)
            withAnimation {
                currentPage = nextPage
            }
        }
    }
    
    private func navigateBack() {
        if let previousPage = pageStack.popLast() {
            withAnimation {
                currentPage = previousPage
            }
        }
    }
    
    private func completeOnboarding() {
        // Save onboarding data to Core Data
        saveOnboardingData()
        
        // Notify ContentView that onboarding is complete
        NotificationCenter.default.post(name: .onboardingCompleted, object: nil)
        
        // Mark as completed to trigger view refresh
        isCompleted = true
    }
    
    // MARK: - Helper Methods
    
    private func getNextPage(from current: OnboardingPage) -> OnboardingPage? {
        switch current {
        case .welcome:
            return .genderSelection
        case .genderSelection:
            return .workoutFrequency
        case .workoutFrequency:
            return .goalType
        default:
            return nil // End of simplified flow for now
        }
    }
    
    private func saveOnboardingData() {
        let context = PersistenceController.shared.container.viewContext
        
        // Create User entity with onboarding data
        let user = User(context: context)
        user.id = UUID()
        user.name = "New User"
        user.email = ""
        user.createdAt = Date()
        
        // Demographics
        if let gender = onboardingData.selectedGender {
            user.setValue(gender.rawValue, forKey: "gender")
        }
        user.height = onboardingData.heightInInches
        user.currentWeight = onboardingData.currentWeightInPounds
        user.targetWeight = onboardingData.targetWeight
        user.dateOfBirth = onboardingData.dateOfBirth
        
        // Goal and preferences
        if let goalType = onboardingData.goalType {
            user.setValue(goalType.rawValue, forKey: "goalType")
        }
        if let workoutFrequency = onboardingData.workoutFrequency {
            user.setValue(workoutFrequency.rawValue, forKey: "activityLevel")
        }
        
        // Create initial weight entry
        let weightEntry = WeightEntry(context: context)
        weightEntry.id = UUID()
        weightEntry.weight = onboardingData.currentWeightInPounds
        weightEntry.date = Date()
        weightEntry.notes = "Initial weight from onboarding"
        weightEntry.user = user
        
        // Save the context
        do {
            try context.save()
            print("✅ Onboarding data saved successfully!")
        } catch {
            print("❌ Error saving onboarding data: \(error)")
        }
    }
}

// MARK: - Onboarding Views

struct OnboardingWelcomeView: View {
    let onNext: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Banner Image Section
                    ZStack {
                        // Gradient background
                        LinearGradient(
                            colors: [Color.orange.opacity(0.8), Color.red.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: geometry.size.height * 0.55)
                        
                        // Mock calorie overlay
                        VStack {
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    // Calorie bubble
                                    HStack(spacing: 4) {
                                        Image(systemName: "flame.fill")
                                            .foregroundColor(.orange)
                                            .font(.system(size: 12))
                                        
                                        Text("420 cal")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.black)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.white)
                                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                    )
                                    
                                    Text("Grilled Salmon Bowl")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.black.opacity(0.6))
                                        )
                                }
                                .padding(.trailing, 20)
                                .padding(.bottom, 40)
                            }
                        }
                        
                        // Food illustration
                        VStack {
                            Spacer()
                            
                            HStack {
                                VStack(spacing: 8) {
                                    Image(systemName: "fork.knife.circle.fill")
                                        .font(.system(size: 60))
                                        .foregroundColor(.white.opacity(0.9))
                                    
                                    Image(systemName: "leaf.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.green.opacity(0.8))
                                        .offset(x: 20, y: -10)
                                }
                                .padding(.leading, 40)
                                
                                Spacer()
                            }
                            
                            Spacer()
                        }
                    }
                    
                    // Content Section
                    VStack(spacing: 40) {
                        // Title
                        Text("Calorie tracking made easy")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        // Get Started Button
                        VStack(spacing: 16) {
                            OnboardingPrimaryButton("Get Started") {
                                onNext()
                            }
                            
                            Text("Transform your fitness journey")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.bottom, 40)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.height * 0.45)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct OnboardingGenderSelectionView: View {
    @EnvironmentObject private var onboardingData: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress Indicator
            VStack(spacing: 20) {
                OnboardingProgressIndicator(currentStep: 1, totalSteps: 4)
                
                // Back Button
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            .padding(.top, 20)
            
            Spacer()
            
            // Content
            VStack(spacing: 40) {
                // Header
                VStack(spacing: 12) {
                    Text("Choose your Gender")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("This will be used to calibrate your custom plan")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                // Gender Selection Buttons
                VStack(spacing: 16) {
                    ForEach(Gender.allCases, id: \.self) { gender in
                        OnboardingSelectionButton(
                            item: gender,
                            title: gender.rawValue,
                            isSelected: onboardingData.selectedGender == gender
                        ) { selectedGender in
                            onboardingData.selectedGender = selectedGender
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
            
            // Continue Button
            VStack(spacing: 16) {
                OnboardingPrimaryButton(
                    "Continue",
                    isEnabled: onboardingData.selectedGender != nil
                ) {
                    onNext()
                }
                
                Text("Step 1 of 4")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

struct OnboardingWorkoutFrequencyView: View {
    @EnvironmentObject private var onboardingData: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress Indicator
            VStack(spacing: 20) {
                OnboardingProgressIndicator(currentStep: 2, totalSteps: 4)
                
                // Back Button
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            .padding(.top, 20)
            
            Spacer()
            
            // Content
            VStack(spacing: 40) {
                // Header
                VStack(spacing: 12) {
                    Text("How many workouts do you do per week?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    Text("This will be used to calibrate your custom plan")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                // Workout Frequency Selection
                VStack(spacing: 16) {
                    ForEach(WorkoutFrequency.allCases, id: \.self) { frequency in
                        OnboardingMultiSelectItem(
                            item: frequency,
                            title: frequency.rawValue,
                            isSelected: onboardingData.workoutFrequency == frequency
                        ) { selectedFrequency in
                            onboardingData.workoutFrequency = selectedFrequency
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
            
            // Continue Button
            VStack(spacing: 16) {
                OnboardingPrimaryButton(
                    "Continue",
                    isEnabled: onboardingData.workoutFrequency != nil
                ) {
                    onNext()
                }
                
                Text("Step 2 of 4")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

struct OnboardingGoalTypeView: View {
    @EnvironmentObject private var onboardingData: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress Indicator
            VStack(spacing: 20) {
                OnboardingProgressIndicator(currentStep: 3, totalSteps: 4)
                
                // Back Button
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            .padding(.top, 20)
            
            Spacer()
            
            // Content
            VStack(spacing: 40) {
                // Header
                VStack(spacing: 12) {
                    Text("What's your main goal?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Choose the option that best describes your fitness goal")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                // Goal Type Buttons
                VStack(spacing: 16) {
                    ForEach(GoalType.allCases, id: \.self) { goalType in
                        Button(action: {
                            onboardingData.goalType = goalType
                        }) {
                            HStack(spacing: 16) {
                                // Goal Icon
                                Image(systemName: iconForGoalType(goalType))
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(onboardingData.goalType == goalType ? .white : .gray)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(goalType.rawValue)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(onboardingData.goalType == goalType ? .white : .gray)
                                    
                                    Text(descriptionForGoalType(goalType))
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(onboardingData.goalType == goalType ? .white.opacity(0.8) : .gray.opacity(0.7))
                                        .multilineTextAlignment(.leading)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .frame(height: 80)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(onboardingData.goalType == goalType ? Color.black : Color.gray.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(onboardingData.goalType == goalType ? Color.white.opacity(0.3) : Color.clear, lineWidth: 1)
                                    )
                            )
                        }
                        .animation(.easeInOut(duration: 0.2), value: onboardingData.goalType)
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
            
            // Continue Button
            VStack(spacing: 16) {
                OnboardingPrimaryButton(
                    "Continue",
                    isEnabled: onboardingData.goalType != nil
                ) {
                    onNext()
                }
                
                Text("Step 3 of 4")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .navigationBarHidden(true)
    }
    
    private func iconForGoalType(_ goalType: GoalType) -> String {
        switch goalType {
        case .lose:
            return "arrow.down.circle.fill"
        case .maintain:
            return "equal.circle.fill"
        case .gain:
            return "arrow.up.circle.fill"
        }
    }
    
    private func descriptionForGoalType(_ goalType: GoalType) -> String {
        switch goalType {
        case .lose:
            return "Reduce body weight with a calorie deficit"
        case .maintain:
            return "Stay at your current weight"
        case .gain:
            return "Increase body weight or build muscle"
        }
    }
}

struct OnboardingCompletionView: View {
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress Indicator
            VStack(spacing: 20) {
                OnboardingProgressIndicator(currentStep: 4, totalSteps: 4)
            }
            .padding(.top, 20)
            
            Spacer()
            
            // Content
            VStack(spacing: 40) {
                // Completion Icon
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                
                // Header
                VStack(spacing: 12) {
                    Text("You're all set!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Your personalized fitness journey begins now")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                // Features Preview
                VStack(spacing: 16) {
                    FeatureRow(icon: "dumbbell.fill", title: "Track Workouts", description: "Log your exercises and track progress")
                    FeatureRow(icon: "scalemass.fill", title: "Monitor Weight", description: "Keep track of your weight journey")
                    FeatureRow(icon: "fork.knife", title: "Plan Meals", description: "Plan and track your nutrition")
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
            
            // Start Button
            VStack(spacing: 16) {
                OnboardingPrimaryButton("Start Your Journey") {
                    onComplete()
                }
                
                Text("Complete! Welcome to FitApp")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.blue)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Shared UI Components

struct OnboardingSelectionButton<T: Hashable>: View {
    let item: T
    let title: String
    let isSelected: Bool
    let action: (T) -> Void
    
    var body: some View {
        Button(action: { action(item) }) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isSelected ? .white : .gray)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color.black : Color.gray.opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isSelected ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
                        )
                )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct OnboardingMultiSelectItem<T: Hashable>: View {
    let item: T
    let title: String
    let isSelected: Bool
    let action: (T) -> Void
    
    var body: some View {
        Button(action: { action(item) }) {
            HStack(spacing: 16) {
                // Selection indicator (bullet point)
                Image(systemName: isSelected ? "circle.fill" : "circle")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .white : .gray)
                
                // Title
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? .white : .gray)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.black : Color.gray.opacity(0.1))
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct OnboardingProgressIndicator: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<totalSteps, id: \.self) { step in
                RoundedRectangle(cornerRadius: 2)
                    .fill(step <= currentStep ? Color.white : Color.white.opacity(0.3))
                    .frame(height: 3)
            }
        }
        .padding(.horizontal)
    }
}

struct OnboardingPrimaryButton: View {
    let title: String
    let action: () -> Void
    let isEnabled: Bool
    
    init(_ title: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(isEnabled ? .white : .gray)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(isEnabled ? Color.black : Color.gray.opacity(0.3))
                )
        }
        .disabled(!isEnabled)
        .padding(.horizontal)
    }
}