//
//  NutritionViewModel.swift
//  TrackMyMetric
//
//  Created by Nikunj Modi on 04/01/26.
//


import SwiftUI
import SwiftData
import Observation

@Observable
class NutritionLogViewModel {
    // Form State
    var foodName: String = ""
    var calories: String = ""
    var protein: String = ""
    var carbs: String = ""
    var fat: String = ""
    
    // UI State
    var isShowingAddSheet = false
    var isShowingScanner = false
    
    // Validation logic (SOLID: Single Responsibility)
    var isFormValid: Bool {
        let hasName = !foodName.trimmingCharacters(in: .whitespaces).isEmpty
        let hasCalories = Double(calories) != nil
        return hasName && hasCalories
    }
    
    func resetForm() {
        foodName = ""
        calories = ""
        protein = ""
        carbs = ""
        fat = ""
    }
}
