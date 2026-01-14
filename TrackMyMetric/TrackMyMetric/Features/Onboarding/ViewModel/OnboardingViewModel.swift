import SwiftUI
import Combine

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var isAuthorized = false
    @Published var resetTrigger = false
    
    init() {
        checkCurrentStatus()
    }
    
    func checkCurrentStatus() {
        // 1. Check if we have previously successfully authorized in this app
        if UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") {
            self.isAuthorized = true
        }
    }
    
    func authorize() {
        Task {
            do {
                let success = try await HealthKitManager.shared.requestAuthorization()
                if success {
                    // 2. Save the state so the user skips onboarding next time
                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                    
                    HapticManager.shared.notification(.success)
                    isAuthorized = true
                } else {
                    resetTrigger.toggle()
                    UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
                }
            } catch {
                HapticManager.shared.notification(.error)
                print("Health access denied.")
            }
            
        }
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

