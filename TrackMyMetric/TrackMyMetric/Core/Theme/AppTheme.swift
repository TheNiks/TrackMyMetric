//
//  AppTheme.swift
//  TrackMyMetric
//
//  Created by Nikunj Modi on 04/01/26.
//


import SwiftUI

struct AppTheme {
    static let background = Color(red: 0.1, green: 0.12, blue: 0.25)
    static let cardBackground = Color.white.opacity(0.1)
    static let primaryButton = LinearGradient(
        colors: [Color(red: 0.5, green: 0.5, blue: 1.0), Color(red: 0.4, green: 0.4, blue: 0.9)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let disablePrimaryButton = LinearGradient(
        colors: [.gray, .gray.opacity(0.1)],
        startPoint: .top,
        endPoint: .bottom
    )
    static let accent = Color.white.opacity(0.7)
    static let cyan = Color(red: 0/255, green: 242/255, blue: 255/255)
    static let green = Color(red: 173/255, green: 255/255, blue: 47/255)
    
    // MARK: - Text & UI Elements
    static let textPrimary = Color.white
    static let textSecondary = Color.gray
    static let separator = Color.white.opacity(0.1)
    
    // MARK: - Gradients
    static let progressGradient = LinearGradient(
        colors: [cyan, green],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let chartAreaGradient = LinearGradient(
        colors: [green.opacity(0.3), .clear],
        startPoint: .top,
        endPoint: .bottom
    )
}
