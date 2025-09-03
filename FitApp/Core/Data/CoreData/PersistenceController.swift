import CoreData
import Foundation

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Add sample data for previews
        let sampleUser = User(context: viewContext)
        sampleUser.id = UUID()
        sampleUser.name = "John Doe"
        sampleUser.email = "john@example.com"
        sampleUser.currentWeight = 180.0
        sampleUser.targetWeight = 170.0
        sampleUser.height = 72.0
        sampleUser.createdAt = Date()
        
        // Gamification data
        sampleUser.totalPoints = 350
        sampleUser.level = 2
        sampleUser.experience = 350
        
        // Sample streak
        let workoutStreak = Streak(context: viewContext)
        workoutStreak.id = UUID()
        workoutStreak.type = "workout"
        workoutStreak.currentCount = 5
        workoutStreak.bestCount = 12
        workoutStreak.isActive = true
        workoutStreak.lastUpdated = Date()
        workoutStreak.createdAt = Date()
        workoutStreak.user = sampleUser
        
        // Sample challenge
        let dailyChallenge = Challenge(context: viewContext)
        dailyChallenge.id = UUID()
        dailyChallenge.title = "Complete a 30-minute workout"
        dailyChallenge.challengeDescription = "Get your heart pumping with a good workout"
        dailyChallenge.type = "workout"
        dailyChallenge.targetValue = 30.0
        dailyChallenge.currentValue = 15.0
        dailyChallenge.pointReward = 50
        dailyChallenge.isCompleted = false
        dailyChallenge.createdAt = Date()
        dailyChallenge.expiresAt = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        dailyChallenge.user = sampleUser
        
        // Sample achievements
        let firstWorkoutAchievement = Achievement(context: viewContext)
        firstWorkoutAchievement.id = UUID()
        firstWorkoutAchievement.title = "First Workout"
        firstWorkoutAchievement.achievementDescription = "Completed your first workout"
        firstWorkoutAchievement.iconName = "dumbbell.fill"
        firstWorkoutAchievement.tier = "bronze"
        firstWorkoutAchievement.category = "workout"
        firstWorkoutAchievement.pointReward = 50
        firstWorkoutAchievement.isUnlocked = true
        firstWorkoutAchievement.unlockedAt = Calendar.current.date(byAdding: .day, value: -3, to: Date())
        firstWorkoutAchievement.progressValue = 1.0
        firstWorkoutAchievement.targetValue = 1.0
        firstWorkoutAchievement.user = sampleUser
        
        let streakAchievement = Achievement(context: viewContext)
        streakAchievement.id = UUID()
        streakAchievement.title = "5 Day Streak"
        streakAchievement.achievementDescription = "Worked out for 5 consecutive days"
        streakAchievement.iconName = "flame.fill"
        streakAchievement.tier = "silver"
        streakAchievement.category = "streak"
        streakAchievement.pointReward = 100
        streakAchievement.isUnlocked = true
        streakAchievement.unlockedAt = Date()
        streakAchievement.progressValue = 5.0
        streakAchievement.targetValue = 5.0
        streakAchievement.user = sampleUser
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "FitAppDataModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
