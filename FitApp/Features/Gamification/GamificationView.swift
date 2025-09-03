import SwiftUI
import CoreData

struct GamificationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var gamificationService: GamificationService
    
    init(context: NSManagedObjectContext) {
        self._gamificationService = StateObject(wrappedValue: GamificationService(context: context))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Stats
                    VStack(spacing: 16) {
                        HStack(spacing: 30) {
                            StatCard(
                                title: "Current Streak",
                                value: "\(gamificationService.currentStreak)",
                                subtitle: "days",
                                icon: "flame.fill",
                                color: .orange
                            )
                            
                            StatCard(
                                title: "Level",
                                value: "\(gamificationService.currentLevel)",
                                subtitle: "points: \(gamificationService.totalPoints)",
                                icon: "star.fill",
                                color: .yellow
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Today's Challenge
                    if let challenge = gamificationService.todaysChallenge {
                        ChallengeCard(challenge: challenge, gamificationService: gamificationService)
                            .padding(.horizontal)
                    }
                    
                    // Recent Achievements
                    if !gamificationService.recentAchievements.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Recent Achievements")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            
                            LazyVStack(spacing: 8) {
                                ForEach(gamificationService.recentAchievements, id: \.id) { achievement in
                                    AchievementRow(achievement: achievement)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Progress Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Progress Overview")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        
                        ProgressRingsView()
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
}

struct ChallengeCard: View {
    let challenge: Challenge
    let gamificationService: GamificationService
    
    var progress: Double {
        guard challenge.targetValue > 0 else { return 0 }
        return min(challenge.currentValue / challenge.targetValue, 1.0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Challenge")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                
                if challenge.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }
            }
            
            Text(challenge.title ?? "Challenge")
                .font(.subheadline)
                .foregroundColor(.primary)
            
            // Progress Bar
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(Int(challenge.currentValue))/\(Int(challenge.targetValue))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(challenge.pointReward) points")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
                
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: challenge.isCompleted ? .green : .blue))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
}

struct AchievementRow: View {
    let achievement: Achievement
    
    var tierColor: Color {
        switch achievement.tier {
        case "bronze": return .brown
        case "silver": return .gray
        case "gold": return .yellow
        case "platinum": return .purple
        default: return .blue
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: achievement.iconName ?? "star.fill")
                .font(.title2)
                .foregroundColor(tierColor)
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(achievement.title ?? "Achievement")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(achievement.achievementDescription ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("+\(achievement.pointReward)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                
                if let unlockedAt = achievement.unlockedAt {
                    Text(unlockedAt, style: .relative)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct ProgressRingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var workoutProgress: Double = 0.0
    @State private var weightProgress: Double = 0.0
    @State private var mealProgress: Double = 0.0
    
    var body: some View {
        HStack(spacing: 30) {
            ProgressRing(
                progress: workoutProgress,
                title: "Workouts",
                subtitle: "This week",
                color: .blue
            )
            
            ProgressRing(
                progress: weightProgress,
                title: "Weight",
                subtitle: "Tracking",
                color: .green
            )
            
            ProgressRing(
                progress: mealProgress,
                title: "Nutrition",
                subtitle: "Logged",
                color: .orange
            )
        }
        .onAppear {
            loadProgressData()
        }
    }
    
    private func loadProgressData() {
        // Mock progress data - in real implementation, fetch from Core Data
        workoutProgress = 0.7
        weightProgress = 0.9
        mealProgress = 0.4
    }
}

struct ProgressRing: View {
    let progress: Double
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.3), lineWidth: 8)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: progress)
                
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .fontWeight(.medium)
            }
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    GamificationView(context: PersistenceController.preview.container.viewContext)
}