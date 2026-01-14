import SwiftUI
import SwiftData

struct AddMealSheet: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: NutritionLogViewModel
    
    var body: some View {
        ZStack {
            Color(red: 0.15, green: 0.15, blue: 0.18).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("New Entry").font(.title3.bold()).foregroundColor(.white)
                
                VStack(spacing: 15) {
                    CustomTextField(placeholder: "Food name", text: $viewModel.foodName)
                    
                    HStack {
                        CustomTextField(placeholder: "Calories", text: $viewModel.calories)
                            .keyboardType(.decimalPad)
                        
                        Button(action: { viewModel.isShowingScanner = true }) {
                            Image(systemName: "camera.fill")
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                    
                    HStack {
                        CustomTextField(placeholder: "Protein (g)", text: $viewModel.protein)
                        CustomTextField(placeholder: "Carbs (g)", text: $viewModel.carbs)
                        CustomTextField(placeholder: "Fat (g)", text: $viewModel.fat)
                    }
                    .keyboardType(.decimalPad)
                }
                
                Button(action: saveMeal) {
                    Text("Save")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isFormValid ? AppTheme.primaryButton : AppTheme.disablePrimaryButton)
                        .foregroundColor(AppTheme.textPrimary)
                        .cornerRadius(25)
                }
                .disabled(!viewModel.isFormValid)
                
                Spacer()
            }
            .padding(25)
        }
    }
    
    private func saveMeal() {
        let entry = NutritionEntry(
            name: viewModel.foodName,
            calories: Double(viewModel.calories) ?? 0,
            protein: Double(viewModel.protein) ?? 0,
            carbs: Double(viewModel.carbs) ?? 0,
            fat: Double(viewModel.fat) ?? 0
        )
        context.insert(entry)
        viewModel.resetForm()
        dismiss()
    }
}

// Reusable styling for fields based on your screenshot
struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.gray))
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1)))
            .foregroundColor(.white)
    }
}
