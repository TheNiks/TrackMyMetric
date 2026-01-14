//
//  Meal.swift
//  TrackMyMetric
//
//  Created by Nikunj Modi on 04/01/26.
//


import Foundation
import SwiftData

@Model
final class Meal {
    var name: String
    var calories: Int
    var protein: Int
    var carbs: Int
    var fat: Int
    var timestamp: Date
    
    init(name: String, calories: Int, protein: Int, carbs: Int, fat: Int) {
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.timestamp = Date()
    }
}

@Model
final class NutritionEntry {
    // Unique identifier for database operations
    @Attribute(.unique) var id: UUID
    
    var name: String
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double
    var timestamp: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        calories: Double,
        protein: Double,
        carbs: Double,
        fat: Double,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.timestamp = timestamp
    }
}
