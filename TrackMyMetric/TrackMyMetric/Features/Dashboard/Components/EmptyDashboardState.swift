
import SwiftUI

struct EmptyDashboardState: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "figure.walk.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.linearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                .symbolEffect(.bounce, options: .repeating)
            
            VStack(spacing: 8) {
                Text("Waiting for Data")
                    .font(.title3.bold())
                Text("Go for a quick walk or sync your Apple Watch to see your stats here.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(minHeight: 400)
    }
}
