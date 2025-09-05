import SwiftUI

struct OnboardingWelcomeView: View {
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(
                            colors: [Color.orange.opacity(0.8), Color.red.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(height: 200)
                    
                    VStack(spacing: 12) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                        
                        Text("FitApp")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
            }
            
            VStack(spacing: 24) {
                Text("Welcome to your\nfitness journey!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Get a personalized plan based on your goals, preferences, and lifestyle")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
            
            Button(action: onNext) {
                Text("Get Started")
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
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}
