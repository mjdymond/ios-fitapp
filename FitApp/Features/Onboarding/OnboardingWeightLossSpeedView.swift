import SwiftUI

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
