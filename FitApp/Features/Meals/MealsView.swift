import SwiftUI
import CoreData

struct MealsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Meal.date, ascending: false)],
        predicate: NSPredicate(format: "date >= %@", Calendar.current.startOfDay(for: Date()) as CVarArg),
        animation: .default)
    private var todaysMeals: FetchedResults<Meal>
    
    @State private var showingNewMeal = false
    @State private var selectedMealType = MealType.breakfast
    
    enum MealType: String, CaseIterable {
        case breakfast = "Breakfast"
        case lunch = "Lunch"
        case dinner = "Dinner"
        case snack = "Snack"
        
        var icon: String {
            switch self {
            case .breakfast: return "sun.rise"
            case .lunch: return "sun.max"
            case .dinner: return "moon"
            case .snack: return "leaf"
            }
        }
        
        var color: Color {
            switch self {
            case .breakfast: return .orange
            case .lunch: return .yellow
            case .dinner: return .purple
            case .snack: return .green
            }
        }
    }
    
    var totalCalories: Double {
        todaysMeals.reduce(into: 0.0) { total, meal in
            let mealCalories = meal.foods?.allObjects.compactMap { food in
                (food as? Food)?.calories ?? 0
            }.reduce(0, +) ?? 0
            total += mealCalories
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Daily Summary Card
                    DailyNutritionCard(
                        calories: totalCalories,
                        mealsCount: todaysMeals.count
                    )
                    .padding(.horizontal)
                    
                    // Meals by Type
                    VStack(spacing: 16) {
                        ForEach(MealType.allCases, id: \.self) { mealType in
                            MealTypeSection(
                                mealType: mealType,
                                meals: todaysMeals.filter { $0.type == mealType.rawValue }
                            ) {
                                selectedMealType = mealType
                                showingNewMeal = true
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 100)
                }
                .padding(.top)
            }
            .navigationTitle("Meals")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewMeal = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewMeal) {
                NewMealView(selectedMealType: selectedMealType)
            }
        }
    }
}

struct DailyNutritionCard: View {
    let calories: Double
    let mealsCount: Int
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Today's Nutrition")
                    .font(.headline)
                Spacer()
                Text(Date(), style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 32) {
                VStack {
                    Text("\(Int(calories))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    Text("Calories")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text("\(mealsCount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text("Meals")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct MealTypeSection: View {
    let mealType: MealsView.MealType
    let meals: [Meal]
    let onAddMeal: () -> Void
    
    var totalCalories: Double {
        meals.reduce(into: 0.0) { total, meal in
            let mealCalories = meal.foods?.allObjects.compactMap { food in
                (food as? Food)?.calories ?? 0
            }.reduce(0, +) ?? 0
            total += mealCalories
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(mealType.rawValue, systemImage: mealType.icon)
                    .font(.headline)
                    .foregroundColor(mealType.color)
                
                Spacer()
                
                if !meals.isEmpty {
                    Text("\(Int(totalCalories)) cal")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Button(action: onAddMeal) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(mealType.color)
                }
            }
            
            if meals.isEmpty {
                Button(action: onAddMeal) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add \(mealType.rawValue)")
                    }
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(meals, id: \.self) { meal in
                        MealRowView(meal: meal)
                    }
                }
            }
        }
    }
}

struct MealRowView: View {
    let meal: Meal
    
    var totalCalories: Double {
        meal.foods?.allObjects.compactMap { food in
            (food as? Food)?.calories ?? 0
        }.reduce(0, +) ?? 0
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.name ?? "Untitled Meal")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                if let foods = meal.foods?.allObjects as? [Food], !foods.isEmpty {
                    Text("\(foods.count) items")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Text("\(Int(totalCalories)) cal")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct NewMealView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let selectedMealType: MealsView.MealType
    
    @State private var mealName = ""
    @State private var selectedFoods: [FoodItem] = []
    @State private var searchText = ""
    
    // Sample food database - in a real app, this would come from an API
    let foodDatabase = [
        FoodItem(name: "Banana", calories: 105, protein: 1.3, carbs: 27, fat: 0.4),
        FoodItem(name: "Apple", calories: 52, protein: 0.3, carbs: 14, fat: 0.2),
        FoodItem(name: "Chicken Breast (100g)", calories: 165, protein: 31, carbs: 0, fat: 3.6),
        FoodItem(name: "Brown Rice (1 cup)", calories: 218, protein: 4.5, carbs: 45, fat: 1.6),
        FoodItem(name: "Broccoli (1 cup)", calories: 25, protein: 3, carbs: 5, fat: 0.3),
        FoodItem(name: "Salmon (100g)", calories: 208, protein: 20, carbs: 0, fat: 12),
        FoodItem(name: "Greek Yogurt (1 cup)", calories: 130, protein: 23, carbs: 9, fat: 0),
        FoodItem(name: "Almonds (28g)", calories: 164, protein: 6, carbs: 6, fat: 14)
    ]
    
    var filteredFoods: [FoodItem] {
        if searchText.isEmpty {
            return foodDatabase
        } else {
            return foodDatabase.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var totalCalories: Double {
        selectedFoods.reduce(0) { $0 + $1.calories }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search and Selection Summary
                VStack(spacing: 16) {
                    SearchBar(text: $searchText)
                    
                    if !selectedFoods.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(selectedFoods) { food in
                                    SelectedFoodChip(food: food) {
                                        selectedFoods.removeAll { $0.id == food.id }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding()
                
                // Food List
                List {
                    ForEach(filteredFoods) { food in
                        FoodRowView(
                            food: food,
                            isSelected: selectedFoods.contains { $0.id == food.id }
                        ) {
                            if selectedFoods.contains(where: { $0.id == food.id }) {
                                selectedFoods.removeAll { $0.id == food.id }
                            } else {
                                selectedFoods.append(food)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add \(selectedMealType.rawValue)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMeal()
                    }
                    .disabled(selectedFoods.isEmpty)
                }
            }
            .safeAreaInset(edge: .bottom) {
                if !selectedFoods.isEmpty {
                    VStack {
                        HStack {
                            Text("Total: \(Int(totalCalories)) calories")
                                .font(.headline)
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                    }
                }
            }
        }
    }
    
    private func saveMeal() {
        let newMeal = Meal(context: viewContext)
        newMeal.id = UUID()
        newMeal.name = selectedMealType.rawValue
        newMeal.type = selectedMealType.rawValue
        newMeal.date = Date()
        
        for foodItem in selectedFoods {
            let food = Food(context: viewContext)
            food.id = UUID()
            food.name = foodItem.name
            food.calories = foodItem.calories
            food.protein = foodItem.protein
            food.carbs = foodItem.carbs
            food.fat = foodItem.fat
            food.quantity = 1.0
            food.unit = "serving"
            
            newMeal.addToFoods(food)
        }
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Failed to save meal: \(error)")
        }
    }
}

struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let calories: Double
    let protein: Double
    let carbs: Double
    let fat: Double
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search foods...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct SelectedFoodChip: View {
    let food: FoodItem
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(food.name)
                .font(.caption)
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.caption)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(12)
    }
}

struct FoodRowView: View {
    let food: FoodItem
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(food.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("\(Int(food.calories)) cal")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.secondary)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    MealsView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
