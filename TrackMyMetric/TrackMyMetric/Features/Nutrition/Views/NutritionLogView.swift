//
//  NutritionLogView.swift
//  TrackMyMetric
//
//  Created by Nikunj Modi on 04/01/26.
//

import SwiftUI
import SwiftData

struct NutritionLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \NutritionEntry.timestamp, order: .reverse) var meals: [NutritionEntry]
    @State private var viewModel = NutritionLogViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        //healthKitWarning
                        
                        // Action Button
                        Button(action: { viewModel.isShowingAddSheet = true }) {
                            Label("Log New Meal", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(AppTheme.textPrimary)
                                .background(AppTheme.primaryButton)
                                .cornerRadius(16)
                        }
                        
                        quickAddHeader
                        
                        mealListSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Log meal")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.isShowingAddSheet) {
                AddMealSheet(viewModel: viewModel)
                    .presentationDetents([.medium, .large])
            }
        }
    }

    private var healthKitWarning: some View {
        HStack {
            Text("HealthKit Unavailable. Please check permissions")
                .font(.caption)
            Spacer()
        }
        .padding()
        .background(Color.red.opacity(0.2))
        .cornerRadius(12)
        .foregroundColor(.orange)
    }
    
    private var quickAddHeader: some View {
        HStack {
            Image(systemName: "figure.mixed.cardio")
            Text("Quick Add Macros")
                .font(.headline)
        }
        .foregroundColor(.white)
    }

    private var mealListSection: some View {
        VStack(spacing: 12) {
            if meals.isEmpty {
                ContentUnavailableView("No meals yet", systemImage: "fork.knife", description: Text("Start logging to see your history."))
                    .foregroundStyle(.secondary)
            } else {
                ForEach(meals) { meal in
                    NutritionRowView(meal: meal)
                }
            }
        }
    }
}


#Preview("Nutrition Log - Dark Mode") {
    // 1. Create a schema with your models
    let schema = Schema([NutritionEntry.self])
    
    // 2. Configure an in-memory container (prevents saving to disk)
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: [config])
    
    // 3. Add mock data so the list isn't empty in the preview
    let mockEntries = [
        NutritionEntry(name: "Veg. Salad", calories: 580, protein: 46, carbs: 12, fat: 15),
        NutritionEntry(name: "Protein Shake", calories: 180, protein: 30, carbs: 5, fat: 2),
        NutritionEntry(name: "Avocado Toast", calories: 350, protein: 10, carbs: 24, fat: 18)
    ]
    
    for entry in mockEntries {
        container.mainContext.insert(entry)
    }
    
    return NutritionLogView()
        .modelContainer(container)
        .preferredColorScheme(.dark) // Matches your screenshot's aesthetic
}

#Preview("Empty State") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: NutritionEntry.self, configurations: config)
    
    return NutritionLogView()
        .modelContainer(container)
        .preferredColorScheme(.dark)
}
