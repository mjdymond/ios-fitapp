import SwiftUI

// MARK: - Weight Loss Speed View

struct OnboardingWeightLossSpeedView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    private let speeds: [WeightLossSpeed] = [.slow, .moderate, .fast]
    
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
                    
                    Text("Choose the pace that feels right for you")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                VStack(spacing: 24) {
                    // Speed indicators with emojis
                    HStack {
                        ForEach(speeds, id: \.self) { speed in
                            VStack(spacing: 8) {
                                Text(speed.emoji)
                                    .font(.system(size: 40))
                                
                                Text(speed.rawValue.capitalized)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(data.weightLossSpeed == speed ? .white : .gray)
                            }
                            .opacity(data.weightLossSpeed == speed ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 0.2), value: data.weightLossSpeed)
                            
                            if speed != speeds.last {
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    // Custom slider
                    OnboardingSpeedSlider(selectedSpeed: $data.weightLossSpeed, speeds: speeds)
                        .padding(.horizontal)
                    
                    // Speed description and rate
                    VStack(spacing: 8) {
                        Text("\(data.weightLossSpeed.weeklyLoss, specifier: "%.1f") lbs per week")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text(data.weightLossSpeed.description)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        if data.weightLossSpeed == .moderate {
                            Text("✨ Recommended")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.green)
                                .padding(.top, 4)
                        }
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
                    
                    Text("Step 8 of 13")
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

// MARK: - Obstacles View

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
                        
                        Text("Select all that apply - we'll help you overcome them")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                    LazyVStack(spacing: 12) {
                        ForEach([Obstacle.timeConstraints, .lackOfMotivation, .unhealthyEating, .stressEating, .plateaus, .socialPressure, .lackOfKnowledge, .consistency], id: \.self) { obstacle in
                            OnboardingMultiSelectButton(
                                title: obstacle.description,
                                icon: obstacle.icon,
                                isSelected: data.selectedObstacles.contains(obstacle)
                            ) {
                                if data.selectedObstacles.contains(obstacle) {
                                    data.selectedObstacles.remove(obstacle)
                                } else {
                                    data.selectedObstacles.insert(obstacle)
                                }
                            }
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
                                        .fill(!data.selectedObstacles.isEmpty ? Color.black : Color.gray.opacity(0.5))
                                )
                        }
                        .disabled(data.selectedObstacles.isEmpty)
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

// MARK: - Diet Type View

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
                        
                        Text("We'll customize your meal plans accordingly")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                    LazyVStack(spacing: 12) {
                        ForEach([DietType.balanced, .mediterranean, .lowCarb, .keto, .vegetarian, .vegan, .paleo, .flexitarian], id: \.self) { dietType in
                            OnboardingSelectionButton(
                                title: dietType.description,
                                isSelected: data.dietType == dietType
                            ) {
                                data.dietType = dietType
                            }
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
                                        .fill(data.dietType != nil ? Color.black : Color.gray.opacity(0.5))
                                )
                        }
                        .disabled(data.dietType == nil)
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

// MARK: - Plan Generation View

struct OnboardingPlanGenerationView: View {
    let onNext: () -> Void
    @State private var currentStep = 0
    @State private var progress: Double = 0.0
    
    private let steps = [
        "Analyzing your profile...",
        "Calculating calorie needs...",
        "Creating workout plan...",
        "Customizing meal suggestions...",
        "Finalizing your journey..."
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingProgressBar(currentStep: 11, totalSteps: 13)
                .padding(.top, 20)
            
            VStack(spacing: 40) {
                Spacer()
                
                VStack(spacing: 20) {
                    Text("Creating your personalized plan")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("This will only take a moment...")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                
                OnboardingProgressRing(progress: progress)
                
                Text(steps[currentStep])
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .animation(.easeInOut(duration: 0.3), value: currentStep)
                
                Spacer()
                
                Text("Step 11 of 13")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            startProgressAnimation()
        }
    }
    
    private func startProgressAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { timer in
            if currentStep < steps.count - 1 {
                currentStep += 1
                progress = Double(currentStep + 1) / Double(steps.count)
            } else {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    onNext()
                }
            }
        }
    }
}

// MARK: - Apple Health View

struct OnboardingAppleHealthView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingProgressBar(currentStep: 12, totalSteps: 13)
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
            
            VStack(spacing: 40) {
                Spacer()
                
                VStack(spacing: 20) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.red)
                    
                    VStack(spacing: 12) {
                        Text("Connect to Apple Health")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Sync your health data for more accurate tracking and insights")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    
                    VStack(spacing: 16) {
                        OnboardingFeatureRow(icon: "figure.walk", title: "Activity Data", description: "Steps, distance, and active calories")
                        OnboardingFeatureRow(icon: "scalemass.fill", title: "Weight Tracking", description: "Automatic weight sync and history")
                        OnboardingFeatureRow(icon: "heart.fill", title: "Heart Rate", description: "Monitor workout intensity")
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button(action: {
                        data.connectToAppleHealth = true
                        onNext()
                    }) {
                        Text("Connect to Apple Health")
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
                    
                    Button(action: {
                        data.connectToAppleHealth = false
                        onNext()
                    }) {
                        Text("Skip for now")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Text("Step 12 of 13")
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

// MARK: - Supporting Components

struct OnboardingMultiSelectButton: View {
    let title: String
    let icon: String?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? .green : .white.opacity(0.4))
                
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                        .frame(width: 24)
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.8))
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.black.opacity(0.6) : Color.gray.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.green.opacity(0.6) : Color.gray.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct OnboardingSpeedSlider: View {
    @Binding var selectedSpeed: WeightLossSpeed
    let speeds: [WeightLossSpeed]
    
    var body: some View {
        GeometryReader { geometry in
            let sliderWidth = geometry.size.width - 40
            let stepWidth = sliderWidth / CGFloat(speeds.count - 1)
            let currentIndex = speeds.firstIndex(of: selectedSpeed) ?? 1
            let thumbPosition = CGFloat(currentIndex) * stepWidth
            
            ZStack(alignment: .leading) {
                // Track
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 4)
                    .offset(x: 20)
                
                // Progress fill
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white)
                    .frame(width: thumbPosition, height: 4)
                    .offset(x: 20)
                    .animation(.easeInOut(duration: 0.2), value: thumbPosition)
                
                // Thumb
                Circle()
                    .fill(Color.white)
                    .frame(width: 24, height: 24)
                    .offset(x: 20 + thumbPosition)
                    .animation(.easeInOut(duration: 0.2), value: thumbPosition)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let position = value.location.x - 20
                        let index = Int(round(position / stepWidth))
                        let clampedIndex = max(0, min(speeds.count - 1, index))
                        selectedSpeed = speeds[clampedIndex]
                    }
            )
        }
        .frame(height: 30)
    }
}

struct OnboardingProgressRing: View {
    let progress: Double
    private let lineWidth: CGFloat = 8
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.2), lineWidth: lineWidth)
                .frame(width: 120, height: 120)
            
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(Color.white, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: 120, height: 120)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
            
            Text("\(Int(progress * 100))%")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
        }
    }
}