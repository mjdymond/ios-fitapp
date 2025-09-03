import SwiftUI
import CoreData

struct AchievementsListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Achievement.isUnlocked, ascending: false),
            NSSortDescriptor(keyPath: \Achievement.unlockedAt, ascending: false)
        ],
        animation: .default
    )
    private var achievements: FetchedResults<Achievement>
    
    @State private var selectedCategory: AchievementCategory = .all
    
    enum AchievementCategory: String, CaseIterable {
        case all = "All"
        case workout = "Workout"
        case streak = "Streak"
        case weight = "Weight"
        case level = "Level"
        
        var icon: String {
            switch self {
            case .all: return "star.fill"
            case .workout: return "dumbbell.fill"
            case .streak: return "flame.fill"
            case .weight: return "scalemass.fill"
            case .level: return "crown.fill"
            }
        }
    }
    
    var filteredAchievements: [Achievement] {
        if selectedCategory == .all {
            return Array(achievements)
        } else {
            return achievements.filter { $0.category == selectedCategory.rawValue.lowercased() }
        }
    }
    
    var unlockedCount: Int {
        achievements.filter { $0.isUnlocked }.count
    }
    
    var totalCount: Int {
        achievements.count
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Stats
            VStack(spacing: 16) {
                HStack(spacing: 20) {
                    StatBadge(
                        title: "Unlocked",
                        value: "\(unlockedCount)",
                        color: .green
                    )
                    
                    StatBadge(
                        title: "Progress",
                        value: "\(unlockedCount)/\(totalCount)",
                        color: .blue
                    )
                    
                    StatBadge(
                        title: "Completion",
                        value: "\(Int(Double(unlockedCount)/Double(max(totalCount, 1)) * 100))%",
                        color: .orange
                    )
                }
            }
            .padding()
            .background(Color(.systemGray6))
            
            // Category Filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(AchievementCategory.allCases, id: \.self) { category in
                        CategoryButton(
                            category: category,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .background(Color(.systemBackground))
            
            // Achievements List
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(filteredAchievements, id: \.id) { achievement in
                        AchievementCard(achievement: achievement)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Achievements")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            createSampleAchievements()
        }
    }
    
    private func createSampleAchievements() {
        // Create sample achievements if none exist
        if achievements.isEmpty {
            let sampleAchievements = [
                ("First Workout", "Complete your first workout", "dumbbell.fill", "workout", false, 50),
                ("5 Day Streak", "Workout for 5 consecutive days", "flame.fill", "streak", false, 100),
                ("Weight Tracker", "Log your weight for 7 days", "scalemass.fill", "weight", false, 75),
                ("Level 2", "Reach level 2", "crown.fill", "level", false, 200),
                ("Consistency King", "Workout for 30 consecutive days", "flame.fill", "streak", false, 500)
            ]
            
            for (title, description, icon, category, unlocked, points) in sampleAchievements {
                let achievement = Achievement(context: viewContext)
                achievement.id = UUID()
                achievement.title = title
                achievement.achievementDescription = description
                achievement.iconName = icon
                achievement.category = category
                achievement.isUnlocked = unlocked
                achievement.pointReward = Int32(points)
                achievement.tier = points < 100 ? "bronze" : points < 300 ? "silver" : "gold"
                
                if unlocked {
                    achievement.unlockedAt = Date()
                }
            }
            
            try? viewContext.save()
        }
    }
}

struct StatBadge: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct CategoryButton: View {
    let category: AchievementsListView.AchievementCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.caption)
                
                Text(category.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.blue : Color(.systemGray5))
            )
            .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

struct AchievementCard: View {
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
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? tierColor.opacity(0.2) : Color(.systemGray5))
                    .frame(width: 50, height: 50)
                
                Image(systemName: achievement.iconName ?? "star.fill")
                    .font(.title2)
                    .foregroundColor(achievement.isUnlocked ? tierColor : .gray)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title ?? "Achievement")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(achievement.isUnlocked ? .primary : .secondary)
                
                Text(achievement.achievementDescription ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                if achievement.isUnlocked, let unlockedAt = achievement.unlockedAt {
                    Text("Unlocked \(unlockedAt, style: .relative)")
                        .font(.caption2)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            // Points
            VStack(alignment: .trailing, spacing: 4) {
                Text("+\(achievement.pointReward)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(achievement.isUnlocked ? .blue : .gray)
                
                if !achievement.isUnlocked {
                    Text("Locked")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray5))
                        )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
                .opacity(achievement.isUnlocked ? 1.0 : 0.6)
        )
    }
}

#Preview {
    NavigationView {
        AchievementsListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}