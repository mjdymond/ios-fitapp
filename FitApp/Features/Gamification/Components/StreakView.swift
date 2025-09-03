import SwiftUI
import CoreData

struct StreakView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var gamificationService: GamificationService
    
    init(context: NSManagedObjectContext) {
        self._gamificationService = StateObject(wrappedValue: GamificationService(context: context))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Main Streak Display
            VStack(spacing: 16) {
                Text("🔥")
                    .font(.system(size: 60))
                
                Text("\(gamificationService.currentStreak)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.orange)
                
                Text("Day Streak")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Keep it up! You're doing great!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemGray6))
            )
            
            // Streak Types
            VStack(alignment: .leading, spacing: 12) {
                Text("Your Streaks")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                StreakTypeRow(
                    icon: "dumbbell.fill",
                    title: "Workout Streak",
                    current: gamificationService.currentStreak,
                    best: getBestStreak(type: "workout"),
                    color: .blue
                )
                
                StreakTypeRow(
                    icon: "scalemass.fill",
                    title: "Weight Tracking",
                    current: getStreakCount(type: "weight_tracking"),
                    best: getBestStreak(type: "weight_tracking"),
                    color: .green
                )
                
                StreakTypeRow(
                    icon: "fork.knife",
                    title: "Meal Logging",
                    current: getStreakCount(type: "meal_logging"),
                    best: getBestStreak(type: "meal_logging"),
                    color: .orange
                )
            }
            
            // Motivation
            MotivationCard()
            
            Spacer()
        }
        .padding()
        .navigationTitle("Streaks")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func getStreakCount(type: String) -> Int {
        let request: NSFetchRequest<Streak> = Streak.fetchRequest()
        request.predicate = NSPredicate(format: "type == %@ AND isActive == TRUE", type)
        request.fetchLimit = 1
        
        do {
            if let streak = try viewContext.fetch(request).first {
                return Int(streak.currentCount)
            }
        } catch {
            print("Error fetching streak: \(error)")
        }
        
        return 0
    }
    
    private func getBestStreak(type: String) -> Int {
        let request: NSFetchRequest<Streak> = Streak.fetchRequest()
        request.predicate = NSPredicate(format: "type == %@", type)
        request.fetchLimit = 1
        
        do {
            if let streak = try viewContext.fetch(request).first {
                return Int(streak.bestCount)
            }
        } catch {
            print("Error fetching best streak: \(error)")
        }
        
        return 0
    }
}

struct StreakTypeRow: View {
    let icon: String
    let title: String
    let current: Int
    let best: Int
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("Best: \(best) days")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(current)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                
                Text("current")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct MotivationCard: View {
    private let motivationMessages = [
        "Every day you show up, you're building a stronger you! 💪",
        "Consistency is the key to success. Keep going! 🔑",
        "Your future self will thank you for today's effort! 🙏",
        "Small steps daily lead to big changes yearly! 👟",
        "You're not just building habits, you're building character! 🌟"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Daily Motivation")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(motivationMessages.randomElement() ?? motivationMessages[0])
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(
                    colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
        )
    }
}

#Preview {
    NavigationView {
        StreakView(context: PersistenceController.preview.container.viewContext)
    }
}