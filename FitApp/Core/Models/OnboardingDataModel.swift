import SwiftUI
import Foundation

// MARK: - Onboarding Data Model

class OnboardingData: ObservableObject {
    // Basic info
    @Published var selectedGender: Gender?
    @Published var workoutFrequency: WorkoutFrequency?
    @Published var goalType: GoalType?
    
    // Demographics
    @Published var isImperialSystem = true
    @Published var heightFeet: Int = 5
    @Published var heightInches: Int = 8
    @Published var heightCentimeters: Int = 170
    @Published var weightPounds: Double = 150
    @Published var weightKilograms: Double = 68
    @Published var dateOfBirth: Date = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()
    @Published var referralSource: ReferralSource?
    
    // Goal setting
    @Published var currentWeight: Double = 150
    @Published var targetWeight: Double = 140
    @Published var weightLossSpeed: WeightLossSpeed = .moderate
    
    // Preferences
    @Published var selectedObstacles: Set<Obstacle> = []
    @Published var selectedDietType: DietType?
    
    // Integration
    @Published var connectToAppleHealth = false
    
    var currentWeightInPounds: Double {
        isImperialSystem ? weightPounds : weightKilograms * 2.20462
    }
    
    var heightInInches: Double {
        isImperialSystem ? Double(heightFeet * 12 + heightInches) : Double(heightCentimeters) / 2.54
    }
    
    var weightDifference: Double {
        abs(currentWeight - targetWeight)
    }
    
    var weeksToGoal: Int {
        guard weightDifference > 0 else { return 0 }
        return Int(ceil(weightDifference / weightLossSpeed.weeklyLoss))
    }
    
    var isValid: Bool {
        selectedGender != nil && workoutFrequency != nil && goalType != nil
    }
}
