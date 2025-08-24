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
    @NSManaged public var meals: NSSet?
    @NSManaged public var weightEntries: NSSet?
    @NSManaged public var workouts: NSSet?

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

extension User : Identifiable {

}
