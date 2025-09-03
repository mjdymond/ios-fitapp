import SwiftUI
import CoreData
import Foundation

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Meal.date, ascending: false)],
        predicate: NSPredicate(format: "date >= %@", Calendar.current.startOfDay(for: Date()) as CVarArg),
        animation: .default)
    private var todaysMeals: FetchedResults<Meal>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.createdAt, ascending: false)],
        animation: .default)
    private var users: FetchedResults<User>
    
    @State private var showingFoodScanner = false
    @State private var currentMealIndex = 0
    
    // Sample meals for demo - replace with actual data
    let sampleMeals = MealData.sampleMeals
    
    var currentUser: User? {
        users.first
    }
    
    var dailyCalorieGoal: Double {
        currentUser?.targetWeight ?? 2000 // Default to 2000 if no user data
    }
    
    var consumedCalories: Double {
        sampleMeals.prefix(currentMealIndex + 1).reduce(0) { $0 + $1.nutrition.calories }
    }
    
    var calorieProgress: Double {
        min(consumedCalories / dailyCalorieGoal, 1.0)
    }
    
    var currentMeal: MealData {
        sampleMeals[currentMealIndex]
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with time and navigation
                HStack {
                    NavigationLink(destination: PlanSummaryView()) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    Text(Date().formatted(.dateTime.hour().minute()))
                        .font(.system(size: 18, weight: .medium))
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("EN")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Daily Progress Bar
                VStack(spacing: 8) {
                    HStack {
                        Text("Daily Progress")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(Int(consumedCalories))/\(Int(dailyCalorieGoal)) cal")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    
                    ProgressView(value: calorieProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                        .scaleEffect(x: 1, y: 1.5, anchor: .center)
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                // Main Nutrition Card
                ScrollView {
                    VStack(spacing: 32) {
                        // Gamification Summary
                        GamificationSummaryCard()
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        
                        NutritionCard(meal: currentMeal)
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        
                        // Meal Navigation
                        if sampleMeals.count > 1 {
                            HStack(spacing: 12) {
                                ForEach(0..<sampleMeals.count, id: \.self) { index in
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            currentMealIndex = index
                                        }
                                    }) {
                                        Circle()
                                            .fill(index == currentMealIndex ? Color.black : Color.gray.opacity(0.3))
                                            .frame(width: 8, height: 8)
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 120)
                    }
                }
                .refreshable {
                    // Handle refresh
                }
            }
            
            // Floating Camera Button
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showingFoodScanner = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 64, height: 64)
                                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                            
                            Image(systemName: "camera.fill")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .fullScreenCover(isPresented: $showingFoodScanner) {
            FoodScannerView()
        }
    }
}


// MARK: - Data Models

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

// MARK: - Nutrition Card Component

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

// MARK: - Food Scanner View

struct FoodScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingImagePicker = false
    @State private var capturedImage: UIImage?
    @State private var scanResult: String = ""
    @State private var isScanning = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Scan Food")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .padding(.top, 8)
                
                // Camera View Placeholder
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    VStack {
                        Spacer()
                        
                        // Square scan frame
                        Rectangle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 280, height: 280)
                        
                        Spacer()
                    }
                    
                    // Instructions
                    VStack {
                        Spacer()
                        
                        if !isScanning && scanResult.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "viewfinder")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text("Point camera at food")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .padding(.bottom, 200)
                        }
                        
                        if isScanning {
                            VStack(spacing: 8) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1.2)
                                
                                Text("Analyzing food...")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .padding(.bottom, 200)
                        }
                        
                        Spacer()
                    }
                }
                
                // Bottom Action Bar
                HStack(spacing: 0) {
                    // Gallery button
                    Button(action: {}) {
                        VStack(spacing: 8) {
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 24))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("Gallery")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                    }
                    
                    // Scan button
                    Button(action: startScanning) {
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .stroke(Color.white, lineWidth: 4)
                                    .frame(width: 70, height: 70)
                                
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 60, height: 60)
                                
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.black)
                            }
                            
                            Text("Scan Food")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 100)
                    }
                    .disabled(isScanning)
                    
                    // Manual entry button
                    Button(action: {}) {
                        VStack(spacing: 8) {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 24))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("Manual")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
    
    private func startScanning() {
        isScanning = true
        
        // Simulate scanning process
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            isScanning = false
            // Simulate scan result
            let foods = ["Turkey Sandwich", "Grilled Chicken Salad", "Banana", "Greek Yogurt"]
            scanResult = foods.randomElement() ?? "Unknown Food"
        }
    }
}

// MARK: - Plan Summary View

struct PlanSummaryView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 16) {
                    Text("Congratulations your custom plan is ready!")
                        .font(.system(size: 28, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("You should lose: Lose 12 lbs by December 26")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 20)
                
                // Daily Recommendation Cards
                VStack(spacing: 16) {
                    Text("Daily Recommendations")
                        .font(.system(size: 20, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        RecommendationCard(title: "Calories", value: "2000", unit: "cal", icon: "flame.fill", color: .orange)
                        RecommendationCard(title: "Carbs", value: "250", unit: "g", icon: "square.fill", color: .yellow)
                        RecommendationCard(title: "Protein", value: "150", unit: "g", icon: "leaf.fill", color: .red)
                        RecommendationCard(title: "Fats", value: "67", unit: "g", icon: "drop.fill", color: .purple)
                    }
                    .padding(.horizontal)
                }
                
                Spacer(minLength: 100)
            }
            .padding(.vertical)
        }
        .navigationTitle("Your Plan")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct RecommendationCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "pencil")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
            }
            
            VStack(spacing: 4) {
                HStack(alignment: .bottom, spacing: 2) {
                    Text(value)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(unit)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(.bottom, 4)
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

// MARK: - Gamification Summary Card

struct GamificationSummaryCard: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var gamificationService: GamificationService
    
    init() {
        // This will be properly initialized in the body
        self._gamificationService = StateObject(wrappedValue: GamificationService(context: PersistenceController.shared.container.viewContext))
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Today's Progress")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            HStack(spacing: 16) {
                // Streak
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Text("🔥")
                            .font(.title2)
                        Text("\(gamificationService.currentStreak)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                    Text("Day Streak")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .frame(height: 30)
                
                // Points
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Text("⭐")
                            .font(.title2)
                        Text("\(gamificationService.totalPoints)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    Text("Total Points")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .frame(height: 30)
                
                // Level
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Text("👑")
                            .font(.title2)
                        Text("L\(gamificationService.currentLevel)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                    }
                    Text("Level")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
            
            // Today's Challenge (if exists)
            if let challenge = gamificationService.todaysChallenge {
                Divider()
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Today's Challenge")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Spacer()
                        if challenge.isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    
                    Text(challenge.title ?? "Challenge")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if !challenge.isCompleted {
                        let progress = min(challenge.currentValue / challenge.targetValue, 1.0)
                        ProgressView(value: progress)
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                            .scaleEffect(y: 0.8)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
}

#Preview {
    DashboardView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
