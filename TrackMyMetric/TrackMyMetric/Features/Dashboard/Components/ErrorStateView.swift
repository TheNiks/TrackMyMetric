import SwiftUI

// MARK: - Error View
struct ErrorStateView: View {
    let message: String
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill").font(.largeTitle).foregroundColor(.orange)
            Text(message).foregroundColor(.white)
            Button("Try Again", action: retry).buttonStyle(.bordered)
        }
    }
}
