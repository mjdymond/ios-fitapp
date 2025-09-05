import SwiftUI

// MARK: - Shared Onboarding Components

struct OnboardingProgressBar: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<totalSteps, id: \.self) { step in
                RoundedRectangle(cornerRadius: 2)
                    .fill(step < currentStep ? Color.white : Color.white.opacity(0.3))
                    .frame(height: 3)
            }
        }
        .padding(.horizontal)
    }
}

struct OnboardingSelectionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
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
