//
//  Challenge+CoreDataProperties.swift
//  FitApp
//
//  Created by Claude on 09/03/2025.
//
//

import Foundation
import CoreData

extension Challenge {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Challenge> {
        return NSFetchRequest<Challenge>(entityName: "Challenge")
    }

    @NSManaged public var challengeDescription: String?
    @NSManaged public var completedAt: Date?
    @NSManaged public var createdAt: Date?
    @NSManaged public var currentValue: Double
    @NSManaged public var expiresAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var pointReward: Int32
    @NSManaged public var targetValue: Double
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var user: User?

}

extension Challenge : Identifiable {

}