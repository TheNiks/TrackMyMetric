//
//  MainCoordinatorView.swift
//  TrackMyMetric
//
//  Created by Nikunj Modi on 07/01/26.
//
import SwiftUI


struct MainCoordinatorView: View {
    // This lives here so it doesn't get destroyed when the view swaps
    @StateObject private var onboardingVM = OnboardingViewModel()
    
    var body: some View {
        Group {
            if onboardingVM.isAuthorized {
                DashboardView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .opacity
                    ))
            } else {
                OnboardingView(viewModel: onboardingVM)
                    .transition(.opacity)
            }
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: onboardingVM.isAuthorized)
    }
}
