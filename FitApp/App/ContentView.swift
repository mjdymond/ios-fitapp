import SwiftUI
import CoreData
import Foundation

// MARK: - Notification Names

extension Notification.Name {
    static let onboardingCompleted = Notification.Name("onboardingCompleted")
}

// MARK: - Simple Enum Definitions

enum Gender: String, CaseIterable {
    case male = "male"
    case female = "female" 
    case other = "other"
    
    var description: String { rawValue.capitalized }
}

enum WorkoutFrequency: String, CaseIterable {
    case sedentary = "sedentary"
    case lightlyActive = "lightly_active"
    case moderatelyActive = "moderately_active" 
    case veryActive = "very_active"
    case superActive = "super_active"
    
    var description: String {
        switch self {
        case .sedentary: return "Sedentary (little/no exercise)"
        case .lightlyActive: return "Lightly Active (1-3 days/week)"
        case .moderatelyActive: return "Moderately Active (3-5 days/week)"
        case .veryActive: return "Very Active (6-7 days/week)"
        case .superActive: return "Super Active (2x/day, intense)"
        }
    }
}

enum GoalType: String, CaseIterable {
    case loseWeight = "lose_weight"
    case gainWeight = "gain_weight"
    case maintainWeight = "maintain_weight"
    case buildMuscle = "build_muscle"
    
    var description: String {
        switch self {
        case .loseWeight: return "Lose Weight"
        case .gainWeight: return "Gain Weight"
        case .maintainWeight: return "Maintain Weight"
        case .buildMuscle: return "Build Muscle"
        }
    }
}

enum ReferralSource: String, CaseIterable {
    case instagram = "instagram"
    case tiktok = "tiktok"
    case facebook = "facebook"
    case googleAds = "google_ads"
    case appStore = "app_store"
    case friendReferral = "friend_referral"
    case other = "other"
    
    var description: String {
        switch self {
        case .instagram: return "Instagram"
        case .tiktok: return "TikTok"
        case .facebook: return "Facebook"
        case .googleAds: return "Google Ads"
        case .appStore: return "App Store"
        case .friendReferral: return "Friend Referral"
        case .other: return "Other"
        }
    }
}

enum WeightLossSpeed: String, CaseIterable {
    case slow = "slow"
    case moderate = "moderate"
    case fast = "fast"
    
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
        case .fast: return 2.0
        }
    }
    
    var description: String {
        switch self {
        case .slow: return "Gradual and sustainable approach"
        case .moderate: return "Balanced pace with steady progress"
        case .fast: return "Aggressive but achievable timeline"
        }
    }
}

enum Obstacle: String, CaseIterable, Hashable {
    case timeConstraints = "time_constraints"
    case lackOfMotivation = "lack_of_motivation"
    case unhealthyEating = "unhealthy_eating"
    case stressEating = "stress_eating"
    case plateaus = "plateaus"
    case socialPressure = "social_pressure"
    case lackOfKnowledge = "lack_of_knowledge"
    case consistency = "consistency"
    
    var icon: String {
        switch self {
        case .timeConstraints: return "clock.fill"
        case .lackOfMotivation: return "battery.25"
        case .unhealthyEating: return "exclamationmark.triangle.fill"
        case .stressEating: return "heart.slash.fill"
        case .plateaus: return "chart.line.flattrend.xyaxis"
        case .socialPressure: return "person.2.fill"
        case .lackOfKnowledge: return "questionmark.circle.fill"
        case .consistency: return "repeat.circle.fill"
        }
    }
    
    var description: String {
        switch self {
        case .timeConstraints: return "Not enough time for workouts"
        case .lackOfMotivation: return "Struggling to stay motivated"
        case .unhealthyEating: return "Difficulty controlling eating habits"
        case .stressEating: return "Emotional or stress eating"
        case .plateaus: return "Hitting weight loss plateaus"
        case .socialPressure: return "Social situations and peer pressure"
        case .lackOfKnowledge: return "Don't know where to start"
        case .consistency: return "Staying consistent with routine"
        }
    }
}

enum DietType: String, CaseIterable {
    case standard = "standard"
    case keto = "keto"
    case paleo = "paleo"
    case mediterranean = "mediterranean"
    case vegetarian = "vegetarian"
    case vegan = "vegan"
    case intermittentFasting = "intermittent_fasting"
    case lowCarb = "low_carb"
    
    var name: String {
        switch self {
        case .standard: return "Standard"
        case .keto: return "Keto"
        case .paleo: return "Paleo"
        case .mediterranean: return "Mediterranean"
        case .vegetarian: return "Vegetarian"
        case .vegan: return "Vegan"
        case .intermittentFasting: return "Intermittent Fasting"
        case .lowCarb: return "Low Carb"
        }
    }
    
    var description: String {
        switch self {
        case .standard: return "Balanced approach with all food groups"
        case .keto: return "High fat, very low carb lifestyle"
        case .paleo: return "Whole foods, no processed ingredients"
        case .mediterranean: return "Heart-healthy with olive oil and fish"
        case .vegetarian: return "Plant-based with dairy and eggs"
        case .vegan: return "100% plant-based nutrition"
        case .intermittentFasting: return "Time-restricted eating windows"
        case .lowCarb: return "Reduced carbohydrate intake"
        }
    }
    
    var emoji: String {
        switch self {
        case .standard: return "🍽️"
        case .keto: return "🥓"
        case .paleo: return "🥩"
        case .mediterranean: return "🫒"
        case .vegetarian: return "🥗"
        case .vegan: return "🌱"
        case .intermittentFasting: return "⏰"
        case .lowCarb: return "🚫🍞"
        }
    }
}

// MARK: - Onboarding Data Model

class OnboardingData: ObservableObject {
    // Basic info
    @Published var selectedGender: Gender?
    @Published var workoutFrequency: WorkoutFrequency?
    @Published var goalType: GoalType?
    
    // Demographics
    @Published var isImperialSystem = true
    @Published var heightFeet: Int = 5
    @Published var heightInches: Int = 8
    @Published var heightCentimeters: Int = 170
    @Published var weightPounds: Double = 150
    @Published var weightKilograms: Double = 68
    @Published var dateOfBirth: Date = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()
    @Published var referralSource: ReferralSource?
    
    // Goal setting
    @Published var currentWeight: Double = 150
    @Published var targetWeight: Double = 140
    @Published var weightLossSpeed: WeightLossSpeed = .moderate
    
    // Preferences
    @Published var selectedObstacles: Set<Obstacle> = []
    @Published var selectedDietType: DietType?
    
    // Integration
    @Published var connectToAppleHealth = false
    
    var currentWeightInPounds: Double {
        isImperialSystem ? weightPounds : weightKilograms * 2.20462
    }
    
    var heightInInches: Double {
        isImperialSystem ? Double(heightFeet * 12 + heightInches) : Double(heightCentimeters) / 2.54
    }
    
    var weightDifference: Double {
        abs(currentWeight - targetWeight)
    }
    
    var weeksToGoal: Int {
        guard weightDifference > 0 else { return 0 }
        return Int(ceil(weightDifference / weightLossSpeed.weeklyLoss))
    }
    
    var isValid: Bool {
        selectedGender != nil && workoutFrequency != nil && goalType != nil
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var hasCompletedOnboarding = false
    @State private var forceOnboarding = true  // Force onboarding for testing
    
    var body: some View {
        if hasCompletedOnboarding && !forceOnboarding {
            // Main app interface
            TabView {
                NavigationView {
                    DashboardView()
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(1)

                FitnessProgressView()
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Progress")
                    }
                    .tag(2)
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
                    .tag(3)
            }
            .accentColor(.black)
            .onAppear {
                // Customize tab bar appearance
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithOpaqueBackground()
                tabBarAppearance.backgroundColor = UIColor.white
                tabBarAppearance.shadowColor = UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1)
                
                // Configure selected tab appearance
                tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.black
                tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                    .foregroundColor: UIColor.black,
                    .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
                ]
                
                // Configure normal tab appearance
                tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
                tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                    .foregroundColor: UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1),
                    .font: UIFont.systemFont(ofSize: 10, weight: .regular)
                ]
                
                UITabBar.appearance().standardAppearance = tabBarAppearance
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
            .onAppear {
                print("🏠 Main app appeared (hasCompletedOnboarding = \(hasCompletedOnboarding))")
                checkOnboardingStatus()
            }
        } else {
            // Onboarding Flow
            OnboardingCoordinator()
                .onAppear {
                    print("📝 Onboarding appeared (hasCompletedOnboarding = \(hasCompletedOnboarding))")
                    checkOnboardingStatus()
                }
                .onReceive(NotificationCenter.default.publisher(for: .onboardingCompleted)) { _ in
                    print("📨 Received onboarding completion notification!")
                    DispatchQueue.main.async {
                        print("📱 Setting hasCompletedOnboarding to true and disabling force onboarding")
                        hasCompletedOnboarding = true
                        forceOnboarding = false  // Allow transition to main app
                    }
                }
        }
    }
    
    private func checkOnboardingStatus() {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchLimit = 1
        
        do {
            let users = try viewContext.fetch(request)
            let completed = !users.isEmpty
            print("🔍 Checking onboarding status: found \(users.count) users, completed: \(completed)")
            hasCompletedOnboarding = completed
        } catch {
            print("❌ Error checking onboarding status: \(error)")
            hasCompletedOnboarding = false
        }
        
        // Note: forceOnboarding = true ensures onboarding shows on every rebuild
        // When onboarding completes, forceOnboarding is set to false to allow main app access
    }
}

// MARK: - Onboarding Coordinator

struct OnboardingCoordinator: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var onboardingData = OnboardingData()
    @State private var currentStep = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                Group {
                    switch currentStep {
                    case 0:
                        OnboardingWelcomeView { 
                            withAnimation { currentStep = 1 }
                        }
                    case 1:
                        OnboardingGenderView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 2 } 
                        }, onBack: { 
                            withAnimation { currentStep = 0 } 
                        })
                    case 2:
                        OnboardingWorkoutView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 3 } 
                        }, onBack: { 
                            withAnimation { currentStep = 1 } 
                        })
                    case 3:
                        OnboardingGoalView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 4 } 
                        }, onBack: { 
                            withAnimation { currentStep = 2 } 
                        })
                    case 4:
                        OnboardingWeightHeightView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 5 } 
                        }, onBack: { 
                            withAnimation { currentStep = 3 } 
                        })
                    case 5:
                        OnboardingDateOfBirthView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 6 } 
                        }, onBack: { 
                            withAnimation { currentStep = 4 } 
                        })
                    case 6:
                        OnboardingReferralView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 7 } 
                        }, onBack: { 
                            withAnimation { currentStep = 5 } 
                        })
                    case 7:
                        OnboardingDesiredWeightView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 8 } 
                        }, onBack: { 
                            withAnimation { currentStep = 6 } 
                        })
                    case 8:
                        OnboardingWeightLossSpeedView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 9 } 
                        }, onBack: { 
                            withAnimation { currentStep = 7 } 
                        })
                    case 9:
                        OnboardingObstaclesView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 10 } 
                        }, onBack: { 
                            withAnimation { currentStep = 8 } 
                        })
                    case 10:
                        OnboardingDietTypeView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 11 } 
                        }, onBack: { 
                            withAnimation { currentStep = 9 } 
                        })
                    case 11:
                        OnboardingPlanGenerationView(onNext: { 
                            withAnimation { currentStep = 12 } 
                        })
                    case 12:
                        OnboardingAppleHealthView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 13 } 
                        }, onBack: { 
                            withAnimation { currentStep = 11 } 
                        })
                    case 13:
                        OnboardingCompletionView { 
                            completeOnboarding() 
                        }
                    default:
                        OnboardingWelcomeView { 
                            withAnimation { currentStep = 1 } 
                        }
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            }
        }
        .navigationBarHidden(true)
        .environmentObject(onboardingData)
    }
    
    private func completeOnboarding() {
        print("🎯 Starting onboarding completion...")
        saveOnboardingData()
        print("🎯 Posting onboarding completion notification...")
        NotificationCenter.default.post(name: .onboardingCompleted, object: nil)
        print("🎯 Onboarding completion process finished")
    }
    
    private func saveOnboardingData() {
        let context = viewContext
        
        let user = User(context: context)
        user.id = UUID()
        user.name = "New User"
        user.email = ""
        user.createdAt = Date()
        user.currentWeight = onboardingData.currentWeightInPounds
        user.targetWeight = onboardingData.targetWeight
        user.height = onboardingData.heightInInches
        user.dateOfBirth = onboardingData.dateOfBirth
        
        // Only save to attributes that exist in Core Data model
        if let workoutFrequency = onboardingData.workoutFrequency {
            user.activityLevel = workoutFrequency.rawValue
        }
        
        let weightEntry = WeightEntry(context: context)
        weightEntry.id = UUID()
        weightEntry.weight = onboardingData.currentWeightInPounds
        weightEntry.date = Date()
        weightEntry.notes = "Initial weight from onboarding"
        weightEntry.user = user
        
        do {
            try context.save()
            print("✅ Onboarding data saved successfully!")
        } catch {
            print("❌ Error saving onboarding data: \(error)")
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

// MARK: - Onboarding Views

struct OnboardingWelcomeView: View {
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(
                            colors: [Color.orange.opacity(0.8), Color.red.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(height: 200)
                    
                    VStack(spacing: 12) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                        
                        Text("FitApp")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
            }
            
            VStack(spacing: 24) {
                Text("Welcome to your\nfitness journey!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Get a personalized plan based on your goals, preferences, and lifestyle")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
            
            Button(action: onNext) {
                Text("Get Started")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color.black)
                    )
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct OnboardingGenderView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingProgressBar(currentStep: 1, totalSteps: 13)
                .padding(.top, 20)
            
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            VStack(spacing: 30) {
                VStack(spacing: 12) {
                    Text("What's your gender?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("This helps us provide more accurate recommendations")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                VStack(spacing: 16) {
                    ForEach([Gender.male, Gender.female, Gender.other], id: \.self) { gender in
                        OnboardingSelectionButton(
                            title: gender.description,
                            isSelected: data.selectedGender == gender
                        ) {
                            data.selectedGender = gender
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button(action: onNext) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(data.selectedGender != nil ? Color.black : Color.gray.opacity(0.5))
                            )
                    }
                    .disabled(data.selectedGender == nil)
                    .padding(.horizontal)
                    
                    Text("Step 1 of 13")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct OnboardingWorkoutView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingProgressBar(currentStep: 2, totalSteps: 13)
                .padding(.top, 20)
            
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            VStack(spacing: 30) {
                VStack(spacing: 12) {
                    Text("How active are you?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("This helps us calculate your calorie needs")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                VStack(spacing: 16) {
                    ForEach([WorkoutFrequency.sedentary, .lightlyActive, .moderatelyActive, .veryActive, .superActive], id: \.self) { frequency in
                        OnboardingSelectionButton(
                            title: frequency.description,
                            isSelected: data.workoutFrequency == frequency
                        ) {
                            data.workoutFrequency = frequency
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button(action: onNext) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(data.workoutFrequency != nil ? Color.black : Color.gray.opacity(0.5))
                            )
                    }
                    .disabled(data.workoutFrequency == nil)
                    .padding(.horizontal)
                    
                    Text("Step 2 of 13")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct OnboardingGoalView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingProgressBar(currentStep: 3, totalSteps: 13)
                .padding(.top, 20)
            
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            VStack(spacing: 30) {
                VStack(spacing: 12) {
                    Text("What's your main goal?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("We'll customize your plan around this objective")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                VStack(spacing: 16) {
                    ForEach([GoalType.loseWeight, .maintainWeight, .gainWeight, .buildMuscle], id: \.self) { goal in
                        OnboardingSelectionButton(
                            title: goal.description,
                            isSelected: data.goalType == goal
                        ) {
                            data.goalType = goal
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button(action: onNext) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(data.goalType != nil ? Color.black : Color.gray.opacity(0.5))
                            )
                    }
                    .disabled(data.goalType == nil)
                    .padding(.horizontal)
                    
                    Text("Step 3 of 13")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct OnboardingWeightHeightView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingProgressBar(currentStep: 4, totalSteps: 13)
                .padding(.top, 20)
            
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            VStack(spacing: 30) {
                VStack(spacing: 12) {
                    Text("What's your current weight and height?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("This helps us calculate accurate calorie and macro recommendations")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                // Unit system toggle
                HStack(spacing: 0) {
                    Button("Imperial") {
                        data.isImperialSystem = true
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(data.isImperialSystem ? .black : .white.opacity(0.7))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(data.isImperialSystem ? Color.white : Color.clear)
                    
                    Button("Metric") {
                        data.isImperialSystem = false
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(!data.isImperialSystem ? .black : .white.opacity(0.7))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(!data.isImperialSystem ? Color.white : Color.clear)
                }
                .background(Color.white.opacity(0.2))
                .cornerRadius(22)
                .padding(.horizontal, 40)
                
                VStack(spacing: 20) {
                    // Weight Input
                    VStack(spacing: 8) {
                        Text("Current Weight")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 8) {
                            TextField("", value: data.isImperialSystem ? $data.weightPounds : $data.weightKilograms, format: .number)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .keyboardType(.decimalPad)
                                .frame(width: 80)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                            
                            Text(data.isImperialSystem ? "lbs" : "kg")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    
                    // Height Input
                    VStack(spacing: 8) {
                        Text("Height")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        if data.isImperialSystem {
                            HStack(spacing: 8) {
                                HStack(spacing: 4) {
                                    TextField("", value: $data.heightFeet, format: .number)
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .keyboardType(.numberPad)
                                        .frame(width: 60)
                                        .padding(.vertical, 12)
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(12)
                                    
                                    Text("ft")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                
                                HStack(spacing: 4) {
                                    TextField("", value: $data.heightInches, format: .number)
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .keyboardType(.numberPad)
                                        .frame(width: 60)
                                        .padding(.vertical, 12)
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(12)
                                    
                                    Text("in")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                        } else {
                            HStack(spacing: 8) {
                                TextField("", value: $data.heightCentimeters, format: .number)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                                    .frame(width: 80)
                                    .padding(.vertical, 12)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(12)
                                
                                Text("cm")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button(action: {
                        // Update current weight for later use
                        data.currentWeight = data.isImperialSystem ? data.weightPounds : data.weightKilograms * 2.20462
                        onNext()
                    }) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(isFormValid ? Color.black : Color.gray.opacity(0.5))
                            )
                    }
                    .disabled(!isFormValid)
                    .padding(.horizontal)
                    
                    Text("Step 4 of 13")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
    
    private var isFormValid: Bool {
        let weightValid = data.isImperialSystem ? data.weightPounds > 0 : data.weightKilograms > 0
        let heightValid = data.isImperialSystem ? (data.heightFeet > 0 && data.heightInches >= 0) : data.heightCentimeters > 0
        return weightValid && heightValid
    }
}

struct OnboardingDateOfBirthView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingProgressBar(currentStep: 5, totalSteps: 13)
                .padding(.top, 20)
            
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            VStack(spacing: 30) {
                VStack(spacing: 12) {
                    Text("When were you born?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("This helps us personalize your calorie and nutrition needs based on your age")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                VStack(spacing: 20) {
                    DatePicker("", selection: $data.dateOfBirth, displayedComponents: .date)
                        .datePickerStyle(.wheel)
                        .colorScheme(.dark)
                        .scaleEffect(1.1)
                        .padding(.horizontal)
                    
                    VStack(spacing: 8) {
                        Text("Your Age: \(calculateAge) years old")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("We use this to calculate your metabolic needs")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button(action: onNext) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(Color.black)
                            )
                    }
                    .padding(.horizontal)
                    
                    Text("Step 5 of 13")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
    
    private var calculateAge: Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: data.dateOfBirth, to: now)
        return ageComponents.year ?? 0
    }
}

struct OnboardingReferralView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingProgressBar(currentStep: 6, totalSteps: 13)
                .padding(.top, 20)
            
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            VStack(spacing: 30) {
                VStack(spacing: 12) {
                    Text("How did you hear about us?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Help us understand where our users discover FitApp")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                VStack(spacing: 16) {
                    ForEach([ReferralSource.instagram, .tiktok, .facebook, .googleAds, .appStore, .friendReferral, .other], id: \.self) { source in
                        OnboardingSelectionButton(
                            title: source.description,
                            isSelected: data.referralSource == source
                        ) {
                            data.referralSource = source
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button(action: onNext) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(data.referralSource != nil ? Color.black : Color.gray.opacity(0.5))
                            )
                    }
                    .disabled(data.referralSource == nil)
                    .padding(.horizontal)
                    
                    Text("Step 6 of 13")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct OnboardingDesiredWeightView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingProgressBar(currentStep: 7, totalSteps: 13)
                .padding(.top, 20)
            
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            VStack(spacing: 30) {
                VStack(spacing: 12) {
                    Text("What's your goal weight?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Set a realistic target that aligns with your health goals")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                VStack(spacing: 30) {
                    // Current weight display
                    VStack(spacing: 8) {
                        Text("Current Weight")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text("\(Int(data.currentWeight)) \(data.isImperialSystem ? "lbs" : "kg")")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(16)
                    
                    // Goal weight input
                    VStack(spacing: 8) {
                        Text("Goal Weight")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 8) {
                            TextField("", value: $data.targetWeight, format: .number)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .keyboardType(.decimalPad)
                                .frame(width: 100)
                                .padding(.vertical, 16)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                            
                            Text(data.isImperialSystem ? "lbs" : "kg")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    
                    // Weight difference indicator
                    if data.targetWeight > 0 {
                        VStack(spacing: 8) {
                            let difference = data.currentWeight - data.targetWeight
                            let isLosing = difference > 0
                            
                            HStack(spacing: 8) {
                                Image(systemName: isLosing ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                                    .foregroundColor(isLosing ? .green : .orange)
                                    .font(.system(size: 20))
                                
                                Text("\(isLosing ? "Lose" : "Gain") \(Int(abs(difference))) \(data.isImperialSystem ? "lbs" : "kg")")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            
                            if abs(difference) > 0 {
                                Text("That's about \(weeksToGoal) weeks at a healthy pace")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button(action: onNext) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(data.targetWeight > 0 ? Color.black : Color.gray.opacity(0.5))
                            )
                    }
                    .disabled(data.targetWeight <= 0)
                    .padding(.horizontal)
                    
                    Text("Step 7 of 13")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
    
    private var weeksToGoal: Int {
        let difference = abs(data.currentWeight - data.targetWeight)
        let weeklyRate = 1.5 // Conservative rate of 1.5 lbs per week
        return max(1, Int(ceil(difference / weeklyRate)))
    }
}

struct OnboardingWeightLossSpeedView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    @State private var selectedSpeed: WeightLossSpeed = .moderate
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingProgressBar(currentStep: 8, totalSteps: 13)
                .padding(.top, 20)
            
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            VStack(spacing: 30) {
                VStack(spacing: 12) {
                    Text("How fast do you want to reach your goal?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Choose a pace that's sustainable for your lifestyle")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                VStack(spacing: 20) {
                    ForEach([WeightLossSpeed.slow, .moderate, .fast], id: \.self) { speed in
                        SpeedSelectionCard(
                            speed: speed,
                            isSelected: selectedSpeed == speed,
                            weeklyGoal: data.weightDifference,
                            onTap: {
                                selectedSpeed = speed
                                data.weightLossSpeed = speed
                            }
                        )
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button(action: onNext) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(Color.black)
                            )
                    }
                    .padding(.horizontal)
                    
                    Text("Step 8 of 13")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            selectedSpeed = data.weightLossSpeed
        }
    }
}

struct SpeedSelectionCard: View {
    let speed: WeightLossSpeed
    let isSelected: Bool
    let weeklyGoal: Double
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Text(speed.emoji)
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("\(speed.weeklyLoss, specifier: "%.1f") lbs/week")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 20))
                        }
                    }
                    
                    Text(speed.description)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.leading)
                    
                    if weeklyGoal > 0 {
                        Text("Goal: \(Int(ceil(weeklyGoal / speed.weeklyLoss))) weeks")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                Spacer()
            }
            .padding(20)
            .background(isSelected ? Color.white.opacity(0.15) : Color.white.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.white.opacity(0.3) : Color.clear, lineWidth: 2)
            )
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct OnboardingObstaclesView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingProgressBar(currentStep: 9, totalSteps: 13)
                .padding(.top, 20)
            
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 12) {
                        Text("What challenges have you faced?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Select all that apply so we can help you overcome them")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach([Obstacle.timeConstraints, .lackOfMotivation, .unhealthyEating, .stressEating, .plateaus, .socialPressure, .lackOfKnowledge, .consistency], id: \.self) { obstacle in
                            ObstacleSelectionCard(
                                obstacle: obstacle,
                                isSelected: data.selectedObstacles.contains(obstacle),
                                onTap: {
                                    if data.selectedObstacles.contains(obstacle) {
                                        data.selectedObstacles.remove(obstacle)
                                    } else {
                                        data.selectedObstacles.insert(obstacle)
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        Button(action: onNext) {
                            Text("Continue")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 28)
                                        .fill(Color.black)
                                )
                        }
                        .padding(.horizontal)
                        
                        Text("Step 9 of 13")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct ObstacleSelectionCard: View {
    let obstacle: Obstacle
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: obstacle.icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                }
                
                Text(obstacle.description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 18))
                }
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isSelected ? Color.white.opacity(0.1) : Color.white.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.white.opacity(0.3) : Color.clear, lineWidth: 2)
            )
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct OnboardingDietTypeView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingProgressBar(currentStep: 10, totalSteps: 13)
                .padding(.top, 20)
            
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 12) {
                        Text("What's your eating style?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("This helps us recommend recipes and meal plans that match your preferences")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        ForEach([DietType.standard, .keto, .paleo, .mediterranean, .vegetarian, .vegan, .intermittentFasting, .lowCarb], id: \.self) { dietType in
                            DietTypeSelectionCard(
                                dietType: dietType,
                                isSelected: data.selectedDietType == dietType,
                                onTap: {
                                    data.selectedDietType = dietType
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        Button(action: onNext) {
                            Text("Continue")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 28)
                                        .fill(data.selectedDietType != nil ? Color.black : Color.gray.opacity(0.5))
                                )
                        }
                        .disabled(data.selectedDietType == nil)
                        .padding(.horizontal)
                        
                        Text("Step 10 of 13")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct DietTypeSelectionCard: View {
    let dietType: DietType
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(isSelected ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
                            .frame(width: 50, height: 50)
                        
                        Text(dietType.emoji)
                            .font(.system(size: 24))
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(dietType.name)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 20))
                        }
                    }
                    
                    Text(dietType.description)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            .padding(20)
            .background(isSelected ? Color.white.opacity(0.1) : Color.white.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.white.opacity(0.3) : Color.clear, lineWidth: 2)
            )
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct OnboardingPlanGenerationView: View {
    let onNext: () -> Void
    @State private var progress: Double = 0.0
    @State private var showPlan = false
    
    var body: some View {
        VStack(spacing: 0) {
            if !showPlan {
                // Progress tracking phase
                VStack(spacing: 40) {
                    Spacer()
                    
                    Text("Creating your personalized plan")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 8)
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(progress))
                            .stroke(Color.white, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 0.5), value: progress)
                        
                        Text("\(Int(progress * 100))%")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Text("Analyzing your goals and preferences...")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Text("Step 11 of 13")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.5))
                        .padding(.bottom, 40)
                }
            } else {
                // Custom plan display phase
                ScrollView {
                    VStack(spacing: 32) {
                        VStack(spacing: 16) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.green)
                            
                            Text("Your Custom Plan is Ready!")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("Based on your goals, we've created a personalized fitness and nutrition plan just for you.")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top, 40)
                        
                        // Plan Summary Cards
                        VStack(spacing: 16) {
                            PlanSummaryCard(
                                icon: "flame.fill",
                                title: "Daily Calories",
                                value: "2,100",
                                subtitle: "Optimized for your goal",
                                color: .orange
                            )
                            
                            PlanSummaryCard(
                                icon: "figure.strengthtraining.traditional",
                                title: "Weekly Workouts",
                                value: "4",
                                subtitle: "Strength + Cardio mix",
                                color: .blue
                            )
                            
                            PlanSummaryCard(
                                icon: "chart.line.uptrend.xyaxis",
                                title: "Expected Progress",
                                value: "1-2 lbs/week",
                                subtitle: "Sustainable weight loss",
                                color: .green
                            )
                        }
                        .padding(.horizontal)
                        
                        // Continue Button
                        VStack(spacing: 16) {
                            Button("Continue to Apple Health") {
                                onNext()
                            }
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.black)
                            .cornerRadius(28)
                            .padding(.horizontal)
                            
                            Text("Step 11 of 13")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                if progress < 1.0 {
                    progress += 0.03
                } else {
                    timer.invalidate()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            showPlan = true
                        }
                    }
                }
            }
        }
    }
}

struct PlanSummaryCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text(value)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(20)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
}

struct OnboardingAppleHealthView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Image(systemName: "heart.fill")
                .font(.system(size: 80))
                .foregroundColor(.red)
            
            Text("Connect to Apple Health")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Text("Step 12 of 13")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.5))
            
            Button("Connect to Apple Health", action: {
                data.connectToAppleHealth = true
                onNext()
            })
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.black)
            .cornerRadius(28)
            .padding(.horizontal)
            
            Button("Skip for now", action: {
                data.connectToAppleHealth = false
                onNext()
            })
            .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct OnboardingCompletionView: View {
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("You're all set!")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Text("Your personalized fitness journey begins now.\nTap the button below to launch the main app.")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button("Start Your Journey", action: onComplete)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.black)
                .cornerRadius(28)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

// MARK: - Supporting Views

struct OnboardingProgressBar: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<totalSteps, id: \.self) { step in
                RoundedRectangle(cornerRadius: 2)
                    .fill(step < currentStep ? Color.white : Color.white.opacity(0.3))
                    .frame(height: 3)
            }
        }
        .padding(.horizontal)
    }
}

struct OnboardingSelectionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
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

// Placeholder for WeightTrackingView
struct WeightTrackingView: View {
    var body: some View {
        Text("Weight Tracking")
            .font(.title)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))
    }
}