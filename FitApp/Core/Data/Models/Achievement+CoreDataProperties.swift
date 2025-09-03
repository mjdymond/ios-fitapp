//
//  Achievement+CoreDataProperties.swift
//  FitApp
//
//  Created by Claude on 09/03/2025.
//
//

import Foundation
import CoreData

extension Achievement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Achievement> {
        return NSFetchRequest<Achievement>(entityName: "Achievement")
    }

    @NSManaged public var achievementDescription: String?
    @NSManaged public var category: String?
    @NSManaged public var iconName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isUnlocked: Bool
    @NSManaged public var pointReward: Int32
    @NSManaged public var progressValue: Double
    @NSManaged public var targetValue: Double
    @NSManaged public var tier: String?
    @NSManaged public var title: String?
    @NSManaged public var unlockedAt: Date?
    @NSManaged public var user: User?

}

extension Achievement : Identifiable {

}