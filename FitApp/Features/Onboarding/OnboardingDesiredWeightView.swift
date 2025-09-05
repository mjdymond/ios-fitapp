import SwiftUI

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
