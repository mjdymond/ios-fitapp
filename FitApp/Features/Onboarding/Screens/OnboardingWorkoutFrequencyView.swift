import SwiftUI

struct OnboardingWorkoutFrequencyView: View {
    @EnvironmentObject private var onboardingData: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    private let currentStep = 2
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

#Preview {
    OnboardingWorkoutFrequencyView(
        onNext: { print("Next tapped") },
        onBack: { print("Back tapped") }
    )
    .environmentObject(OnboardingData())
}