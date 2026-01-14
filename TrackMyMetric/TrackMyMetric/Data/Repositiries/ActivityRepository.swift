//
//  ActivityRepository.swift
//  TrackMyMetric
//
//  Created by Nikunj Modi on 04/01/26.
//

import SwiftData
import Foundation

class ActivityRepository {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    @MainActor
    func syncToday() async -> DailyActivity {
        let steps = await HealthKitManager.shared.fetchTodaySteps()
        let activity = DailyActivity(date: Date().startOfDay, steps: steps, calories: 0)
        modelContext.insert(activity)
        return activity
    }
}

