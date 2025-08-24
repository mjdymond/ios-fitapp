import Foundation
import CoreData

extension Food {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged public var calories: Double
    @NSManaged public var carbs: Double
    @NSManaged public var fat: Double
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var protein: Double
    @NSManaged public var quantity: Double
    @NSManaged public var unit: String?
    @NSManaged public var meals: NSSet?

}

// MARK: Generated accessors for meals
extension Food {

    @objc(addMealsObject:)
    @NSManaged public func addToMeals(_ value: Meal)

    @objc(removeMealsObject:)
    @NSManaged public func removeFromMeals(_ value: Meal)

    @objc(addMeals:)
    @NSManaged public func addToMeals(_ values: NSSet)

    @objc(removeMeals:)
    @NSManaged public func removeFromMeals(_ values: NSSet)

}

extension Food : Identifiable {

}
