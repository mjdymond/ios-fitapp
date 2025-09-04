import Foundation

class OnboardingData: ObservableObject {
    // MARK: - Published Properties
    
    // Page 2: Gender Selection
    @Published var selectedGender: Gender?
    
    // Page 3: Workout Frequency
    @Published var workoutFrequency: WorkoutFrequency?
    
    // Page 4: Demographics
    @Published var referralSource: ReferralSource?
    @Published var hasPriorAppUsage: Bool?
    @Published var isImperialSystem = true
    @Published var heightFeet: Int = 5
    @Published var heightInches: Int = 8
    @Published var heightCentimeters: Int = 170
    @Published var weightPounds: Double = 150
    @Published var weightKilograms: Double = 68
    @Published var dateOfBirth: Date = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()
    
    // Page 5: Goal Setting
    @Published var goalType: GoalType?
    @Published var currentWeight: Double = 150
    @Published var targetWeight: Double = 140
    @Published var weightLossSpeed: WeightLossSpeed = .moderate
    
    // Page 6: Obstacles & Preferences
    @Published var selectedObstacles: Set<Obstacle> = []
    @Published var dietType: DietType?
    @Published var selectedAccomplishments: Set<Accomplishment> = []
    
    // Page 7: Plan Generation Settings
    @Published var connectToAppleHealth = false
    @Published var addCaloriesBurnedBack = false
    @Published var rolloverExtraCalories = false
    @Published var enableNotifications = false
    @Published var referralCode: String = ""
    @Published var appRating: Int = 0
    
    // MARK: - Computed Properties
    
    var currentWeightInPounds: Double {
        isImperialSystem ? weightPounds : weightKilograms * 2.20462
    }
    
    var heightInInches: Double {
        isImperialSystem ? Double(heightFeet * 12 + heightInches) : Double(heightCentimeters) / 2.54
    }
    
    var weightDifference: Double {
        currentWeight - targetWeight
    }
    
    var isWeightLoss: Bool {
        goalType == .lose
    }
    
    var targetWeightLossPerWeek: Double {
        switch weightLossSpeed {
        case .slow: return 0.5
        case .moderate: return 1.0
        case .fast: return 1.5
        }
    }
    
    // MARK: - Validation
    
    func isPageValid(_ page: OnboardingPage) -> Bool {
        switch page {
        case .welcome:
            return true
        case .genderSelection:
            return selectedGender != nil
        case .workoutFrequency:
            return workoutFrequency != nil
        case .referralSource:
            return referralSource != nil
        case .priorAppUsage:
            return hasPriorAppUsage != nil
        case .weightHeight:
            return true // Always valid since we have defaults
        case .dateOfBirth:
            return true // Always valid since we have defaults
        case .goalType:
            return goalType != nil
        case .desiredWeight:
            return targetWeight > 0
        case .weightLossSpeed:
            return true // Always valid since we have defaults
        case .obstacles:
            return !selectedObstacles.isEmpty
        case .dietType:
            return dietType != nil
        case .accomplishments:
            return !selectedAccomplishments.isEmpty
        default:
            return true
        }
    }
}

// MARK: - Enums

enum Gender: String, CaseIterable {
    case male = "Male"
    case female = "Female"
    case other = "Other"
}

enum WorkoutFrequency: String, CaseIterable {
    case low = "0-2 Workouts now and then"
    case moderate = "3-5 A few workouts per week"  
    case high = "6+ Dedicated athlete"
}

enum ReferralSource: String, CaseIterable {
    case tv = "TV"
    case youtube = "YouTube"
    case instagram = "Instagram"
    case facebook = "Facebook"
    case tiktok = "TikTok"
    case friend = "Friend or Family"
    case appStore = "App Store"
    case google = "Google Search"
    case other = "Other"
}

enum GoalType: String, CaseIterable {
    case lose = "Lose weight"
    case maintain = "Maintain"
    case gain = "Gain weight"
}

enum WeightLossSpeed: String, CaseIterable {
    case slow = "Slow & Steady"
    case moderate = "Moderate"
    case fast = "Fast Track"
    
    var emoji: String {
        switch self {
        case .slow: return "🐌"
        case .moderate: return "🐰"
        case .fast: return "🐆"
        }
    }
    
    var weeklyLoss: Double {
        switch self {
        case .slow: return 0.5
        case .moderate: return 1.0
        case .fast: return 1.5
        }
    }
}

enum Obstacle: String, CaseIterable {
    case consistency = "Lack of consistency"
    case unhealthyEating = "Unhealthy eating habits"
    case timeManagement = "Time management"
    case motivation = "Staying motivated"
    case socialPressure = "Social eating pressure"
    case emotionalEating = "Emotional eating"
    case plateaus = "Weight loss plateaus"
    case cravings = "Food cravings"
    
    var icon: String {
        switch self {
        case .consistency: return "clock"
        case .unhealthyEating: return "fork.knife"
        case .timeManagement: return "calendar"
        case .motivation: return "heart"
        case .socialPressure: return "person.2"
        case .emotionalEating: return "face.smiling"
        case .plateaus: return "chart.line.flattrend.xyaxis"
        case .cravings: return "brain"
        }
    }
}

enum DietType: String, CaseIterable {
    case classic = "Classic"
    case pescatarian = "Pescatarian"
    case vegetarian = "Vegetarian"
    case vegan = "Vegan"
}

enum Accomplishment: String, CaseIterable {
    case healthierLiving = "Eat and live healthier"
    case boostEnergy = "Boost my energy and mood"
    case improveConfidence = "Improve my confidence"
    case betterSleep = "Get better sleep"
    case buildHabits = "Build sustainable habits"
    case feelStronger = "Feel stronger and fitter"
    case reduceStress = "Reduce stress levels"
    case improveHealth = "Improve overall health markers"
    
    var icon: String {
        switch self {
        case .healthierLiving: return "leaf"
        case .boostEnergy: return "bolt"
        case .improveConfidence: return "star"
        case .betterSleep: return "bed.double"
        case .buildHabits: return "repeat"
        case .feelStronger: return "figure.strengthtraining.traditional"
        case .reduceStress: return "heart.circle"
        case .improveHealth: return "cross.case"
        }
    }
}

enum OnboardingPage: String, CaseIterable {
    case welcome
    case genderSelection
    case workoutFrequency
    case referralSource
    case priorAppUsage
    case weightHeight
    case dateOfBirth
    case goalType
    case desiredWeight
    case weightLossSpeed
    case obstacles
    case dietType
    case accomplishments
    case planGeneration
    case appleHealth
    case calorieSettings
    case rating
    case notifications
    case referralCode
    case loading
    case planSummary
    case authentication
    case trialOffer
    case discountWheel
    case payment
}