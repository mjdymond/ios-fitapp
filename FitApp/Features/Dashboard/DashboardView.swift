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
    @State private var selectedDate = Date()
    @State private var currentPageIndex = 0
    
    // Sample data - replace with real data
    private let currentStreak = 0
    
    // Page 1 Data - Calories
    private let caloriesEaten = 0
    private let caloriesGoal = 2662
    private let caloriesBurned = 200
    private let caloriesNet = 115
    private let proteinEaten = 0
    private let proteinGoal = 208
    private let carbsEaten = 0
    private let carbsGoal = 290
    private let fatEaten = 0
    private let fatGoal = 74
    
    // Page 2 Data - Micronutrients
    private let fiberEaten = 0
    private let fiberGoal = 38
    private let sugarEaten = 0
    private let sugarGoal = 88
    private let sodiumEaten = 0
    private let sodiumGoal = 2300
    
    // Page 3 Data - Activity
    private let stepsToday = 2023
    private let stepsGoal = 10000
    private let caloriesBurnedActivity = 115
    private let waterOz = 0
    private let waterCups = 0
    
    var body: some View {
        ZStack {
            Color(hex: "F2F2F7")
                .ignoresSafeArea()
            
            ScrollView {
            VStack(spacing: 0) {
                    // Header
                    headerSection
                    
                    // Week Calendar
                    weekCalendarSection
                    
                    // Swipeable Dashboard Pages
                    swipeableDashboardSection
                    
                    // Page Indicator
                    pageIndicatorSection
                    
                    // Recently Uploaded Section
                    recentlyUploadedSection
                    
                    Spacer(minLength: 100)
                }
            }
            
            // Floating Add Button
            floatingAddButton
        }
        .fullScreenCover(isPresented: $showingFoodScanner) {
            FoodScannerView()
        }
    }
}

// MARK: - Header Section
extension DashboardView {
    private var headerSection: some View {
        HStack {
            // Apple Icon and Title
            HStack(spacing: 8) {
                Image(systemName: "apple.logo")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.black)
                
                Text("Cal AI")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
                    .tracking(-0.3)
            }
            
                Spacer()
            
            // Streak Counter
            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "FF8C00"))
                
                Text("\(currentStreak)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 20)
        .background(Color(hex: "F2F2F7"))
    }
}

// MARK: - Week Calendar Section
extension DashboardView {
    private var weekCalendarSection: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(weekDays, id: \.date) { dayInfo in
                    VStack(spacing: 8) {
                        Text(dayInfo.dayName)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(Color(hex: "8E8E93"))
                        
                        ZStack {
                            Circle()
                                .fill(dayInfo.isSelected ? Color.black : Color.clear)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Circle()
                                        .stroke(dayInfo.isToday && !dayInfo.isSelected ? Color.black : Color.clear, lineWidth: 2)
                                )
                            
                            Text("\(dayInfo.dayNumber)")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(dayInfo.isSelected ? .white : (dayInfo.isToday ? .black : Color(hex: "8E8E93")))
                        }
                        .onTapGesture {
                            selectedDate = dayInfo.date
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }
    
    private var weekDays: [DayInfo] {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        
        return (0..<7).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: startOfWeek) else { return nil }
            let dayName = DateFormatter().weekdaySymbols[calendar.component(.weekday, from: date) - 1].prefix(3).capitalized
            let dayNumber = calendar.component(.day, from: date)
            let isToday = calendar.isDate(date, inSameDayAs: today)
            let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
            
            return DayInfo(
                date: date,
                dayName: String(dayName),
                dayNumber: dayNumber,
                isToday: isToday,
                isSelected: isSelected
            )
        }
    }
}

// MARK: - Swipeable Dashboard Section
extension DashboardView {
    private var swipeableDashboardSection: some View {
        TabView(selection: $currentPageIndex) {
            // Page 1: Calories
            caloriesPageView
                .tag(0)
            
            // Page 2: Micronutrients
            micronutrientsPageView
                .tag(1)
            
            // Page 3: Activity
            activityPageView
                .tag(2)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: 400)
        .padding(.bottom, 24)
    }
}

// MARK: - Page 1: Calories View
extension DashboardView {
    private var caloriesPageView: some View {
        VStack(spacing: 24) {
            // Main Calories Card
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    // Left Content
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .bottom, spacing: 0) {
                            Text("\(caloriesEaten)")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.black)
                                .tracking(-0.5)
                            
                            Text("/\(caloriesGoal)")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(Color(hex: "8E8E93"))
                                .padding(.bottom, 6)
                        }
                        
                        Text("Calories eaten")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.black)
                        
                        HStack(spacing: 16) {
                            HStack(spacing: 4) {
                                Image(systemName: "clock.arrow.circlepath")
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)
                                
                                Text("+\(caloriesBurned)")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.black)
                            }
                            
                            HStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(hex: "FF8C00"))
                                
                                Text("+\(caloriesNet)")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color(hex: "FF8C00"))
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Right Content - Progress Ring
                    ZStack {
                        // Background ring
                        Circle()
                            .stroke(Color(hex: "F2F2F7"), lineWidth: 8)
                            .frame(width: 120, height: 120)
                        
                        // Progress ring (0% since no calories eaten)
                        Circle()
                            .trim(from: 0, to: 0)
                            .stroke(Color.black, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(-90))
                        
                        // Center icon
                        Image(systemName: "flame.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(24)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
            .padding(.horizontal, 20)
            
            // Macros Section
            HStack(spacing: 12) {
                // Protein Card
                macroCard(
                    value: "\(proteinEaten)/\(proteinGoal)g",
                    label: "Protein eaten",
                    icon: "dumbbell.fill",
                    iconColor: Color(hex: "FF3B30"),
                    ringColor: Color(hex: "FF3B30"),
                    progress: 0.0
                )
                
                // Carbs Card
                macroCard(
                    value: "\(carbsEaten)/\(carbsGoal)g",
                    label: "Carbs eaten",
                    icon: "leaf.fill",
                    iconColor: Color(hex: "DEB887"),
                    ringColor: Color(hex: "DEB887"),
                    progress: 0.0
                )
                
                // Fat Card
                macroCard(
                    value: "\(fatEaten)/\(fatGoal)g",
                    label: "Fat eaten",
                    icon: "drop.fill",
                    iconColor: Color(hex: "007AFF"),
                    ringColor: Color(hex: "007AFF"),
                    progress: 0.0
                )
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func macroCard(value: String, label: String, icon: String, iconColor: Color, ringColor: Color, progress: Double) -> some View {
        VStack(spacing: 16) {
            Text(value)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.black)
            
            Text(label)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(Color(hex: "8E8E93"))
                .multilineTextAlignment(.center)
            
            ZStack {
                // Background ring
                Circle()
                    .stroke(Color(hex: "F2F2F7"), lineWidth: 6)
                    .frame(width: 60, height: 60)
                
                // Progress ring
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(ringColor, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                
                // Center icon
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Page 2: Micronutrients View
extension DashboardView {
    private var micronutrientsPageView: some View {
        VStack(spacing: 24) {
            // Micronutrients Cards
            HStack(spacing: 12) {
                // Fiber Card
                micronutrientCard(
                    value: "\(fiberEaten)/\(fiberGoal)g",
                    label: "Fiber eaten",
                    icon: "leaf.fill",
                    iconColor: Color(hex: "8B5CF6"),
                    ringColor: Color(hex: "8B5CF6"),
                    progress: 0.0
                )
                
                // Sugar Card
                micronutrientCard(
                    value: "\(sugarEaten)/\(sugarGoal)g",
                    label: "Sugar eaten",
                    icon: "heart.fill",
                    iconColor: Color(hex: "EC4899"),
                    ringColor: Color(hex: "EC4899"),
                    progress: 0.0
                )
                
                // Sodium Card
                micronutrientCard(
                    value: "\(sodiumEaten)/\(sodiumGoal)mg",
                    label: "Sodium eaten",
                    icon: "drop.fill",
                    iconColor: Color(hex: "F59E0B"),
                    ringColor: Color(hex: "F59E0B"),
                    progress: 0.0
                )
            }
            .padding(.horizontal, 20)
            
            // Health Score Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Health Score")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text("N/A")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(hex: "8E8E93"))
                }
                
                Text("Track a few foods to generate your health score for today. Your score reflects nutritional content and how processed your meals are.")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color(hex: "8E8E93"))
                    .lineSpacing(2)
            }
            .padding(24)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
            .padding(.horizontal, 20)
        }
    }
    
    private func micronutrientCard(value: String, label: String, icon: String, iconColor: Color, ringColor: Color, progress: Double) -> some View {
        VStack(spacing: 16) {
            Text(value)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.black)
            
            Text(label)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(Color(hex: "8E8E93"))
                .multilineTextAlignment(.center)
            
            ZStack {
                // Background ring
                Circle()
                    .stroke(Color(hex: "F2F2F7"), lineWidth: 6)
                    .frame(width: 60, height: 60)
                
                // Progress ring
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(ringColor, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                
                // Center icon
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Page 3: Activity View
extension DashboardView {
    private var activityPageView: some View {
        VStack(spacing: 24) {
            // Activity Cards Row
            HStack(spacing: 12) {
                // Steps Card
                VStack(spacing: 16) {
                    HStack(alignment: .bottom, spacing: 0) {
                        Text("\(String(stepsToday).replacingOccurrences(of: ",", with: ","))")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.black)
                            .tracking(-0.3)
                        
                        Text("/\(String(stepsGoal).replacingOccurrences(of: ",", with: ","))")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color(hex: "8E8E93"))
                            .padding(.bottom, 4)
                    }
                    
                    Text("Steps today")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color(hex: "8E8E93"))
                    
                    ZStack {
                        // Background ring
                        Circle()
                            .stroke(Color(hex: "F2F2F7"), lineWidth: 8)
                            .frame(width: 80, height: 80)
                        
                        // Progress ring (about 20% for 2023/10000)
                        Circle()
                            .trim(from: 0, to: Double(stepsToday) / Double(stepsGoal))
                            .stroke(Color.black, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(-90))
                        
                        // Center icon
                        Image(systemName: "figure.walk")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
                
                // Calories Burned Card
                VStack(spacing: 16) {
                    HStack(spacing: 8) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                        
                        Text("\(caloriesBurnedActivity)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.black)
                            .tracking(-0.3)
                    }
                    
                    Text("Calories burned")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color(hex: "8E8E93"))
                    
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "figure.walk")
                        .font(.system(size: 16))
                                .foregroundColor(.black)
                                .frame(width: 20, height: 20)
                                .background(Color.white)
                        .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Steps")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.black)
                                
                                Text("+\(caloriesBurnedActivity)")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(Color(hex: "8E8E93"))
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(hex: "F2F2F7"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
            }
            .padding(.horizontal, 20)
            
            // Water Section
                VStack(spacing: 16) {
                HStack {
                    HStack(spacing: 12) {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color(hex: "007AFF"))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Water")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Text("\(waterOz) fl oz (\(waterCups) cups)")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(Color(hex: "8E8E93"))
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            // Decrease water
                        }) {
                            Image(systemName: "minus")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                                .frame(width: 32, height: 32)
                                .background(Color(hex: "F2F2F7"))
                                .clipShape(Circle())
                        }
                        
                        Button(action: {
                            // Increase water
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                    }
                }
            }
            .padding(24)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Page Indicator Section
extension DashboardView {
    private var pageIndicatorSection: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(index == currentPageIndex ? Color.black : Color(hex: "E5E5EA"))
                    .frame(width: 8, height: 8)
                    .animation(.easeInOut(duration: 0.3), value: currentPageIndex)
            }
        }
        .padding(.bottom, 32)
    }
}

// MARK: - Recently Uploaded Section
extension DashboardView {
    private var recentlyUploadedSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Recently uploaded")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
                .tracking(-0.3)
                .padding(.horizontal, 20)
            
            // Meal Card with Placeholder
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    // Meal image placeholder
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "F2F2F7"))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "fork.knife")
                                .font(.system(size: 20))
                                .foregroundColor(Color(hex: "8E8E93"))
                        )
                    
                    // Meal info placeholder
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hex: "E5E5EA"))
                            .frame(height: 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        RoundedRectangle(cornerRadius: 7)
                            .fill(Color(hex: "F2F2F7"))
                            .frame(height: 14)
                            .frame(width: 120, alignment: .leading)
                    }
                    
                    Spacer()
                }
                .padding(20)
                
                // Add meal prompt
                VStack(spacing: 0) {
                    Divider()
                        .background(Color(hex: "F2F2F7"))
                    
                    Text("Tap + to add your first meal of the day")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(Color(hex: "8E8E93"))
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 40)
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Floating Add Button
extension DashboardView {
    private var floatingAddButton: some View {
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
                            .frame(width: 56, height: 56)
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                        
                        Text("+")
                            .font(.system(size: 28, weight: .light))
                            .foregroundColor(.white)
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }
    }
}

// MARK: - Supporting Types
struct DayInfo {
    let date: Date
    let dayName: String
    let dayNumber: Int
    let isToday: Bool
    let isSelected: Bool
}

// MARK: - Food Scanner View (Simplified)
struct FoodScannerView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
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
                
                Spacer()
                
                Text("Camera functionality would go here")
                    .foregroundColor(.white)
                
                Spacer()
            }
        }
    }
}

#Preview {
    DashboardView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}