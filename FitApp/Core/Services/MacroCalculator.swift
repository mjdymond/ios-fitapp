import Foundation

struct MacroCalculator {
    
    /// Calculate daily nutrition needs based on user profile
    static func calculateDailyNeeds(for user: User) -> DailyRecommendations {
        let bmr = calculateBMR(for: user)
        let tdee = calculateTDEE(bmr: bmr, activityLevel: user.activityLevel)
        let adjustedCalories = adjustCaloriesForGoal(tdee: tdee, goalType: "lose_weight", targetWeight: user.targetWeight, currentWeight: user.currentWeight)
        
        let macros = calculateMacroDistribution(calories: adjustedCalories, goalType: "lose_weight")
        
        return DailyRecommendations(
            calories: adjustedCalories,
            protein: macros.protein,
            carbs: macros.carbs,
            fat: macros.fat
        )
    }
    
    /// Calculate Basal Metabolic Rate using Harris-Benedict equation
    private static func calculateBMR(for user: User) -> Double {
        let weight = user.currentWeight // in pounds
        let height = user.height // in inches
        let age = calculateAge(from: user.dateOfBirth ?? Date())
        
        // Convert to metric for calculation
        let weightKg = weight * 0.453592
        let heightCm = height * 2.54
        
        let gender = "male" // Default gender for BMR calculation
        
        // Harris-Benedict equation (revised)
        if gender == "male" {
            return (88.362 + (13.397 * weightKg) + (4.799 * heightCm) - (5.677 * Double(age)))
        } else {
            return (447.593 + (9.247 * weightKg) + (3.098 * heightCm) - (4.330 * Double(age)))
        }
    }
    
    /// Calculate Total Daily Energy Expenditure
    private static func calculateTDEE(bmr: Double, activityLevel: String?) -> Double {
        let multiplier: Double
        
        switch activityLevel {
        case "sedentary":
            multiplier = 1.2
        case "lightly_active":
            multiplier = 1.375
        case "moderately_active":
            multiplier = 1.55
        case "very_active":
            multiplier = 1.725
        case "super_active":
            multiplier = 1.9
        default:
            multiplier = 1.375 // Default to lightly active
        }
        
        return bmr * multiplier
    }
    
    /// Adjust calories based on weight goal
    private static func adjustCaloriesForGoal(tdee: Double, goalType: String?, targetWeight: Double, currentWeight: Double) -> Double {
        let goalType = goalType ?? "maintain_weight"
        
        switch goalType {
        case "lose_weight":
            // Create deficit of 500-750 calories for 1-1.5 lbs/week loss
            let weightToLose = currentWeight - targetWeight
            let weeksToGoal = max(8, Int(weightToLose / 1.5)) // Minimum 8 weeks, max 1.5 lbs/week
            
            if weightToLose > 20 {
                return tdee - 750 // More aggressive for larger goals
            } else if weightToLose > 10 {
                return tdee - 500 // Moderate deficit
            } else {
                return tdee - 300 // Gentle deficit for small goals
            }
            
        case "gain_weight":
            // Create surplus of 300-500 calories for 0.5-1 lb/week gain
            let weightToGain = targetWeight - currentWeight
            
            if weightToGain > 20 {
                return tdee + 500
            } else {
                return tdee + 300
            }
            
        case "build_muscle":
            // Slight surplus for muscle building
            return tdee + 200
            
        default: // maintain_weight
            return tdee
        }
    }
    
    /// Calculate macro distribution based on goal
    private static func calculateMacroDistribution(calories: Double, goalType: String?) -> (protein: Double, carbs: Double, fat: Double) {
        let goalType = goalType ?? "maintain_weight"
        
        let (proteinPercent, carbPercent, fatPercent): (Double, Double, Double)
        
        switch goalType {
        case "lose_weight":
            // Higher protein for muscle preservation during weight loss
            (proteinPercent, carbPercent, fatPercent) = (0.30, 0.40, 0.30)
            
        case "gain_weight":
            // Balanced approach for healthy weight gain
            (proteinPercent, carbPercent, fatPercent) = (0.25, 0.50, 0.25)
            
        case "build_muscle":
            // High protein for muscle building
            (proteinPercent, carbPercent, fatPercent) = (0.35, 0.40, 0.25)
            
        default: // maintain_weight
            // Balanced macro distribution
            (proteinPercent, carbPercent, fatPercent) = (0.25, 0.45, 0.30)
        }
        
        let proteinCalories = calories * proteinPercent
        let carbCalories = calories * carbPercent
        let fatCalories = calories * fatPercent
        
        // Convert calories to grams (protein: 4 cal/g, carbs: 4 cal/g, fat: 9 cal/g)
        let proteinGrams = proteinCalories / 4
        let carbGrams = carbCalories / 4
        let fatGrams = fatCalories / 9
        
        return (protein: proteinGrams, carbs: carbGrams, fat: fatGrams)
    }
    
    /// Calculate age from date of birth
    private static func calculateAge(from dateOfBirth: Date) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: Date())
        return ageComponents.year ?? 25 // Default to 25 if calculation fails
    }
    
    /// Calculate recommended water intake in ounces
    static func calculateWaterIntake(for user: User) -> Double {
        // Basic formula: weight in pounds / 2 = ounces of water
        let baseWater = user.currentWeight / 2
        
        // Add extra for activity level
        let activityBonus: Double
        switch user.activityLevel {
        case "very_active", "super_active":
            activityBonus = 16 // Extra 16 oz for high activity
        case "moderately_active":
            activityBonus = 8 // Extra 8 oz for moderate activity
        default:
            activityBonus = 0
        }
        
        return baseWater + activityBonus
    }
    
    /// Calculate ideal weight range based on height
    static func calculateIdealWeightRange(heightInches: Double) -> (min: Double, max: Double) {
        // Using BMI 18.5-24.9 as healthy range
        let heightMeters = heightInches * 0.0254
        let heightSquared = heightMeters * heightMeters
        
        let minWeightKg = 18.5 * heightSquared
        let maxWeightKg = 24.9 * heightSquared
        
        // Convert back to pounds
        let minWeightLbs = minWeightKg * 2.20462
        let maxWeightLbs = maxWeightKg * 2.20462
        
        return (min: minWeightLbs, max: maxWeightLbs)
    }
    
    /// Calculate estimated time to reach goal
    static func calculateTimeToGoal(currentWeight: Double, targetWeight: Double, goalType: String?) -> Int {
        let weightDifference = abs(currentWeight - targetWeight)
        
        guard weightDifference > 1 else { return 1 } // Already at goal
        
        let goalType = goalType ?? "maintain_weight"
        
        let weeklyRate: Double
        switch goalType {
        case "lose_weight":
            weeklyRate = 1.5 // 1.5 lbs per week
        case "gain_weight":
            weeklyRate = 0.75 // 0.75 lbs per week (slower gain is healthier)
        case "build_muscle":
            weeklyRate = 0.5 // Very slow weight change for muscle building
        default:
            return 0 // No time needed for maintenance
        }
        
        let weeksNeeded = weightDifference / weeklyRate
        return max(1, Int(ceil(weeksNeeded)))
    }
    
    /// Validate if goal is realistic and safe
    static func validateGoal(currentWeight: Double, targetWeight: Double, heightInches: Double) -> GoalValidation {
        let idealRange = calculateIdealWeightRange(heightInches: heightInches)
        let weightChange = abs(currentWeight - targetWeight)
        
        // Check if target is within healthy range
        let isHealthyTarget = targetWeight >= idealRange.min && targetWeight <= idealRange.max
        
        // Check if change is too dramatic (more than 30% of body weight)
        let maxSafeChange = currentWeight * 0.3
        let isSafeChange = weightChange <= maxSafeChange
        
        // Check for very small changes (less than 5 lbs might not be meaningful)
        let isSignificantChange = weightChange >= 5
        
        var warnings: [String] = []
        var recommendations: [String] = []
        
        if !isHealthyTarget {
            if targetWeight < idealRange.min {
                warnings.append("Target weight may be too low for your height")
                recommendations.append("Consider targeting \(Int(idealRange.min))-\(Int(idealRange.max)) lbs")
            } else {
                warnings.append("Target weight may be too high for optimal health")
                recommendations.append("Consider targeting \(Int(idealRange.min))-\(Int(idealRange.max)) lbs")
            }
        }
        
        if !isSafeChange {
            warnings.append("Goal requires significant weight change")
            recommendations.append("Consider breaking this into smaller, more manageable goals")
        }
        
        if !isSignificantChange {
            warnings.append("Goal requires very small weight change")
            recommendations.append("Focus on body composition or fitness goals instead")
        }
        
        let isValid = isHealthyTarget && isSafeChange && isSignificantChange
        
        return GoalValidation(
            isValid: isValid,
            isHealthyTarget: isHealthyTarget,
            isSafeChange: isSafeChange,
            isSignificantChange: isSignificantChange,
            warnings: warnings,
            recommendations: recommendations,
            idealWeightRange: idealRange
        )
    }
}

// MARK: - Supporting Types

struct GoalValidation {
    let isValid: Bool
    let isHealthyTarget: Bool
    let isSafeChange: Bool
    let isSignificantChange: Bool
    let warnings: [String]
    let recommendations: [String]
    let idealWeightRange: (min: Double, max: Double)
}

// Extension to provide default values for User properties that might be nil
extension User {
    var safeActivityLevel: String {
        activityLevel ?? "lightly_active"
    }
    
    var safeDateOfBirth: Date {
        dateOfBirth ?? Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()
    }
}