import Foundation

// MARK: - Meal Data Models

struct MealData {
    let name: String
    let imageName: String?
    let nutrition: NutritionInfo
    
    static let sampleMeals = [
        MealData(
            name: "Turkey Sandwich With Potato Chips",
            imageName: "fork.knife",
            nutrition: NutritionInfo(calories: 460, protein: 28, carbs: 45, fat: 18)
        ),
        MealData(
            name: "Greek Yogurt with Berries",
            imageName: "cup.and.saucer.fill",
            nutrition: NutritionInfo(calories: 150, protein: 15, carbs: 20, fat: 3)
        ),
        MealData(
            name: "Grilled Chicken Salad",
            imageName: "leaf.fill",
            nutrition: NutritionInfo(calories: 320, protein: 35, carbs: 12, fat: 15)
        )
    ]
}

struct NutritionInfo {
    let calories: Double
    let protein: Double
    let carbs: Double
    let fat: Double
}
