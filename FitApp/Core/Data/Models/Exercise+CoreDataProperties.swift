import Foundation
import CoreData

extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var category: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var sets: NSSet?
    @NSManaged public var workout: Workout?

}

// MARK: Generated accessors for sets
extension Exercise {

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: ExerciseSet)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: ExerciseSet)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSSet)

}

extension Exercise : Identifiable {

}
