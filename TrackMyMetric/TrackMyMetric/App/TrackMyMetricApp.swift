//
//  TrackMyMetricApp.swift
//  TrackMyMetric
//
//  Created by Nikunj Modi on 04/01/26.
//

import SwiftUI
import SwiftData

@main
struct TrackMyMetricApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            DailyActivity.self,
            NutritionEntry.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear // Or your background color
        
        // Styling for centered (inline) title
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Styling for large title (if you use it elsewhere)
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // Create 7 days of mock data for the Chart
        seedMockData(modelContext: sharedModelContainer.mainContext)
        
    }
    
    func seedMockData(modelContext: ModelContext) {
        // 1. Clear out the old records showing 0
            try? modelContext.delete(model: DailyActivity.self)
            
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())

            // 2. Insert fresh data with random variation
            for i in 0..<7 {
                let targetDate = calendar.date(byAdding: .day, value: -i, to: today)!
                
                // Ensure steps are NOT 0 so the chart has height
                let randomSteps = Int.random(in: 4000...12000)
                
                let activity = DailyActivity(
                    date: targetDate,
                    steps: randomSteps,
                    calories: Double(randomSteps) * 0.04
                )
                modelContext.insert(activity)
            }
            
            try? modelContext.save()
    }
    
    var body: some Scene {
        WindowGroup {
            MainCoordinatorView()
        }
        .modelContainer(sharedModelContainer)
    }
}
