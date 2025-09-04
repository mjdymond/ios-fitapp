import SwiftUI

// MARK: - Page 4: Demographics Screens

struct OnboardingReferralSourceView: View {
    @EnvironmentObject private var onboardingData: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    private let currentStep = 4
    private let totalSteps = 24
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress Indicator
            VStack(spacing: 20) {
                OnboardingProgressIndicator(currentStep: currentStep, totalSteps: totalSteps)
                
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
                    Text("How did you hear about us?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Help us improve our reach")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                // Referral Source List
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(ReferralSource.allCases, id: \.self) { source in
                            OnboardingMultiSelectItem(
                                item: source,
                                title: source.rawValue,
                                icon: iconForReferralSource(source),
                                isSelected: onboardingData.referralSource == source
                            ) { selectedSource in
                                onboardingData.referralSource = selectedSource
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .frame(maxHeight: 400)
            }
            
            Spacer()
            
            // Continue Button
            VStack(spacing: 16) {
                OnboardingPrimaryButton(
                    "Continue",
                    isEnabled: onboardingData.referralSource != nil
                ) {
                    onNext()
                }
                
                // Progress text
                Text("Step \(currentStep) of \(totalSteps)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .navigationBarHidden(true)
    }
    
    private func iconForReferralSource(_ source: ReferralSource) -> String {
        switch source {
        case .tv:
            return "tv"
        case .youtube:
            return "play.rectangle"
        case .instagram:
            return "camera"
        case .facebook:
            return "person.2"
        case .tiktok:
            return "music.note"
        case .friend:
            return "person.2.fill"
        case .appStore:
            return "app.badge"
        case .google:
            return "magnifyingglass"
        case .other:
            return "ellipsis"
        }
    }
}

struct OnboardingPriorAppUsageView: View {
    @EnvironmentObject private var onboardingData: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    private let currentStep = 5
    private let totalSteps = 24
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress Indicator
            VStack(spacing: 20) {
                OnboardingProgressIndicator(currentStep: currentStep, totalSteps: totalSteps)
                
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
                    Text("Have you used a calorie counting app before?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    Text("This helps us customize your experience")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                // Yes/No Buttons
                HStack(spacing: 20) {
                    OnboardingYesNoButton(
                        isYes: false,
                        isSelected: onboardingData.hasPriorAppUsage == false
                    ) {
                        onboardingData.hasPriorAppUsage = false
                    }
                    
                    OnboardingYesNoButton(
                        isYes: true,
                        isSelected: onboardingData.hasPriorAppUsage == true
                    ) {
                        onboardingData.hasPriorAppUsage = true
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
            
            // Continue Button
            VStack(spacing: 16) {
                OnboardingPrimaryButton(
                    "Continue",
                    isEnabled: onboardingData.hasPriorAppUsage != nil
                ) {
                    onNext()
                }
                
                // Progress text
                Text("Step \(currentStep) of \(totalSteps)")
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

struct OnboardingDateOfBirthView: View {
    @EnvironmentObject private var onboardingData: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    private let currentStep = 7
    private let totalSteps = 24
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress Indicator
            VStack(spacing: 20) {
                OnboardingProgressIndicator(currentStep: currentStep, totalSteps: totalSteps)
                
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
                    Text("When were you born?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("This helps us calculate your daily needs")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                // Date Picker
                VStack(spacing: 20) {
                    DatePicker(
                        "Date of Birth",
                        selection: $onboardingData.dateOfBirth,
                        in: Date.distantPast...Calendar.current.date(byAdding: .year, value: -13, to: Date()) ?? Date(),
                        displayedComponents: .date
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .colorScheme(.dark)
                    .frame(maxHeight: 200)
                    .padding(.horizontal, 20)
                    
                    // Age display
                    VStack(spacing: 8) {
                        Text("Age: \(calculateAge(from: onboardingData.dateOfBirth))")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Must be 13 or older to use this app")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
            }
            
            Spacer()
            
            // Continue Button
            VStack(spacing: 16) {
                OnboardingPrimaryButton(
                    "Continue",
                    isEnabled: calculateAge(from: onboardingData.dateOfBirth) >= 13
                ) {
                    onNext()
                }
                
                // Progress text
                Text("Step \(currentStep) of \(totalSteps)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .navigationBarHidden(true)
    }
    
    private func calculateAge(from date: Date) -> Int {
        Calendar.current.dateComponents([.year], from: date, to: Date()).year ?? 0
    }
}

// MARK: - Page 5: Goal Setting Screens

struct OnboardingGoalTypeView: View {
    @EnvironmentObject private var onboardingData: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    private let currentStep = 8
    private let totalSteps = 24
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress Indicator
            VStack(spacing: 20) {
                OnboardingProgressIndicator(currentStep: currentStep, totalSteps: totalSteps)
                
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
                
                // Progress text
                Text("Step \(currentStep) of \(totalSteps)")
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

struct OnboardingDesiredWeightView: View {
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Desired Weight Screen")
                .foregroundColor(.white)
            OnboardingPrimaryButton("Continue", action: onNext)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct OnboardingWeightLossSpeedView: View {
    @EnvironmentObject private var onboardingData: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    private let currentStep = 10
    private let totalSteps = 24
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress Indicator
            VStack(spacing: 20) {
                OnboardingProgressIndicator(currentStep: currentStep, totalSteps: totalSteps)
                
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
                // Header based on goal type
                VStack(spacing: 12) {
                    Text(headerText)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    if onboardingData.goalType == .lose {
                        Text("Losing \(Int(abs(onboardingData.weightDifference))) lbs is a realistic target. It's not hard at all!")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                }
                
                // Weight Loss Speed Slider
                OnboardingWeightLossSpeedSlider(selectedSpeed: $onboardingData.weightLossSpeed)
                
                // Encouraging message
                if onboardingData.goalType == .lose {
                    VStack(spacing: 8) {
                        Text("Recommended for sustainable results")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.green)
                            .opacity(onboardingData.weightLossSpeed == .moderate ? 1 : 0)
                        
                        Text("You'll reach your goal in approximately \(weeksToGoal) weeks")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
            }
            
            Spacer()
            
            // Continue Button
            VStack(spacing: 16) {
                OnboardingPrimaryButton("Continue") {
                    onNext()
                }
                
                // Progress text
                Text("Step \(currentStep) of \(totalSteps)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .navigationBarHidden(true)
    }
    
    private var headerText: String {
        switch onboardingData.goalType {
        case .lose:
            return "How fast do you want to lose weight?"
        case .gain:
            return "How fast do you want to gain weight?"
        case .maintain:
            return "Your maintenance approach"
        case .none:
            return "Select your pace"
        }
    }
    
    private var weeksToGoal: Int {
        guard onboardingData.weightDifference > 0 else { return 0 }
        return Int(ceil(onboardingData.weightDifference / onboardingData.weightLossSpeed.weeklyLoss))
    }
}

// MARK: - Page 6: Obstacles & Preferences Screens

struct OnboardingObstaclesView: View {
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Obstacles Screen")
                .foregroundColor(.white)
            OnboardingPrimaryButton("Continue", action: onNext)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct OnboardingDietTypeView: View {
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Diet Type Screen")
                .foregroundColor(.white)
            OnboardingPrimaryButton("Continue", action: onNext)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct OnboardingAccomplishmentsView: View {
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Accomplishments Screen")
                .foregroundColor(.white)
            OnboardingPrimaryButton("Continue", action: onNext)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

// MARK: - Page 7: Plan Generation Screens

struct OnboardingPlanGenerationView: View {
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Plan Generation Screen")
                .foregroundColor(.white)
            OnboardingLoadingDots()
            OnboardingPrimaryButton("Continue", action: onNext)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct OnboardingAppleHealthView: View {
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Apple Health Connection Screen")
                .foregroundColor(.white)
            OnboardingPrimaryButton("Continue", action: onNext)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct OnboardingCalorieSettingsView: View {
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Calorie Settings Screen")
                .foregroundColor(.white)
            OnboardingPrimaryButton("Continue", action: onNext)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct OnboardingRatingView: View {
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Rating Screen")
                .foregroundColor(.white)
            OnboardingPrimaryButton("Continue", action: onNext)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct OnboardingNotificationsView: View {
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Notifications Screen")
                .foregroundColor(.white)
            OnboardingPrimaryButton("Continue", action: onNext)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct OnboardingReferralCodeView: View {
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Referral Code Screen")
                .foregroundColor(.white)
            OnboardingPrimaryButton("Continue", action: onNext)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct OnboardingLoadingView: View {
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Generating Your Plan")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            OnboardingProgressRing(progress: 0.7)
            
            Text("Almost done...")
                .foregroundColor(.white.opacity(0.7))
                
            OnboardingLoadingDots()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                onNext()
            }
        }
    }
}

// MARK: - Page 8: Final Plan & Subscription Screens

struct OnboardingPlanSummaryView: View {
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Plan Summary Screen")
                .foregroundColor(.white)
            OnboardingPrimaryButton("Continue", action: onNext)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct OnboardingAuthenticationView: View {
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Authentication Screen")
                .foregroundColor(.white)
            OnboardingPrimaryButton("Continue", action: onNext)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct OnboardingTrialOfferView: View {
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Trial Offer Screen")
                .foregroundColor(.white)
            OnboardingPrimaryButton("Continue", action: onNext)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct OnboardingDiscountWheelView: View {
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Discount Wheel Screen")
                .foregroundColor(.white)
            OnboardingPrimaryButton("Continue", action: onNext)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct OnboardingPaymentView: View {
    let onComplete: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Payment Screen")
                .foregroundColor(.white)
            OnboardingPrimaryButton("Complete Onboarding", action: onComplete)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}