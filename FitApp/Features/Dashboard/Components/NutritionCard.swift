import SwiftUI

struct NutritionCard: View {
    let meal: MealData
    @State private var servingCount: Int = 1
    
    var adjustedNutrition: NutritionInfo {
        NutritionInfo(
            calories: meal.nutrition.calories * Double(servingCount),
            protein: meal.nutrition.protein * Double(servingCount),
            carbs: meal.nutrition.carbs * Double(servingCount),
            fat: meal.nutrition.fat * Double(servingCount)
        )
    }
    
    var healthScore: Int {
        // Simple health score calculation based on macro balance
        let proteinPercent = (adjustedNutrition.protein * 4) / adjustedNutrition.calories
        let carbPercent = (adjustedNutrition.carbs * 4) / adjustedNutrition.calories
        let fatPercent = (adjustedNutrition.fat * 9) / adjustedNutrition.calories
        
        // Ideal macro balance: 25-30% protein, 45-65% carbs, 20-35% fat
        var score = 10
        
        if proteinPercent < 0.25 || proteinPercent > 0.35 { score -= 2 }
        if carbPercent < 0.40 || carbPercent > 0.70 { score -= 2 }
        if fatPercent < 0.15 || fatPercent > 0.40 { score -= 2 }
        
        return max(1, score)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Meal Image
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(
                        colors: [Color.orange.opacity(0.3), Color.red.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 200)
                
                if let imageName = meal.imageName {
                    Image(systemName: imageName)
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.8))
                } else {
                    VStack {
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.6))
                        Text("Add Photo")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
            }
            .overlay(alignment: .topTrailing) {
                Button(action: {}) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
                .padding()
            }
            
            // Meal Info Card
            VStack(spacing: 20) {
                // Title and Serving Counter
                VStack(spacing: 16) {
                    Text(meal.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    // Serving Counter
                    HStack(spacing: 16) {
                        Button(action: {
                            if servingCount > 1 { servingCount -= 1 }
                        }) {
                            Image(systemName: "minus")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color.gray.opacity(0.3))
                                .clipShape(Circle())
                        }
                        .disabled(servingCount <= 1)
                        
                        VStack(spacing: 2) {
                            Text("\(servingCount)")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("serving\(servingCount > 1 ? "s" : "")")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(minWidth: 60)
                        
                        Button(action: {
                            if servingCount < 10 { servingCount += 1 }
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                        .disabled(servingCount >= 10)
                    }
                }
                
                // Nutrition Breakdown
                HStack(spacing: 20) {
                    NutrientDisplay(
                        value: Int(adjustedNutrition.calories),
                        unit: "Cal",
                        icon: "flame.fill",
                        color: .orange
                    )
                    
                    NutrientDisplay(
                        value: Int(adjustedNutrition.protein),
                        unit: "g",
                        label: "Protein",
                        icon: "leaf.fill",
                        color: .red
                    )
                    
                    NutrientDisplay(
                        value: Int(adjustedNutrition.carbs),
                        unit: "g", 
                        label: "Carbs",
                        icon: "square.fill",
                        color: .yellow
                    )
                    
                    NutrientDisplay(
                        value: Int(adjustedNutrition.fat),
                        unit: "g",
                        label: "Fat",
                        icon: "drop.fill",
                        color: .purple
                    )
                }
                
                // Health Score
                VStack(spacing: 8) {
                    HStack {
                        Text("Health Score")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text("\(healthScore)/10")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(healthScore >= 7 ? .green : healthScore >= 4 ? .orange : .red)
                    }
                    
                    ProgressView(value: Double(healthScore), total: 10.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: healthScore >= 7 ? .green : healthScore >= 4 ? .orange : .red))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                }
                
                // Action Buttons
                HStack(spacing: 12) {
                    Button(action: {}) {
                        Text("Fix Results")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(22)
                    }
                    
                    Button(action: {}) {
                        Text("Done")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.black)
                            .cornerRadius(22)
                    }
                }
            }
            .padding(24)
            .background(Color(.systemBackground))
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct NutrientDisplay: View {
    let value: Int
    let unit: String
    let label: String?
    let icon: String
    let color: Color
    
    init(value: Int, unit: String, label: String? = nil, icon: String, color: Color) {
        self.value = value
        self.unit = unit
        self.label = label
        self.icon = icon
        self.color = color
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(color)
            
            Text("\(value)")
                .font(.system(size: 18, weight: .bold))
            
            Text(unit)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)
            
            if let label = label {
                Text(label)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// Note: MealData, NutritionInfo models are now in Core/Models/NutritionModels.swift

#Preview {
    NutritionCard(meal: MealData.sample)
        .padding()
}