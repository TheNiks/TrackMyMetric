//
//  DashboardView.swift
//  TrackMyMetric
//
//  Created by Nikunj Modi on 04/01/26.
//

import SwiftUI
import Charts
import SwiftData

struct DashboardView: View {
    @State private var stepsToggled = true
    @State private var goalProgress: Double = 0.75
    @State private var isCelebrating = false
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = DashboardViewModel()
    @Query(sort: \DailyActivity.date, order: .forward) var cachedHistory: [DailyActivity]
    
    // State to control the navigation push
    @State private var showNutritionLog = false
    var body: some View {
        
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                switch viewModel.state {
                case .loading:
                    DashboardSkeleton()
                case .empty:
                    EmptyDashboardState()
                case .error(let msg):
                    ErrorStateView(message: msg) {
                        Task { await viewModel.syncHealthData(modelContext: modelContext, hasCache: !cachedHistory.isEmpty) }
                    }
                case .loaded:
                    dashboardContent
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showNutritionLog) {
                NutritionLogView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showNutritionLog = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundStyle(AppTheme.cyan)
                    }
                }
            }
            .task {
                // If we have cached data, show it immediately
                await viewModel.syncHealthData(modelContext: modelContext, hasCache: true)
            }
        }
    }
    
    // MARK: - View Components
    private var  dashboardContent: some View {
        ScrollView {
            VStack(spacing: 25) {
                // MARK: - Summary Ring
                summaryRingSection
                
                // MARK: - Chart Card
                trendChartCard
                
                // MARK: - Insights
                HStack(spacing: 15) {
                    InsightCard(title: "Ahead of Last", value: "+15%", valueColor: AppTheme.green)
                    InsightCard(title: "7-Day Average", value: "8,200 Steps/Day", valueColor: AppTheme.textPrimary)
                }
                .padding(.horizontal)
                
                // MARK: - Action Button
                simulationButton
            }
            .padding(.top, 30)
        }
    }
    
    private var summaryRingSection: some View {
        VStack(spacing: 30) {
            
            HStack(alignment: .center) {
                // LEFT METRIC
                MetricIcon(
                    icon: "heart.fill",
                    title: "Active Calories",
                    value: "580"
                )
                
                Spacer()
                
                // RIGHT METRIC
                MetricIcon(
                    icon: "flame.fill",
                    title: "Best Day",
                    value: "(10K Steps)"
                )
                
                // CENTER RING
                ZStack {
                    Circle()
                        .stroke(AppTheme.separator, lineWidth: 10)
                    
                    Circle()
                        .trim(from: 0, to: goalProgress)
                        .stroke(
                            AppTheme.progressGradient,
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(), value: goalProgress)
                    
                    VStack(spacing: 0) {
                        Text("7,500")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)
                        Text("Steps Goal")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
                .frame(width: 130, height: 130)
                .shadow(color: isCelebrating ? AppTheme.cyan.opacity(0.3) : .clear, radius: 10)
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var trendChartCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("7-Day Trend")
                .font(.headline)
                .foregroundColor(AppTheme.textPrimary)
            
            Chart {
                ForEach(cachedHistory) { activity in
                    // The Line showing the trend
                    LineMark(
                        x: .value("Date", activity.date),
                        y: .value("Steps", activity.steps)
                    )
                    .foregroundStyle(AppTheme.green)
                    .interpolationMethod(.catmullRom)
                    
                    // The Gradient Area underneath
                    AreaMark(
                        x: .value("Date", activity.date),
                        y: .value("Steps", activity.steps)
                    )
                    .foregroundStyle(AppTheme.chartAreaGradient)
                    .interpolationMethod(.catmullRom) // Keep interpolation consistent
                }
            }
            .frame(height: 220)
            // 1. Configure the X-Axis (Dates)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5)).foregroundStyle(.gray.opacity(0.2))
                    AxisValueLabel(format: .dateTime.day().month(), centered: true)
                        .foregroundStyle(.white.opacity(0.7)) // Makes text visible on dark bg
                }
            }
            // 2. Configure the Y-Axis (Values)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5)).foregroundStyle(.gray.opacity(0.2))
                    AxisValueLabel()
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            
            HStack {
                Spacer()
                Text("Steps")
                    .foregroundColor(AppTheme.textSecondary)
                Toggle("", isOn: $stepsToggled)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: AppTheme.cyan))
                Spacer()
            }
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(20)
        .padding(.horizontal)
    }
    
    private var simulationButton: some View {
        Button(action: { simulateGoalReached() }) {
            Text("Simulate Goal reached")
                .font(.headline)
                .foregroundColor(AppTheme.textPrimary)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppTheme.primaryButton)
                .cornerRadius(15)
        }
        .padding(.horizontal)
        .padding(.bottom, 30)
    }
    
    private func simulateGoalReached() {
        let haptic = UIImpactFeedbackGenerator(style: .heavy)
        haptic.impactOccurred()
        // Call the mock function using the view's modelContext
        viewModel.mockData(modelContext: modelContext)
        withAnimation {
            goalProgress = 1.0
            isCelebrating = true
        }
    }
}

#Preview("Dashboard - Active State") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DailyActivity.self, configurations: config)
    
    // Create 7 days of mock data for the Chart
    let calendar = Calendar.current
    for i in 0..<7 {
        let date = calendar.date(byAdding: .day, value: -i, to: Date())!
        let mockActivity = DailyActivity(
            date: date,
            steps: Int.random(in: 4000...12000),
            calories: Double.random(in: 300...800)
        )
        
        container.mainContext.insert(mockActivity)
    }
    
    return NavigationView {
        DashboardView()
    }
    .modelContainer(container)
}
