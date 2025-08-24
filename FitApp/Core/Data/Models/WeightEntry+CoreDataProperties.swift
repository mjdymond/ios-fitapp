import Foundation
import CoreData

extension WeightEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeightEntry> {
        return NSFetchRequest<WeightEntry>(entityName: "WeightEntry")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var notes: String?
    @NSManaged public var weight: Double
    @NSManaged public var user: User?

}

extension WeightEntry : Identifiable {

}
