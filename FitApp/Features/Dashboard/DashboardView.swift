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
    @State private var showingSearch = false
    @State private var showingMessages = false
    @State private var showingNotifications = false
    @State private var showingSettings = false
    
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
                // Enhanced Header with icons
                HStack(spacing: 12) {
                    // Account icon
                    NavigationLink(destination: PlanSummaryView()) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        Text("Search...")
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .onTapGesture {
                        showingSearch = true
                    }
                    
                    // Messages icon
                    Button(action: {
                        showingMessages = true
                    }) {
                        Image(systemName: "message.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    // Notifications icon
                    Button(action: {
                        showingNotifications = true
                    }) {
                        ZStack {
                            Image(systemName: "bell.fill")
                                .font(.title2)
                                .foregroundColor(.primary)
                            
                            // Notification badge
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                                .offset(x: 8, y: -8)
                        }
                    }
                    
                    // Settings icon
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
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
        .sheet(isPresented: $showingSearch) {
            Text("Search coming soon!")
        }
        .sheet(isPresented: $showingMessages) {
            Text("Messages coming soon!")
        }
        .sheet(isPresented: $showingNotifications) {
            Text("Notifications coming soon!")
        }
        .sheet(isPresented: $showingSettings) {
            Text("Settings coming soon!")
        }
    }
}


#Preview {
    DashboardView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
