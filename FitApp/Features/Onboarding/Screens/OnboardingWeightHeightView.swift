import SwiftUI

struct OnboardingWeightHeightView: View {
    @EnvironmentObject private var onboardingData: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    private let currentStep = 6
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
            
            // Content
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 12) {
                    Text("Tell us about yourself")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("We'll use this to create your personalized plan")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                // Weight & Height Picker
                OnboardingWeightHeightPicker(
                    isImperialSystem: $onboardingData.isImperialSystem,
                    heightFeet: $onboardingData.heightFeet,
                    heightInches: $onboardingData.heightInches,
                    heightCentimeters: $onboardingData.heightCentimeters,
                    weightPounds: $onboardingData.weightPounds,
                    weightKilograms: $onboardingData.weightKilograms
                )
                
                Spacer()
                
                // Continue Button
                VStack(spacing: 16) {
                    OnboardingPrimaryButton("Continue") {
                        // Update current weight based on unit system
                        onboardingData.currentWeight = onboardingData.isImperialSystem 
                            ? onboardingData.weightPounds 
                            : onboardingData.weightKilograms * 2.20462
                        
                        onNext()
                    }
                    
                    // Progress text
                    Text("Step \(currentStep) of \(totalSteps)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

#Preview {
    OnboardingWeightHeightView(
        onNext: { print("Next tapped") },
        onBack: { print("Back tapped") }
    )
    .environmentObject(OnboardingData())
}