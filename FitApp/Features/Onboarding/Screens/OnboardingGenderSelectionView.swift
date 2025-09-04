import SwiftUI

struct OnboardingGenderSelectionView: View {
    @EnvironmentObject private var onboardingData: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    private let currentStep = 1
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
    OnboardingGenderSelectionView(
        onNext: { print("Next tapped") },
        onBack: { print("Back tapped") }
    )
    .environmentObject(OnboardingData())
}