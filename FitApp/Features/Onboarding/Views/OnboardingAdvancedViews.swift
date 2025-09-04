import SwiftUI

// MARK: - Weight Height View

struct OnboardingWeightHeightView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingProgressBar(currentStep: 4, totalSteps: 13)
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
                
                OnboardingWeightHeightPicker(
                    isImperialSystem: $data.isImperialSystem,
                    heightFeet: $data.heightFeet,
                    heightInches: $data.heightInches,
                    heightCentimeters: $data.heightCentimeters,
                    weightPounds: $data.weightPounds,
                    weightKilograms: $data.weightKilograms
                )
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button(action: {
                        data.currentWeight = data.isImperialSystem
                            ? data.weightPounds
                            : data.weightKilograms * 2.20462
                        
                        onNext()
                    }) {
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
                    
                    Text("Step 4 of 13")
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

// MARK: - Date of Birth View

struct OnboardingDateOfBirthView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingProgressBar(currentStep: 5, totalSteps: 13)
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
                    Text("When were you born?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("This helps us create a more personalized plan for you")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                DatePicker("Date of Birth", selection: $data.dateOfBirth, displayedComponents: [.date])
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
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
                    
                    Text("Step 5 of 13")
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

// MARK: - Referral View

struct OnboardingReferralView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingProgressBar(currentStep: 6, totalSteps: 13)
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
                    Text("How did you hear about us?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Help us understand how you found our app")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                LazyVStack(spacing: 12) {
                    ForEach([ReferralSource.instagram, .tiktok, .facebook, .googleAds, .appStore, .friendReferral, .other], id: \.self) { source in
                        OnboardingSelectionButton(
                            title: source.description,
                            isSelected: data.referralSource == source
                        ) {
                            data.referralSource = source
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
                                    .fill(data.referralSource != nil ? Color.black : Color.gray.opacity(0.5))
                            )
                    }
                    .disabled(data.referralSource == nil)
                    .padding(.horizontal)
                    
                    Text("Step 6 of 13")
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

// MARK: - Desired Weight View

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
                    
                    Text("This will help us calculate your personalized plan")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                VStack(spacing: 16) {
                    Text("Current Weight: \(data.currentWeight, specifier: "%.1f") lbs")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                    
                    VStack(spacing: 8) {
                        Text("Goal Weight")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        Picker("Target Weight", selection: $data.targetWeight) {
                            ForEach(Array(stride(from: 90.0, through: 300.0, by: 0.5)), id: \.self) { weight in
                                Text("\(weight, specifier: "%.1f") lbs").tag(weight)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 150)
                    }
                    
                    let weightDifference = abs(data.currentWeight - data.targetWeight)
                    let isLosingWeight = data.targetWeight < data.currentWeight
                    
                    VStack(spacing: 8) {
                        Text("\(isLosingWeight ? "You'll lose" : "You'll gain") \(weightDifference, specifier: "%.1f") lbs")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(isLosingWeight ? .green : .blue)
                        
                        if weightDifference > 50 {
                            Text("That's a significant change! We'll create a gradual plan for you.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.orange)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        } else if weightDifference < 5 {
                            Text("Great! This is a manageable goal.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.green)
                                .multilineTextAlignment(.center)
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
                                    .fill(Color.black)
                            )
                    }
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
}

// MARK: - Weight Height Picker Component

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