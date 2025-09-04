import Foundation
import HealthKit

class HealthKitService: ObservableObject {
    private let healthStore = HKHealthStore()
    
    @Published var isAuthorized = false
    @Published var authorizationError: Error?
    
    // Health data types we want to read
    private let readTypes: Set<HKObjectType> = {
        var types: Set<HKObjectType> = []
        
        // Body measurements
        if let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass) {
            types.insert(bodyMass)
        }
        if let height = HKObjectType.quantityType(forIdentifier: .height) {
            types.insert(height)
        }
        
        // Activity data
        if let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) {
            types.insert(activeEnergy)
        }
        if let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount) {
            types.insert(stepCount)
        }
        
        // Workout data
        types.insert(HKObjectType.workoutType())
        
        return types
    }()
    
    // Health data types we want to write
    private let writeTypes: Set<HKSampleType> = {
        var types: Set<HKSampleType> = []
        
        // Body measurements
        if let bodyMass = HKSampleType.quantityType(forIdentifier: .bodyMass) {
            types.insert(bodyMass)
        }
        
        // Workout data
        types.insert(HKObjectType.workoutType())
        
        return types
    }()
    
    init() {
        checkAuthorizationStatus()
    }
    
    // MARK: - Authorization
    
    func requestAuthorization() async {
        guard HKHealthStore.isHealthDataAvailable() else {
            await MainActor.run {
                self.authorizationError = HealthKitError.notAvailable
            }
            return
        }
        
        do {
            try await healthStore.requestAuthorization(toShare: writeTypes, read: readTypes)
            await MainActor.run {
                self.isAuthorized = true
                self.authorizationError = nil
            }
        } catch {
            await MainActor.run {
                self.authorizationError = error
                self.isAuthorized = false
            }
        }
    }
    
    private func checkAuthorizationStatus() {
        guard HKHealthStore.isHealthDataAvailable() else {
            self.authorizationError = HealthKitError.notAvailable
            return
        }
        
        // Check if we have authorization for body mass (weight)
        if let bodyMassType = HKObjectType.quantityType(forIdentifier: .bodyMass) {
            let status = healthStore.authorizationStatus(for: bodyMassType)
            self.isAuthorized = (status == .sharingAuthorized)
        }
    }
    
    // MARK: - Reading Data
    
    func fetchLatestWeight() async throws -> Double? {
        guard let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else {
            throw HealthKitError.invalidType
        }
        
        let descriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let _ = HKSampleQuery(
            sampleType: weightType,
            predicate: nil,
            limit: 1,
            sortDescriptors: [descriptor]
        ) { @Sendable _, samples, error in
            // Handle in completion
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: weightType,
                predicate: nil,
                limit: 1,
                sortDescriptors: [descriptor]
            ) { @Sendable _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let sample = samples?.first as? HKQuantitySample else {
                    continuation.resume(returning: nil)
                    return
                }
                
                let weightInPounds = sample.quantity.doubleValue(for: .pound())
                continuation.resume(returning: weightInPounds)
            }
            
            healthStore.execute(query)
        }
    }
    
    func fetchWeightData(from startDate: Date, to endDate: Date) async throws -> [HKQuantitySample] {
        guard let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else {
            throw HealthKitError.invalidType
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: .strictStartDate
        )
        
        let descriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: weightType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [descriptor]
            ) { @Sendable _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                let weightSamples = samples as? [HKQuantitySample] ?? []
                continuation.resume(returning: weightSamples)
            }
            
            healthStore.execute(query)
        }
    }
    
    // MARK: - Writing Data
    
    func saveWeight(_ weight: Double, date: Date = Date()) async throws {
        guard let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else {
            throw HealthKitError.invalidType
        }
        
        let weightQuantity = HKQuantity(unit: .pound(), doubleValue: weight)
        let weightSample = HKQuantitySample(
            type: weightType,
            quantity: weightQuantity,
            start: date,
            end: date
        )
        
        try await healthStore.save(weightSample)
    }
    
    func saveWorkout(
        activityType: HKWorkoutActivityType,
        startDate: Date,
        endDate: Date,
        duration: TimeInterval,
        totalEnergyBurned: Double? = nil
    ) async throws {
        let metadata: [String: Any] = [:]
        
        let energyBurned: HKQuantity?
        if let totalEnergyBurned = totalEnergyBurned {
            energyBurned = HKQuantity(unit: .kilocalorie(), doubleValue: totalEnergyBurned)
        } else {
            energyBurned = nil
        }
        
        let workout = HKWorkout(
            activityType: activityType,
            start: startDate,
            end: endDate,
            duration: duration,
            totalEnergyBurned: energyBurned,
            totalDistance: nil,
            metadata: metadata
        )
        
        try await healthStore.save(workout)
    }
}

// MARK: - Error Types

enum HealthKitError: LocalizedError {
    case notAvailable
    case invalidType
    case authorizationDenied
    
    var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "HealthKit is not available on this device."
        case .invalidType:
            return "Invalid HealthKit data type."
        case .authorizationDenied:
            return "HealthKit authorization was denied."
        }
    }
}
