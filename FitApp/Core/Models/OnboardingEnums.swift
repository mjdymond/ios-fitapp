import Foundation

// MARK: - Onboarding Enums

enum Gender: String, CaseIterable {
    case male = "male"
    case female = "female" 
    case other = "other"
    
    var description: String { rawValue.capitalized }
}

enum WorkoutFrequency: String, CaseIterable {
    case sedentary = "sedentary"
    case lightlyActive = "lightly_active"
    case moderatelyActive = "moderately_active" 
    case veryActive = "very_active"
    case superActive = "super_active"
    
    var description: String {
        switch self {
        case .sedentary: return "Sedentary (little/no exercise)"
        case .lightlyActive: return "Lightly Active (1-3 days/week)"
        case .moderatelyActive: return "Moderately Active (3-5 days/week)"
        case .veryActive: return "Very Active (6-7 days/week)"
        case .superActive: return "Super Active (2x/day, intense)"
        }
    }
}

enum GoalType: String, CaseIterable {
    case loseWeight = "lose_weight"
    case gainWeight = "gain_weight"
    case maintainWeight = "maintain_weight"
    case buildMuscle = "build_muscle"
    
    var description: String {
        switch self {
        case .loseWeight: return "Lose Weight"
        case .gainWeight: return "Gain Weight"
        case .maintainWeight: return "Maintain Weight"
        case .buildMuscle: return "Build Muscle"
        }
    }
}

enum ReferralSource: String, CaseIterable {
    case instagram = "instagram"
    case tiktok = "tiktok"
    case facebook = "facebook"
    case googleAds = "google_ads"
    case appStore = "app_store"
    case friendReferral = "friend_referral"
    case other = "other"
    
    var description: String {
        switch self {
        case .instagram: return "Instagram"
        case .tiktok: return "TikTok"
        case .facebook: return "Facebook"
        case .googleAds: return "Google Ads"
        case .appStore: return "App Store"
        case .friendReferral: return "Friend Referral"
        case .other: return "Other"
        }
    }
}

enum WeightLossSpeed: String, CaseIterable {
    case slow = "slow"
    case moderate = "moderate"
    case fast = "fast"
    
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
        case .fast: return 2.0
        }
    }
    
    var description: String {
        switch self {
        case .slow: return "Gradual and sustainable approach"
        case .moderate: return "Balanced pace with steady progress"
        case .fast: return "Aggressive but achievable timeline"
        }
    }
}

enum Obstacle: String, CaseIterable, Hashable {
    case timeConstraints = "time_constraints"
    case lackOfMotivation = "lack_of_motivation"
    case unhealthyEating = "unhealthy_eating"
    case stressEating = "stress_eating"
    case plateaus = "plateaus"
    case socialPressure = "social_pressure"
    case lackOfKnowledge = "lack_of_knowledge"
    case consistency = "consistency"
    
    var icon: String {
        switch self {
        case .timeConstraints: return "clock.fill"
        case .lackOfMotivation: return "battery.25"
        case .unhealthyEating: return "exclamationmark.triangle.fill"
        case .stressEating: return "heart.slash.fill"
        case .plateaus: return "chart.line.flattrend.xyaxis"
        case .socialPressure: return "person.2.fill"
        case .lackOfKnowledge: return "questionmark.circle.fill"
        case .consistency: return "repeat.circle.fill"
        }
    }
    
    var description: String {
        switch self {
        case .timeConstraints: return "Not enough time for workouts"
        case .lackOfMotivation: return "Struggling to stay motivated"
        case .unhealthyEating: return "Difficulty controlling eating habits"
        case .stressEating: return "Emotional or stress eating"
        case .plateaus: return "Hitting weight loss plateaus"
        case .socialPressure: return "Social situations and peer pressure"
        case .lackOfKnowledge: return "Don't know where to start"
        case .consistency: return "Staying consistent with routine"
        }
    }
}

enum DietType: String, CaseIterable {
    case standard = "standard"
    case keto = "keto"
    case paleo = "paleo"
    case mediterranean = "mediterranean"
    case vegetarian = "vegetarian"
    case vegan = "vegan"
    case intermittentFasting = "intermittent_fasting"
    case lowCarb = "low_carb"
    
    var name: String {
        switch self {
        case .standard: return "Standard"
        case .keto: return "Keto"
        case .paleo: return "Paleo"
        case .mediterranean: return "Mediterranean"
        case .vegetarian: return "Vegetarian"
        case .vegan: return "Vegan"
        case .intermittentFasting: return "Intermittent Fasting"
        case .lowCarb: return "Low Carb"
        }
    }
    
    var description: String {
        switch self {
        case .standard: return "Balanced approach with all food groups"
        case .keto: return "High fat, very low carb lifestyle"
        case .paleo: return "Whole foods, no processed ingredients"
        case .mediterranean: return "Heart-healthy with olive oil and fish"
        case .vegetarian: return "Plant-based with dairy and eggs"
        case .vegan: return "100% plant-based nutrition"
        case .intermittentFasting: return "Time-restricted eating windows"
        case .lowCarb: return "Reduced carbohydrate intake"
        }
    }
    
    var emoji: String {
        switch self {
        case .standard: return "🍽️"
        case .keto: return "🥓"
        case .paleo: return "🥩"
        case .mediterranean: return "🫒"
        case .vegetarian: return "🥗"
        case .vegan: return "🌱"
        case .intermittentFasting: return "⏰"
        case .lowCarb: return "🚫🍞"
        }
    }
}
