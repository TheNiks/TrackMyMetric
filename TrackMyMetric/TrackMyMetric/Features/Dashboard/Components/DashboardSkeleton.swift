
import SwiftUI

struct DashboardSkeleton: View {
    @State private var opacity = 0.3
    
    var body: some View {
        VStack(spacing: 20) {
            Circle().fill(.gray.opacity(opacity)).frame(width: 150, height: 150)
            RoundedRectangle(cornerRadius: 20).fill(.gray.opacity(opacity)).frame(height: 200)
            RoundedRectangle(cornerRadius: 20).fill(.gray.opacity(opacity)).frame(height: 100)
        }
        .padding()
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                opacity = 0.6
            }
        }
    }
    
}
