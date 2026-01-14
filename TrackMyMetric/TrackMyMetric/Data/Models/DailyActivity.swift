//
//  DailyActivity.swift
//  TrackMyMetric
//
//  Created by Nikunj Modi on 04/01/26.
//

import Foundation
import SwiftData

@Model
final class DailyActivity {
    @Attribute(.unique) var date: Date
    var steps: Int
    var calories: Double
    
    init(date: Date, steps: Int, calories: Double = 0) {
        self.date = Calendar.current.startOfDay(for: date)
        self.steps = steps
        self.calories = calories
    }
}
