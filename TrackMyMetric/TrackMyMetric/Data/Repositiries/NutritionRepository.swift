//
//  NutritionRepository.swift
//  TrackMyMetric
//
//  Created by Nikunj Modi on 04/01/26.
//

import SwiftData

class NutritionRepository {
    private let modelContext: ModelContext
    init(modelContext: ModelContext) { self.modelContext = modelContext }
    
    func logMeal(_ meal: Meal) {
        modelContext.insert(meal)
    }
}
