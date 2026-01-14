import SwiftUI

// MARK: - Subviews
struct FeatureRow: View {
    let text: String
    var body: some View {
        HStack(spacing: 12) {
            Circle().fill(AppTheme.accent).frame(width: 6, height: 6)
            Text(text)
                .font(.body)
                .foregroundColor(AppTheme.accent)
        }
    }
}

struct StatusBox: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).fontWeight(.bold)
                Text(description)
                    .font(.footnote)
                    .opacity(0.8)
            }
        }
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.cardBackground)
        .cornerRadius(16)
    }
}

struct ToggleRow: View {
    let label: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Label(label, systemImage: "heart.fill")
                .foregroundColor(.white)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.blue)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}
