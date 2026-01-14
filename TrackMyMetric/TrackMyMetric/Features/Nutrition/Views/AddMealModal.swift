//
//  AddMealModal.swift
//  TrackMyMetric
//
//  Created by Nikunj Modi on 04/01/26.
//

import SwiftUI
import SwiftData

struct AddMealModal: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @State var name = ""
    @State var cals = ""

    var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Calories", text: $cals).keyboardType(.numberPad)
            Button("Save") {
                let meal = Meal(name: name, calories: Int(cals) ?? 0, protein: 0, carbs: 0, fat: 0)
                context.insert(meal)
                dismiss()
            }
        }
    }
}
