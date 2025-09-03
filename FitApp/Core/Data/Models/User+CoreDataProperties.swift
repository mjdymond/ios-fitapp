import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var activityLevel: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var currentWeight: Double
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var email: String?
    @NSManaged public var height: Double
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var targetWeight: Double
    
    // Gamification properties
    @NSManaged public var totalPoints: Int32
    @NSManaged public var level: Int32
    @NSManaged public var experience: Int32
    
    // Relationships
    @NSManaged public var meals: NSSet?
    @NSManaged public var weightEntries: NSSet?
    @NSManaged public var workouts: NSSet?
    @NSManaged public var streaks: NSSet?
    @NSManaged public var challenges: NSSet?
    @NSManaged public var achievements: NSSet?
    @NSManaged public var pointTransactions: NSSet?

}

// MARK: Generated accessors for meals
extension User {

    @objc(addMealsObject:)
    @NSManaged public func addToMeals(_ value: Meal)

    @objc(removeMealsObject:)
    @NSManaged public func removeFromMeals(_ value: Meal)

    @objc(addMeals:)
    @NSManaged public func addToMeals(_ values: NSSet)

    @objc(removeMeals:)
    @NSManaged public func removeFromMeals(_ values: NSSet)

}

// MARK: Generated accessors for weightEntries
extension User {

    @objc(addWeightEntriesObject:)
    @NSManaged public func addToWeightEntries(_ value: WeightEntry)

    @objc(removeWeightEntriesObject:)
    @NSManaged public func removeFromWeightEntries(_ value: WeightEntry)

    @objc(addWeightEntries:)
    @NSManaged public func addToWeightEntries(_ values: NSSet)

    @objc(removeWeightEntries:)
    @NSManaged public func removeFromWeightEntries(_ values: NSSet)

}

// MARK: Generated accessors for workouts
extension User {

    @objc(addWorkoutsObject:)
    @NSManaged public func addToWorkouts(_ value: Workout)

    @objc(removeWorkoutsObject:)
    @NSManaged public func removeFromWorkouts(_ value: Workout)

    @objc(addWorkouts:)
    @NSManaged public func addToWorkouts(_ values: NSSet)

    @objc(removeWorkouts:)
    @NSManaged public func removeFromWorkouts(_ values: NSSet)

}

// MARK: Generated accessors for streaks
extension User {

    @objc(addStreaksObject:)
    @NSManaged public func addToStreaks(_ value: Streak)

    @objc(removeStreaksObject:)
    @NSManaged public func removeFromStreaks(_ value: Streak)

    @objc(addStreaks:)
    @NSManaged public func addToStreaks(_ values: NSSet)

    @objc(removeStreaks:)
    @NSManaged public func removeFromStreaks(_ values: NSSet)

}

// MARK: Generated accessors for challenges
extension User {

    @objc(addChallengesObject:)
    @NSManaged public func addToChallenges(_ value: Challenge)

    @objc(removeChallengesObject:)
    @NSManaged public func removeFromChallenges(_ value: Challenge)

    @objc(addChallenges:)
    @NSManaged public func addToChallenges(_ values: NSSet)

    @objc(removeChallenges:)
    @NSManaged public func removeFromChallenges(_ values: NSSet)

}

// MARK: Generated accessors for achievements
extension User {

    @objc(addAchievementsObject:)
    @NSManaged public func addToAchievements(_ value: Achievement)

    @objc(removeAchievementsObject:)
    @NSManaged public func removeFromAchievements(_ value: Achievement)

    @objc(addAchievements:)
    @NSManaged public func addToAchievements(_ values: NSSet)

    @objc(removeAchievements:)
    @NSManaged public func removeFromAchievements(_ values: NSSet)

}

// MARK: Generated accessors for pointTransactions
extension User {

    @objc(addPointTransactionsObject:)
    @NSManaged public func addToPointTransactions(_ value: PointTransaction)

    @objc(removePointTransactionsObject:)
    @NSManaged public func removeFromPointTransactions(_ value: PointTransaction)

    @objc(addPointTransactions:)
    @NSManaged public func addToPointTransactions(_ values: NSSet)

    @objc(removePointTransactions:)
    @NSManaged public func removeFromPointTransactions(_ values: NSSet)

}

extension User : Identifiable {

}
