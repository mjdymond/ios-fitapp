import SwiftUI

// MARK: - Temporary Placeholder Views
// These are placeholder implementations for the remaining onboarding views
// Each should be moved to its own file and properly implemented

struct OnboardingWorkoutView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Workout Frequency View")
            Button("Next", action: onNext)
            Button("Back", action: onBack)
        }
    }
}

struct OnboardingGoalView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Goal Selection View")
            Button("Next", action: onNext)
            Button("Back", action: onBack)
        }
    }
}

struct OnboardingWeightHeightView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Weight & Height View")
            Button("Next", action: onNext)
            Button("Back", action: onBack)
        }
    }
}

struct OnboardingDateOfBirthView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Date of Birth View")
            Button("Next", action: onNext)
            Button("Back", action: onBack)
        }
    }
}

struct OnboardingReferralView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Referral Source View")
            Button("Next", action: onNext)
            Button("Back", action: onBack)
        }
    }
}

struct OnboardingDesiredWeightView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Desired Weight View")
            Button("Next", action: onNext)
            Button("Back", action: onBack)
        }
    }
}

struct OnboardingWeightLossSpeedView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Weight Loss Speed View")
            Button("Next", action: onNext)
            Button("Back", action: onBack)
        }
    }
}

struct OnboardingObstaclesView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Obstacles View")
            Button("Next", action: onNext)
            Button("Back", action: onBack)
        }
    }
}

struct OnboardingDietTypeView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Diet Type View")
            Button("Next", action: onNext)
            Button("Back", action: onBack)
        }
    }
}

struct OnboardingPlanGenerationView: View {
    let onNext: () -> Void
    
    var body: some View {
        VStack {
            Text("Plan Generation View")
            Button("Next", action: onNext)
        }
    }
}

struct OnboardingAppleHealthView: View {
    @ObservedObject var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack {
            Text("Apple Health View")
            Button("Next", action: onNext)
            Button("Back", action: onBack)
        }
    }
}

struct OnboardingCompletionView: View {
    let onComplete: () -> Void
    
    var body: some View {
        VStack {
            Text("Completion View")
            Button("Complete", action: onComplete)
        }
    }
}

// MARK: - Placeholder for WeightTrackingView
struct WeightTrackingView: View {
    var body: some View {
        Text("Weight Tracking")
            .font(.title)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))
    }
}
