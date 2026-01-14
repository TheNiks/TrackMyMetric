import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Unlock Your\nFull Potential")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        FeatureRow(text: "Seamless Health Sync")
                        FeatureRow(text: "Personalized Insights")
                        FeatureRow(text: "Achieve Your Goals")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 40)
                
                Spacer()
                
                // Status Card
                VStack(spacing: 20) {
                    if !viewModel.isAuthorized {
                        StatusBox(
                            icon: "lock.fill",
                            title: "Limited Mode Active",
                            description: "Connect HealthKit to unlock insights, and goal tracking"
                        )
                    }
                    // Permission Toggle Card
                    VStack(spacing: 15) {
                        Text("Connect Health to unlock full features, insights, and goal tracking")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        
                        ToggleRow(label: "Calories", isOn: .constant(false))
                        
                        Button("Continue in Limited Mode") {
                            // Handle bypass
                        }
                        .font(.footnote)
                        .foregroundColor(.gray)
                    }
                    .padding()
                    .background(AppTheme.cardBackground)
                    .cornerRadius(20)
                }
                
                // Primary Action Button
                // The Slidable Button at the bottom
                SlidableConnectButton(resetTrigger: $viewModel.resetTrigger) {
                    viewModel.authorize()
                    // Haptic feedback for the "Click" feeling
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                }
                .padding(.bottom, 30)            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    // We wrap it in a NavigationView/NavigationStack
    // to see how it sits within the safe areas.
    let vm = OnboardingViewModel()
    OnboardingView(viewModel: vm)
        .preferredColorScheme(.light) // Matches the screenshot's dark theme
}

// MARK: - Design Mockup
/// This allows you to see how the 'Authorized' state looks
/// in the preview without having a real device.
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // State 1: Locked (Initial)
            let vm = OnboardingViewModel()
            OnboardingView(viewModel: vm)
                .previewDisplayName("Limited Mode")
            
            // State 2: Authorized (Success)
            OnboardingView_Authorized()
                .previewDisplayName("Authorized Mode")
        }
        .preferredColorScheme(.dark)
    }
}

// A slight variation to test the "Success" UI state
struct OnboardingView_Authorized: View {
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            Text("Health Connected! ✅")
                .foregroundColor(.white)
                .font(.headline)
        }
    }
}

