import SwiftUI

struct AchievementToast: View {
    let achievement: Achievement
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if isShowing {
                VStack(spacing: 12) {
                    // Trophy icon with animation
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.yellow.opacity(0.3), .orange.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: achievement.iconName ?? "trophy.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.orange)
                    }
                    .scaleEffect(isShowing ? 1.0 : 0.5)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isShowing)
                    
                    VStack(spacing: 4) {
                        Text("🎉 Achievement Unlocked!")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Text(achievement.title ?? "New Achievement")
                            .font(.headline)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text(achievement.achievementDescription ?? "")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                        
                        HStack(spacing: 4) {
                            Text("+\(achievement.pointReward)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            
                            Image(systemName: "star.fill")
                                .font(.caption2)
                                .foregroundColor(.blue)
                            
                            Text("points")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 4)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .shadow(radius: 10)
                )
                .padding(.horizontal, 20)
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                ))
            }
            
            Spacer()
        }
        .onAppear {
            if isShowing {
                // Auto-dismiss after 4 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isShowing = false
                    }
                }
            }
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                isShowing = false
            }
        }
    }
}

// MARK: - Achievement Notification Manager

class AchievementNotificationManager: ObservableObject {
    @Published var currentAchievement: Achievement?
    @Published var isShowing = false
    
    func show(_ achievement: Achievement) {
        currentAchievement = achievement
        withAnimation(.easeInOut(duration: 0.5)) {
            isShowing = true
        }
    }
    
    func hide() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isShowing = false
        }
        
        // Clear the achievement after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.currentAchievement = nil
        }
    }
}

// MARK: - Achievement Notification Overlay

struct AchievementNotificationOverlay: View {
    @ObservedObject var notificationManager: AchievementNotificationManager
    
    var body: some View {
        ZStack {
            if let achievement = notificationManager.currentAchievement {
                AchievementToast(
                    achievement: achievement,
                    isShowing: $notificationManager.isShowing
                )
                .zIndex(999)
            }
        }
    }
}

#Preview {
    let sampleAchievement = Achievement()
    sampleAchievement.title = "First Workout"
    sampleAchievement.achievementDescription = "Completed your first workout session"
    sampleAchievement.iconName = "dumbbell.fill"
    sampleAchievement.pointReward = 50
    
    return AchievementToast(achievement: sampleAchievement, isShowing: .constant(true))
}