import SwiftUI
import CoreData

struct OnboardingCoordinator: View {
    @StateObject private var onboardingData = OnboardingData()
    @State private var currentPage: OnboardingPage = .welcome
    @State private var pageStack: [OnboardingPage] = []
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
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
        case .referralSource:
            OnboardingReferralSourceView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .priorAppUsage:
            OnboardingPriorAppUsageView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .weightHeight:
            OnboardingWeightHeightView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .dateOfBirth:
            OnboardingDateOfBirthView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .goalType:
            OnboardingGoalTypeView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .desiredWeight:
            OnboardingDesiredWeightView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .weightLossSpeed:
            OnboardingWeightLossSpeedView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .obstacles:
            OnboardingObstaclesView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .dietType:
            OnboardingDietTypeView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .accomplishments:
            OnboardingAccomplishmentsView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .planGeneration:
            OnboardingPlanGenerationView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .appleHealth:
            OnboardingAppleHealthView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .calorieSettings:
            OnboardingCalorieSettingsView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .rating:
            OnboardingRatingView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .notifications:
            OnboardingNotificationsView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .referralCode:
            OnboardingReferralCodeView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .loading:
            OnboardingLoadingView(
                onNext: { navigateToNext() }
            )
        case .planSummary:
            OnboardingPlanSummaryView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .authentication:
            OnboardingAuthenticationView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .trialOffer:
            OnboardingTrialOfferView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .discountWheel:
            OnboardingDiscountWheelView(
                onNext: { navigateToNext() },
                onBack: { navigateBack() }
            )
        case .payment:
            OnboardingPaymentView(
                onComplete: { completeOnboarding() },
                onBack: { navigateBack() }
            )
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
        
        // Dismiss onboarding and show main app
        dismiss()
    }
    
    // MARK: - Helper Methods
    
    private func getNextPage(from current: OnboardingPage) -> OnboardingPage? {
        switch current {
        case .welcome:
            return .genderSelection
        case .genderSelection:
            return .workoutFrequency
        case .workoutFrequency:
            return .referralSource
        case .referralSource:
            return .priorAppUsage
        case .priorAppUsage:
            return .weightHeight
        case .weightHeight:
            return .dateOfBirth
        case .dateOfBirth:
            return .goalType
        case .goalType:
            return .desiredWeight
        case .desiredWeight:
            return .weightLossSpeed
        case .weightLossSpeed:
            return .obstacles
        case .obstacles:
            return .dietType
        case .dietType:
            return .accomplishments
        case .accomplishments:
            return .planGeneration
        case .planGeneration:
            return .appleHealth
        case .appleHealth:
            return .calorieSettings
        case .calorieSettings:
            return .rating
        case .rating:
            return .notifications
        case .notifications:
            return .referralCode
        case .referralCode:
            return .loading
        case .loading:
            return .planSummary
        case .planSummary:
            return .authentication
        case .authentication:
            return .trialOffer
        case .trialOffer:
            return .discountWheel
        case .discountWheel:
            return .payment
        case .payment:
            return nil // End of flow
        }
    }
    
    private func saveOnboardingData() {
        let context = PersistenceController.shared.container.viewContext
        
        // Create User entity with onboarding data
        let user = User(context: context)
        user.id = UUID()
        user.name = "User" // Will be updated when user signs in
        user.email = "" // Will be updated when user signs in
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
            print("User created with goal: \(onboardingData.goalType?.rawValue ?? "None")")
            print("Initial weight: \(onboardingData.currentWeightInPounds) lbs")
            print("Target weight: \(onboardingData.targetWeight) lbs")
            
            // Configure HealthKit if enabled
            if onboardingData.connectToAppleHealth {
                Task {
                    let healthKitService = HealthKitService()
                    await healthKitService.requestAuthorization()
                }
            }
        } catch {
            print("❌ Error saving onboarding data: \(error)")
            // In a production app, you would handle this error gracefully
            // For now, we'll still complete onboarding to avoid blocking the user
        }
    }
}

// MARK: - Progress Indicator

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

// MARK: - Shared Button Styles

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

struct OnboardingSecondaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
    }
}