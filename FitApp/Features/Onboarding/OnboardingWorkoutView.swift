import SwiftUI

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
