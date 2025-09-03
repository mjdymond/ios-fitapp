//
//  Streak+CoreDataProperties.swift
//  FitApp
//
//  Created by Claude on 09/03/2025.
//
//

import Foundation
import CoreData

extension Streak {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Streak> {
        return NSFetchRequest<Streak>(entityName: "Streak")
    }

    @NSManaged public var bestCount: Int32
    @NSManaged public var createdAt: Date?
    @NSManaged public var currentCount: Int32
    @NSManaged public var id: UUID?
    @NSManaged public var isActive: Bool
    @NSManaged public var lastUpdated: Date?
    @NSManaged public var type: String?
    @NSManaged public var user: User?

}

extension Streak : Identifiable {

}