//
//  HealthKitManager.swift
//  TrackMyMetric
//
//  Created by Nikunj Modi on 04/01/26.
//

import HealthKit

enum HealthError: Error {
    case unavailable, denied
}

class HealthKitManager {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()
    
    func requestAuthorization() async throws -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else { throw HealthError.unavailable }
        let readTypes: Set<HKObjectType> = [
                HKObjectType.quantityType(forIdentifier: .stepCount)!,
                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
            ]
        do {
            try await healthStore.requestAuthorization(toShare: [], read: readTypes)
            return await checkActualAuthorizationStatus()
        } catch {
            return false
        }
    }
    
    private func checkActualAuthorizationStatus() async -> Bool {
    #if targetEnvironment(simulator)
        return true
    #else
        let stepType = HKQuantityType(.stepCount)
        let status = healthStore.authorizationStatus(for: stepType)
        
        switch status {
        case .sharingAuthorized:
            return true
        case .sharingDenied, .notDetermined:
            return false
        @unknown default:
            return false
        }
    #endif
    }
    
    func requestPermissions() async -> Bool {
        let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.activeEnergyBurned)]
        do {
            try await healthStore.requestAuthorization(toShare: [], read: types)
            return true
        } catch { return false }
    }
    
    func fetchTodaySteps() async -> Int {
        guard let type = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return 0 }
        let predicate = HKQuery.predicateForSamples(withStart: Date().startOfDay, end: Date(), options: .strictStartDate)
        
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
                let sum = result?.sumQuantity()?.doubleValue(for: .count())
                continuation.resume(returning: Int(sum ?? 0))
            }
            healthStore.execute(query)
        }
    }
    
    func fetchLastSevenDays() async throws -> [Date: (steps: Double, calories: Double)] {
        let stepType = HKQuantityType(.stepCount)
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let startDate = calendar.date(byAdding: .day, value: -6, to: today)!
        
        let interval = DateComponents(day: 1)
        let query = HKStatisticsCollectionQuery(
            quantityType: stepType,
            quantitySamplePredicate: nil,
            options: .cumulativeSum,
            anchorDate: today,
            intervalComponents: interval
        )
        
        return try await withCheckedThrowingContinuation { continuation in
            query.initialResultsHandler = { _, results, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                var totals = [Date: (steps: Double, calories: Double)]()
                results?.enumerateStatistics(from: startDate, to: Date()) { stats, _ in
                    let steps = stats.sumQuantity()?.doubleValue(for: .count()) ?? 0
                    totals[stats.startDate] = (steps, 0) // Expand here for calories
                }
                continuation.resume(returning: totals)
            }
            healthStore.execute(query)
        }
    }
    
    func startObservingSteps(updateHandler: @escaping (Double) -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        // 1. Create the Observer Query (Triggers when data changes)
        let observerQuery = HKObserverQuery(sampleType: stepType, predicate: nil) { _, completionHandler, error in
            if let error = error {
                print("Observation error: \(error.localizedDescription)")
                return
            }
            
            // 2. Fetch the actual data when notified
            self.fetchCurrentDaySteps { totalSteps in
                updateHandler(totalSteps)
                completionHandler()
            }
        }
        healthStore.execute(observerQuery)
    }
}

extension HealthKitManager {
    func fetchCurrentDaySteps(completion: @escaping (Double) -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        // Define "Today" (from 00:00:00 to now)
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepType,
                                     quantitySamplePredicate: predicate,
                                     options: .cumulativeSum) { _, result, error in
            
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            
            // Convert to Double (steps are counted in units of 'count')
            let totalSteps = sum.doubleValue(for: HKUnit.count())
            completion(totalSteps)
        }
        
        healthStore.execute(query)
    }
}
