//
//  PointTransaction+CoreDataProperties.swift
//  FitApp
//
//  Created by Claude on 09/03/2025.
//
//

import Foundation
import CoreData

extension PointTransaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PointTransaction> {
        return NSFetchRequest<PointTransaction>(entityName: "PointTransaction")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var points: Int32
    @NSManaged public var source: String?
    @NSManaged public var transactionDescription: String?
    @NSManaged public var type: String?
    @NSManaged public var user: User?

}

extension PointTransaction : Identifiable {

}