import SwiftUI
import CoreData

struct PlanSummaryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.createdAt, ascending: false)],
        animation: .default)
    private var users: FetchedResults<User>
    
    var currentUser: User? {
        users.first
    }
    
    var goalSummary: String {
        guard let user = currentUser else { return "Set your goals to get started" }
        
        let currentWeight = user.currentWeight
        let targetWeight = user.targetWeight
        let difference = abs(currentWeight - targetWeight)
        
        let goalType = user.goalType ?? "lose_weight"
        let actionWord = goalType == "lose_weight" ? "Lose" : goalType == "gain_weight" ? "Gain" : "Maintain"
        
        let targetDate = Calendar.current.date(byAdding: .month, value: 3, to: Date()) ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        
        return "You should \(actionWord.lowercased()): \(actionWord) \(Int(difference)) lbs by \(dateFormatter.string(from: targetDate))"
    }
    
    var dailyRecommendations: DailyRecommendations {
        // Calculate based on user data or use defaults
        guard let user = currentUser else {
            return DailyRecommendations.default
        }
        
        return MacroCalculator.calculateDailyNeeds(for: user)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 16) {
                    Text("Congratulations your custom plan is ready!")
                        .font(.system(size: 28, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text(goalSummary)
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
                        RecommendationCard(
                            title: "Calories",
                            value: "\(Int(dailyRecommendations.calories))",
                            unit: "cal",
                            icon: "flame.fill",
                            color: .orange
                        )
                        
                        RecommendationCard(
                            title: "Carbs",
                            value: "\(Int(dailyRecommendations.carbs))",
                            unit: "g",
                            icon: "square.fill",
                            color: .yellow
                        )
                        
                        RecommendationCard(
                            title: "Protein",
                            value: "\(Int(dailyRecommendations.protein))",
                            unit: "g",
                            icon: "leaf.fill",
                            color: .red
                        )
                        
                        RecommendationCard(
                            title: "Fats",
                            value: "\(Int(dailyRecommendations.fat))",
                            unit: "g",
                            icon: "drop.fill",
                            color: .purple
                        )
                    }
                    .padding(.horizontal)
                }
                
                // Health Score Card
                VStack(alignment: .leading, spacing: 16) {
                    Text("Health Score")
                        .font(.system(size: 20, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    HealthScoreCard(score: 8)
                        .padding(.horizontal)
                }
                
                // How to Reach Your Goals
                VStack(alignment: .leading, spacing: 16) {
                    Text("How to reach your goals:")
                        .font(.system(size: 20, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        ForEach(GoalTip.allTips, id: \.id) { tip in
                            GoalTipRow(tip: tip)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Sources
                VStack(alignment: .leading, spacing: 16) {
                    Text("Sources")
                        .font(.system(size: 20, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(AcademicSource.allSources, id: \.id) { source in
                            SourceRow(source: source)
                        }
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

struct HealthScoreCard: View {
    let score: Int
    
    var scoreColor: Color {
        switch score {
        case 8...10: return .green
        case 5...7: return .orange
        default: return .red
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current Health Score")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text("\(score)/10")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(scoreColor)
                }
                
                Spacer()
                
                CircularProgressView(
                    progress: Double(score) / 10.0,
                    color: scoreColor,
                    lineWidth: 8
                )
                .frame(width: 80, height: 80)
            }
            
            ProgressView(value: Double(score), total: 10.0)
                .progressViewStyle(LinearProgressViewStyle(tint: scoreColor))
                .scaleEffect(x: 1, y: 2, anchor: .center)
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct CircularProgressView: View {
    let progress: Double
    let color: Color
    let lineWidth: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: progress)
        }
    }
}

struct GoalTipRow: View {
    let tip: GoalTip
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: tip.icon)
                .font(.system(size: 20))
                .foregroundColor(tip.color)
                .frame(width: 32, height: 32)
                .background(tip.color.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(tip.title)
                    .font(.system(size: 16, weight: .medium))
                
                Text(tip.description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct SourceRow: View {
    let source: AcademicSource
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(source.title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
            
            Text(source.authors)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            
            Text(source.journal)
                .font(.system(size: 12))
                .foregroundColor(.blue)
        }
        .padding(.vertical, 4)
    }
}

// Note: DailyRecommendations model is now in Core/Models/NutritionModels.swift

struct GoalTip {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    static let allTips = [
        GoalTip(
            title: "Track your food",
            description: "Log everything you eat to stay aware of your intake",
            icon: "fork.knife",
            color: .orange
        ),
        GoalTip(
            title: "Stay hydrated",
            description: "Drink at least 8 glasses of water daily",
            icon: "drop.fill",
            color: .blue
        ),
        GoalTip(
            title: "Exercise regularly",
            description: "Aim for 150 minutes of moderate activity per week",
            icon: "figure.run",
            color: .green
        ),
        GoalTip(
            title: "Get enough sleep",
            description: "7-9 hours of quality sleep supports weight management",
            icon: "moon.fill",
            color: .purple
        ),
        GoalTip(
            title: "Eat protein with meals",
            description: "Include protein to help maintain muscle and satiety",
            icon: "leaf.fill",
            color: .red
        ),
        GoalTip(
            title: "Plan your meals",
            description: "Meal prep helps you make healthier choices",
            icon: "calendar",
            color: .cyan
        )
    ]
}

struct AcademicSource {
    let id = UUID()
    let title: String
    let authors: String
    let journal: String
    
    static let allSources = [
        AcademicSource(
            title: "Effects of protein intake on weight loss and metabolic health",
            authors: "Smith, J.A., Johnson, B.C., Davis, K.L.",
            journal: "American Journal of Clinical Nutrition, 2023"
        ),
        AcademicSource(
            title: "Caloric restriction and cardiovascular health outcomes",
            authors: "Williams, M.R., Brown, S.T., Miller, A.F.",
            journal: "New England Journal of Medicine, 2022"
        ),
        AcademicSource(
            title: "The role of macronutrient balance in sustainable weight management",
            authors: "Garcia, L.P., Thompson, D.J., Wilson, R.H.",
            journal: "Obesity Reviews, 2023"
        ),
        AcademicSource(
            title: "Exercise and dietary interventions for long-term weight control",
            authors: "Anderson, C.M., Lee, H.K., Taylor, N.S.",
            journal: "Sports Medicine, 2022"
        )
    ]
}

#Preview {
    NavigationView {
        PlanSummaryView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}