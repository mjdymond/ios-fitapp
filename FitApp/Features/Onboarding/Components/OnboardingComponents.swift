import SwiftUI

// MARK: - Selection Button Component

struct OnboardingSelectionButton<T: Hashable>: View {
    let item: T
    let title: String
    let isSelected: Bool
    let action: (T) -> Void
    
    var body: some View {
        Button(action: { action(item) }) {
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

// MARK: - Multi-Selection List Item

struct OnboardingMultiSelectItem<T: Hashable>: View {
    let item: T
    let title: String
    let icon: String?
    let isSelected: Bool
    let action: (T) -> Void
    
    init(item: T, title: String, icon: String? = nil, isSelected: Bool, action: @escaping (T) -> Void) {
        self.item = item
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button(action: { action(item) }) {
            HStack(spacing: 16) {
                // Selection indicator (bullet point)
                Image(systemName: isSelected ? "circle.fill" : "circle")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .white : .gray)
                
                // Icon (if provided)
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(isSelected ? .white : .gray)
                        .frame(width: 24)
                }
                
                // Title
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? .white : .gray)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.black : Color.gray.opacity(0.1))
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Yes/No Button with Icons

struct OnboardingYesNoButton: View {
    let isYes: Bool
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: isYes ? "hand.thumbsup.fill" : "hand.thumbsdown.fill")
                    .font(.system(size: 32))
                    .foregroundColor(isSelected ? .white : .gray)
                
                Text(isYes ? "Yes" : "No")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .gray)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.black : Color.gray.opacity(0.2))
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Weight/Height Picker

struct OnboardingWeightHeightPicker: View {
    @Binding var isImperialSystem: Bool
    @Binding var heightFeet: Int
    @Binding var heightInches: Int
    @Binding var heightCentimeters: Int
    @Binding var weightPounds: Double
    @Binding var weightKilograms: Double
    
    var body: some View {
        VStack(spacing: 24) {
            // Imperial/Metric Toggle
            HStack {
                Text("Units")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Picker("System", selection: $isImperialSystem) {
                    Text("Imperial").tag(true)
                    Text("Metric").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 140)
            }
            
            // Height Picker
            VStack(alignment: .leading, spacing: 8) {
                Text("Height")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                if isImperialSystem {
                    HStack {
                        Picker("Feet", selection: $heightFeet) {
                            ForEach(4..<8) { feet in
                                Text("\(feet) ft").tag(feet)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(maxWidth: .infinity)
                        
                        Picker("Inches", selection: $heightInches) {
                            ForEach(0..<12) { inches in
                                Text("\(inches) in").tag(inches)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(maxWidth: .infinity)
                    }
                    .frame(height: 120)
                } else {
                    Picker("Height", selection: $heightCentimeters) {
                        ForEach(140..<220) { cm in
                            Text("\(cm) cm").tag(cm)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 120)
                }
            }
            
            // Weight Picker
            VStack(alignment: .leading, spacing: 8) {
                Text("Weight")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                if isImperialSystem {
                    Picker("Weight", selection: $weightPounds) {
                        ForEach(Array(stride(from: 80.0, through: 400.0, by: 0.5)), id: \.self) { weight in
                            Text("\(weight, specifier: "%.1f") lbs").tag(weight)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 120)
                } else {
                    Picker("Weight", selection: $weightKilograms) {
                        ForEach(Array(stride(from: 35.0, through: 200.0, by: 0.5)), id: \.self) { weight in
                            Text("\(weight, specifier: "%.1f") kg").tag(weight)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 120)
                }
            }
        }
        .padding()
    }
}

// MARK: - Weight Loss Speed Slider

struct OnboardingWeightLossSpeedSlider: View {
    @Binding var selectedSpeed: WeightLossSpeed
    
    private let speeds: [WeightLossSpeed] = [.slow, .moderate, .fast]
    
    var body: some View {
        VStack(spacing: 24) {
            Text("How fast do you want to reach your goal?")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 20) {
                // Speed indicators
                HStack {
                    ForEach(speeds, id: \.self) { speed in
                        VStack(spacing: 8) {
                            Text(speed.emoji)
                                .font(.system(size: 32))
                            
                            Text(speed.rawValue)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(selectedSpeed == speed ? .white : .gray)
                        }
                        .opacity(selectedSpeed == speed ? 1.0 : 0.5)
                        
                        if speed != speeds.last {
                            Spacer()
                        }
                    }
                }
                
                // Custom slider
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
                        
                        // Thumb
                        Circle()
                            .fill(Color.white)
                            .frame(width: 24, height: 24)
                            .offset(x: 20 + thumbPosition)
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
                
                // Weight loss rate display
                Text("\(selectedSpeed.weeklyLoss, specifier: "%.1f") lbs per week")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            
            if selectedSpeed == .moderate {
                Text("Recommended")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.green)
            }
        }
        .padding()
    }
}

// MARK: - Progress Ring

struct OnboardingProgressRing: View {
    let progress: Double
    let lineWidth: CGFloat = 8
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.white.opacity(0.2), lineWidth: lineWidth)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(Color.white, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
            
            // Progress text
            Text("\(Int(progress * 100))%")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(width: 80, height: 80)
    }
}

// MARK: - Loading Dots

struct OnboardingLoadingDots: View {
    @State private var animating = false
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.white)
                    .frame(width: 8, height: 8)
                    .scaleEffect(animating ? 1.0 : 0.5)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: animating
                    )
            }
        }
        .onAppear {
            animating = true
        }
    }
}