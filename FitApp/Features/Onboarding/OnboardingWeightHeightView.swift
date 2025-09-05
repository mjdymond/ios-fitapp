import SwiftUI

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
                    Text("What's your current weight and height?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("This helps us calculate accurate calorie and macro recommendations")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                // Unit system toggle
                HStack(spacing: 0) {
                    Button("Imperial") {
                        data.isImperialSystem = true
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(data.isImperialSystem ? .black : .white.opacity(0.7))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(data.isImperialSystem ? Color.white : Color.clear)
                    
                    Button("Metric") {
                        data.isImperialSystem = false
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(!data.isImperialSystem ? .black : .white.opacity(0.7))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(!data.isImperialSystem ? Color.white : Color.clear)
                }
                .background(Color.white.opacity(0.2))
                .cornerRadius(22)
                .padding(.horizontal, 40)
                
                VStack(spacing: 20) {
                    // Weight Input
                    VStack(spacing: 8) {
                        Text("Current Weight")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 8) {
                            TextField("", value: data.isImperialSystem ? $data.weightPounds : $data.weightKilograms, format: .number)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .keyboardType(.decimalPad)
                                .frame(width: 80)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                            
                            Text(data.isImperialSystem ? "lbs" : "kg")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    
                    // Height Input
                    VStack(spacing: 8) {
                        Text("Height")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        if data.isImperialSystem {
                            HStack(spacing: 8) {
                                HStack(spacing: 4) {
                                    TextField("", value: $data.heightFeet, format: .number)
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .keyboardType(.numberPad)
                                        .frame(width: 60)
                                        .padding(.vertical, 12)
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(12)
                                    
                                    Text("ft")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                
                                HStack(spacing: 4) {
                                    TextField("", value: $data.heightInches, format: .number)
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .keyboardType(.numberPad)
                                        .frame(width: 60)
                                        .padding(.vertical, 12)
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(12)
                                    
                                    Text("in")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                        } else {
                            HStack(spacing: 8) {
                                TextField("", value: $data.heightCentimeters, format: .number)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                                    .frame(width: 80)
                                    .padding(.vertical, 12)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(12)
                                
                                Text("cm")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button(action: {
                        // Update current weight for later use
                        data.currentWeight = data.isImperialSystem ? data.weightPounds : data.weightKilograms * 2.20462
                        onNext()
                    }) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(isFormValid ? Color.black : Color.gray.opacity(0.5))
                            )
                    }
                    .disabled(!isFormValid)
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
    
    private var isFormValid: Bool {
        let weightValid = data.isImperialSystem ? data.weightPounds > 0 : data.weightKilograms > 0
        let heightValid = data.isImperialSystem ? (data.heightFeet > 0 && data.heightInches >= 0) : data.heightCentimeters > 0
        return weightValid && heightValid
    }
}
