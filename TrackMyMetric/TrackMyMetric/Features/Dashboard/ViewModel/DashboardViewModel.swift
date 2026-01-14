import SwiftUI
import SwiftData
import Observation // Required for @Observable

@MainActor
@Observable // <--- Add this macro
class DashboardViewModel {
    // These no longer need @Published
    var stepsToday = 0
    var state: State = .loading
    var lastSync: Date = Date()
    
    enum State: Equatable{
        case loading
        case empty
        case loaded
        case error(String)
    }
    
    private let healthManager = HealthKitManager()
    
    func syncHealthData(modelContext: ModelContext, hasCache: Bool) async {
        // Immediate switch if cache exists
        if hasCache {
            self.state = .loaded
            return
        }
        
        do {
            _ = try await healthManager.requestAuthorization()
            let dailyData = try await healthManager.fetchLastSevenDays()
            
            let totalSteps = dailyData.values.reduce(0.0) { $0 + $1.steps }
            
            // Logic check: if data is returned but all are 0, we show empty
            if dailyData.isEmpty || (totalSteps == 0 && !hasCache) {
                self.state = .empty
                return
            }
            
            for (date, stepsTuple) in dailyData {
                let activity = DailyActivity(date: date, steps: Int(stepsTuple.steps))
                modelContext.insert(activity)
            }
            
            try modelContext.save()
            // This will now trigger a UI refresh!
            self.state = .loaded
            
        } catch {
            if !hasCache {
                self.state = .error("Health access denied.")
            }
        }
    }
    
    func mockData(modelContext: ModelContext) {
        
        // Create 7 days of mock data for the Chart
        let calendar = Calendar.current
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -i, to: Date())!
            let mockActivity = DailyActivity(
                date: date,
                steps: Int.random(in: 4000...12000),
                calories: Double.random(in: 300...800)
            )
            modelContext.insert(mockActivity)
        }
        
        do {
            try modelContext.save()
            // Force state change AFTER save
            self.state = .loaded
        } catch {
            print("Failed to save: \(error)")
        }
    }
    
    func startLiveTracking(modelContext: ModelContext) {
        healthManager.startObservingSteps { [weak self] newStepCount in
            Task { @MainActor in
                self?.stepsToday = Int(newStepCount)
                self?.lastSync = Date()
                
                // Update SwiftData for the current day's record
                self?.updatePersistentStore(steps: Int(newStepCount), context: modelContext)
            }
        }
    }
    
    private func updatePersistentStore(steps: Int, context: ModelContext) {
        let today = Calendar.current.startOfDay(for: Date())
        
        // Check if record exists, else create it
        let descriptor = FetchDescriptor<DailyActivity>(
            predicate: #Predicate { $0.date == today }
        )
        
        if let existing = try? context.fetch(descriptor).first {
            existing.steps = steps
        } else {
            context.insert(DailyActivity(date: today, steps: steps))
        }
        
        try? context.save()
    }
}
