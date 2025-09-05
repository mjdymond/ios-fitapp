import SwiftUI
import CoreData

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
