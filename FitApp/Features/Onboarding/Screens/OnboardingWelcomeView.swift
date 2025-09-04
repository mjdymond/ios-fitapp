import SwiftUI

struct OnboardingWelcomeView: View {
    let onNext: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Banner Image Section
                    ZStack {
                        // Placeholder background image
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.orange.opacity(0.8), Color.red.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: geometry.size.height * 0.55)
                        
                        // Mock meal with calorie overlay
                        VStack {
                            Spacer()
                            
                            // Mock food item with calorie info
                            HStack {
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    // Calorie bubble
                                    HStack(spacing: 4) {
                                        Image(systemName: "flame.fill")
                                            .foregroundColor(.orange)
                                            .font(.system(size: 12))
                                        
                                        Text("420 cal")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.black)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.white)
                                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                    )
                                    
                                    // Food name
                                    Text("Grilled Salmon Bowl")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.black.opacity(0.6))
                                        )
                                }
                                .padding(.trailing, 20)
                                .padding(.bottom, 40)
                            }
                        }
                        
                        // Food illustration (using SF Symbols as placeholder)
                        VStack {
                            Spacer()
                            
                            HStack {
                                VStack(spacing: 8) {
                                    Image(systemName: "fork.knife.circle.fill")
                                        .font(.system(size: 60))
                                        .foregroundColor(.white.opacity(0.9))
                                    
                                    Image(systemName: "leaf.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.green.opacity(0.8))
                                        .offset(x: 20, y: -10)
                                }
                                .padding(.leading, 40)
                                
                                Spacer()
                            }
                            
                            Spacer()
                        }
                    }
                    
                    // Content Section
                    VStack(spacing: 40) {
                        // Title
                        Text("Calorie tracking made easy")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        // Get Started Button
                        VStack(spacing: 16) {
                            OnboardingPrimaryButton("Get Started") {
                                onNext()
                            }
                            
                            // Optional subtitle
                            Text("Transform your fitness journey")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.bottom, 40)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.height * 0.45)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    OnboardingWelcomeView {
        print("Get Started tapped")
    }
}