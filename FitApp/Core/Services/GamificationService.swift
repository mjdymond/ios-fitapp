import Foundation
import CoreData
import SwiftUI

class GamificationService: ObservableObject {
    private let context: NSManagedObjectContext
    
    @Published var currentStreak: Int = 0
    @Published var totalPoints: Int = 0
    @Published var currentLevel: Int = 1
    @Published var todaysChallenge: Challenge?
    @Published var recentAchievements: [Achievement] = []
    
    init(context: NSManagedObjectContext) {
        self.context = context
        loadGamificationData()
    }
    
    // MARK: - Data Loading
    
    private func loadGamificationData() {
        loadCurrentUser()
        loadTodaysChallenge()
        loadRecentAchievements()
    }
    
    private func loadCurrentUser() {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchLimit = 1
        
        do {
            if let user = try context.fetch(request).first {
                self.totalPoints = Int(user.totalPoints)
                self.currentLevel = Int(user.level)
                loadCurrentStreak(for: user)
            }
        } catch {
            print("Error loading user: \(error)")
        }
    }
    
    private func loadCurrentStreak(for user: User) {
        let request: NSFetchRequest<Streak> = Streak.fetchRequest()
        request.predicate = NSPredicate(format: "user == %@ AND type == %@ AND isActive == TRUE", user, "workout")
        request.fetchLimit = 1
        
        do {
            if let streak = try context.fetch(request).first {
                self.currentStreak = Int(streak.currentCount)
            }
        } catch {
            print("Error loading streak: \(error)")
        }
    }
    
    private func loadTodaysChallenge() {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let request: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        request.predicate = NSPredicate(format: "createdAt >= %@ AND createdAt < %@", startOfDay as NSDate, endOfDay as NSDate)
        request.fetchLimit = 1
        
        do {
            self.todaysChallenge = try context.fetch(request).first
        } catch {
            print("Error loading today's challenge: \(error)")
        }
        
        // Create today's challenge if none exists
        if todaysChallenge == nil {
            createDailyChallenge()
        }
    }
    
    private func loadRecentAchievements() {
        let request: NSFetchRequest<Achievement> = Achievement.fetchRequest()
        request.predicate = NSPredicate(format: "isUnlocked == TRUE")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Achievement.unlockedAt, ascending: false)]
        request.fetchLimit = 5
        
        do {
            self.recentAchievements = try context.fetch(request)
        } catch {
            print("Error loading achievements: \(error)")
        }
    }
    
    // MARK: - Streak Management
    
    func updateWorkoutStreak() {
        guard let user = getCurrentUser() else { return }
        
        let workoutStreak = getOrCreateStreak(for: user, type: "workout")
        let calendar = Calendar.current
        
        // Check if last workout was yesterday or today
        if let lastUpdated = workoutStreak.lastUpdated {
            if calendar.isDateInToday(lastUpdated) {
                // Already updated today, don't increment
                return
            } else if calendar.isDateInYesterday(lastUpdated) {
                // Continue streak
                workoutStreak.currentCount += 1
            } else {
                // Streak broken, restart
                workoutStreak.currentCount = 1
            }
        } else {
            // First workout
            workoutStreak.currentCount = 1
        }
        
        workoutStreak.lastUpdated = Date()
        workoutStreak.isActive = true
        
        // Update best streak if current is higher
        if workoutStreak.currentCount > workoutStreak.bestCount {
            workoutStreak.bestCount = workoutStreak.currentCount
        }
        
        self.currentStreak = Int(workoutStreak.currentCount)
        
        // Award points for maintaining streak
        let streakBonus = Int(workoutStreak.currentCount) * 5
        awardPoints(streakBonus, source: "workout_streak", description: "Workout streak bonus")
        
        saveContext()
        checkForAchievements()
    }
    
    func updateWeightTrackingStreak() {
        guard let user = getCurrentUser() else { return }
        
        let weightStreak = getOrCreateStreak(for: user, type: "weight_tracking")
        let calendar = Calendar.current
        
        if let lastUpdated = weightStreak.lastUpdated {
            if calendar.isDateInToday(lastUpdated) {
                return
            } else if calendar.isDateInYesterday(lastUpdated) {
                weightStreak.currentCount += 1
            } else {
                weightStreak.currentCount = 1
            }
        } else {
            weightStreak.currentCount = 1
        }
        
        weightStreak.lastUpdated = Date()
        weightStreak.isActive = true
        
        if weightStreak.currentCount > weightStreak.bestCount {
            weightStreak.bestCount = weightStreak.currentCount
        }
        
        let streakBonus = Int(weightStreak.currentCount) * 3
        awardPoints(streakBonus, source: "weight_streak", description: "Weight tracking streak bonus")
        
        saveContext()
        checkForAchievements()
    }
    
    private func getOrCreateStreak(for user: User, type: String) -> Streak {
        let request: NSFetchRequest<Streak> = Streak.fetchRequest()
        request.predicate = NSPredicate(format: "user == %@ AND type == %@", user, type)
        request.fetchLimit = 1
        
        do {
            if let existingStreak = try context.fetch(request).first {
                return existingStreak
            }
        } catch {
            print("Error fetching streak: \(error)")
        }
        
        // Create new streak
        let streak = Streak(context: context)
        streak.id = UUID()
        streak.type = type
        streak.currentCount = 0
        streak.bestCount = 0
        streak.isActive = true
        streak.createdAt = Date()
        streak.user = user
        
        return streak
    }
    
    // MARK: - Challenge Management
    
    func createDailyChallenge() {
        guard let user = getCurrentUser() else { return }
        
        let challenges = [
            ("Complete a 30-minute workout", "workout", 30.0, 50),
            ("Log all your meals today", "nutrition", 3.0, 40),
            ("Drink 8 glasses of water", "hydration", 8.0, 30),
            ("Stay within calorie goal", "calories", 1.0, 60),
            ("Take 10,000 steps", "steps", 10000.0, 40)
        ]
        
        let randomChallenge = challenges.randomElement()!
        
        let challenge = Challenge(context: context)
        challenge.id = UUID()
        challenge.title = randomChallenge.0
        challenge.type = randomChallenge.1
        challenge.targetValue = randomChallenge.2
        challenge.currentValue = 0
        challenge.pointReward = Int32(randomChallenge.3)
        challenge.isCompleted = false
        challenge.createdAt = Date()
        challenge.expiresAt = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        challenge.user = user
        
        self.todaysChallenge = challenge
        saveContext()
    }
    
    func updateChallengeProgress(_ type: String, value: Double) {
        guard let challenge = todaysChallenge,
              challenge.type == type,
              !challenge.isCompleted else { return }
        
        challenge.currentValue += value
        
        if challenge.currentValue >= challenge.targetValue {
            completeChallenge(challenge)
        }
        
        saveContext()
    }
    
    private func completeChallenge(_ challenge: Challenge) {
        challenge.isCompleted = true
        challenge.completedAt = Date()
        
        let points = Int(challenge.pointReward)
        awardPoints(points, source: "challenge", description: "Daily challenge completed")
        
        checkForAchievements()
    }
    
    // MARK: - Points System
    
    func awardPoints(_ points: Int, source: String, description: String) {
        guard let user = getCurrentUser() else { return }
        
        // Create point transaction
        let transaction = PointTransaction(context: context)
        transaction.id = UUID()
        transaction.points = Int32(points)
        transaction.type = "earned"
        transaction.source = source
        transaction.transactionDescription = description
        transaction.createdAt = Date()
        transaction.user = user
        
        // Update user's total points
        user.totalPoints += Int32(points)
        user.experience += Int32(points)
        
        // Check for level up
        let newLevel = calculateLevel(from: Int(user.experience))
        if newLevel > user.level {
            levelUp(user: user, newLevel: newLevel)
        }
        
        self.totalPoints = Int(user.totalPoints)
        self.currentLevel = Int(user.level)
        
        saveContext()
    }
    
    private func calculateLevel(from experience: Int) -> Int32 {
        // Every 500 experience points = 1 level
        return Int32((experience / 500) + 1)
    }
    
    private func levelUp(user: User, newLevel: Int32) {
        user.level = newLevel
        
        // Award bonus points for leveling up
        let levelBonus = Int(newLevel) * 100
        awardPoints(levelBonus, source: "level_up", description: "Level \(newLevel) achieved!")
        
        // Create level achievement
        createLevelAchievement(for: user, level: newLevel)
    }
    
    // MARK: - Achievement System
    
    func checkForAchievements() {
        guard let user = getCurrentUser() else { return }
        
        checkStreakAchievements(for: user)
        checkWorkoutAchievements(for: user)
        checkWeightAchievements(for: user)
    }
    
    private func checkStreakAchievements(for user: User) {
        let workoutStreak = getOrCreateStreak(for: user, type: "workout")
        let streakCount = Int(workoutStreak.currentCount)
        
        let streakMilestones = [7, 14, 30, 60, 100]
        
        for milestone in streakMilestones {
            if streakCount >= milestone {
                let achievementId = "streak_\(milestone)"
                if !hasAchievement(user: user, achievementId: achievementId) {
                    createStreakAchievement(for: user, streak: milestone)
                }
            }
        }
    }
    
    private func checkWorkoutAchievements(for user: User) {
        let workoutCount = user.workouts?.count ?? 0
        let workoutMilestones = [1, 5, 10, 25, 50, 100]
        
        for milestone in workoutMilestones {
            if workoutCount >= milestone {
                let achievementId = "workouts_\(milestone)"
                if !hasAchievement(user: user, achievementId: achievementId) {
                    createWorkoutAchievement(for: user, count: milestone)
                }
            }
        }
    }
    
    private func checkWeightAchievements(for user: User) {
        let weightEntries = user.weightEntries?.count ?? 0
        let weightMilestones = [7, 14, 30, 90]
        
        for milestone in weightMilestones {
            if weightEntries >= milestone {
                let achievementId = "weight_entries_\(milestone)"
                if !hasAchievement(user: user, achievementId: achievementId) {
                    createWeightTrackingAchievement(for: user, count: milestone)
                }
            }
        }
    }
    
    private func hasAchievement(user: User, achievementId: String) -> Bool {
        let request: NSFetchRequest<Achievement> = Achievement.fetchRequest()
        request.predicate = NSPredicate(format: "user == %@ AND id == %@", user, achievementId)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first != nil
        } catch {
            return false
        }
    }
    
    private func createStreakAchievement(for user: User, streak: Int) {
        let achievement = Achievement(context: context)
        achievement.id = UUID()
        achievement.title = "\(streak) Day Streak!"
        achievement.achievementDescription = "Completed \(streak) consecutive workout days"
        achievement.iconName = "flame.fill"
        achievement.tier = getTier(for: streak)
        achievement.category = "streak"
        achievement.pointReward = Int32(streak * 10)
        achievement.isUnlocked = true
        achievement.unlockedAt = Date()
        achievement.progressValue = Double(streak)
        achievement.targetValue = Double(streak)
        achievement.user = user
        
        awardPoints(Int(achievement.pointReward), source: "achievement", description: achievement.title ?? "Achievement unlocked")
        
        recentAchievements.insert(achievement, at: 0)
        if recentAchievements.count > 5 {
            recentAchievements.removeLast()
        }
    }
    
    private func createWorkoutAchievement(for user: User, count: Int) {
        let achievement = Achievement(context: context)
        achievement.id = UUID()
        achievement.title = "\(count) Workouts Complete!"
        achievement.achievementDescription = "Completed \(count) total workouts"
        achievement.iconName = "dumbbell.fill"
        achievement.tier = getTier(for: count)
        achievement.category = "workout"
        achievement.pointReward = Int32(count * 5)
        achievement.isUnlocked = true
        achievement.unlockedAt = Date()
        achievement.progressValue = Double(count)
        achievement.targetValue = Double(count)
        achievement.user = user
        
        awardPoints(Int(achievement.pointReward), source: "achievement", description: achievement.title ?? "Achievement unlocked")
        
        recentAchievements.insert(achievement, at: 0)
        if recentAchievements.count > 5 {
            recentAchievements.removeLast()
        }
    }
    
    private func createWeightTrackingAchievement(for user: User, count: Int) {
        let achievement = Achievement(context: context)
        achievement.id = UUID()
        achievement.title = "\(count) Days Tracked!"
        achievement.achievementDescription = "Logged weight for \(count) days"
        achievement.iconName = "scalemass.fill"
        achievement.tier = getTier(for: count)
        achievement.category = "weight"
        achievement.pointReward = Int32(count * 3)
        achievement.isUnlocked = true
        achievement.unlockedAt = Date()
        achievement.progressValue = Double(count)
        achievement.targetValue = Double(count)
        achievement.user = user
        
        awardPoints(Int(achievement.pointReward), source: "achievement", description: achievement.title ?? "Achievement unlocked")
        
        recentAchievements.insert(achievement, at: 0)
        if recentAchievements.count > 5 {
            recentAchievements.removeLast()
        }
    }
    
    private func createLevelAchievement(for user: User, level: Int32) {
        let achievement = Achievement(context: context)
        achievement.id = UUID()
        achievement.title = "Level \(level) Reached!"
        achievement.achievementDescription = "Reached level \(level)"
        achievement.iconName = "star.fill"
        achievement.tier = "gold"
        achievement.category = "level"
        achievement.pointReward = Int32(level * 50)
        achievement.isUnlocked = true
        achievement.unlockedAt = Date()
        achievement.progressValue = Double(level)
        achievement.targetValue = Double(level)
        achievement.user = user
        
        recentAchievements.insert(achievement, at: 0)
        if recentAchievements.count > 5 {
            recentAchievements.removeLast()
        }
    }
    
    private func getTier(for value: Int) -> String {
        switch value {
        case 1...5: return "bronze"
        case 6...25: return "silver"
        case 26...50: return "gold"
        default: return "platinum"
        }
    }
    
    // MARK: - Helper Methods
    
    private func getCurrentUser() -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Error fetching current user: \(error)")
            return nil
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}