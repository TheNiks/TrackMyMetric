import SwiftUI

struct NutritionRowView: View {
    let meal: NutritionEntry
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 48, height: 48)
                .overlay(Image(systemName: "target").foregroundColor(.gray))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.name)
                    .font(.body.bold())
                    .foregroundColor(.white)
                Text("\(Int(meal.calories)) kcal | \(Int(meal.protein))P \(Int(meal.carbs))C")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
}
