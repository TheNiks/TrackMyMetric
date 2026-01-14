import Foundation

struct MockData {
    static var activityHistory: [DailyActivity] {
        let calendar = Calendar.current
        return (0..<7).map { i in
            DailyActivity(
                date: calendar.date(byAdding: .day, value: -i, to: Date())!,
                steps: Int.random(in: 4000...12000),
                calories: Double.random(in: 300...800)
            )
        }
    }
    
    static var meals: [Meal] {
        [
            Meal(name: "Avocado Toast", calories: 350, protein: 12, carbs: 40, fat: 22),
            Meal(name: "Grilled Chicken Salad", calories: 450, protein: 40, carbs: 15, fat: 18),
            Meal(name: "Protein Shake", calories: 180, protein: 30, carbs: 5, fat: 2)
        ]
    }
}
