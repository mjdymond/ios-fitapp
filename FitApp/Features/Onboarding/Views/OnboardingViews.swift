import SwiftUI

// MARK: - Welcome View

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

// MARK: - Gender Selection View

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

// MARK: - Workout Frequency View

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

// MARK: - Goal Selection View

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

// MARK: - Completion View

struct OnboardingCompletionView: View {
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 30) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                
                VStack(spacing: 12) {
                    Text("You're all set!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Your personalized fitness journey begins now")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal)
                
                VStack(spacing: 16) {
                    OnboardingFeatureRow(icon: "dumbbell.fill", title: "Track Workouts", description: "Log exercises and monitor progress")
                    OnboardingFeatureRow(icon: "scalemass.fill", title: "Monitor Weight", description: "Keep track of your weight journey")
                    OnboardingFeatureRow(icon: "fork.knife", title: "Plan Meals", description: "Track nutrition and plan meals")
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            Button(action: onComplete) {
                Text("Start Your Journey")
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

// MARK: - Supporting Components

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

struct OnboardingFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 40)
            
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
        .padding(.horizontal, 20)
    }
}