# 📊 TrackMyMetric

**TrackMyMetric** is a clean, performant iOS fitness and nutrition tracker built with **SwiftUI** and **SwiftData**. It bridges the gap between your daily movement and your fueling, syncing seamlessly with **HealthKit** to provide a unified view of your health journey.

---

## ✨ Features

* **Integrated Dashboard**
  High-level overview of your daily activity rings and weekly trends.

* **HealthKit Sync**
  Native integration with Apple Health for steps, calories, and exercise minutes.

* **Nutrition Logging**
  Simple, local CRUD operations to track meals and macros throughout the day.

* **Modern UI**
  Built with a custom theme engine, haptic feedback, and fluid SwiftUI animations.

* **Offline First**
  Powered by SwiftData for lightning-fast local persistence and reliability.

---

## 🏗️ Architecture

The project follows a **Clean MVVM (Model–View–ViewModel)** architecture with a repository layer to decouple data sources from the UI.

```text
TrackMyMetric/
 ├── 📱 App          # Lifecycle, DI, and Navigation Coordination
 ├── 🎨 Core         # Design System (AppTheme) & Global Extensions
 ├── 💾 Data         # SwiftData Models, Repositories, & Service Layers
 ├── 🚀 Features     # Scoped Modules (Onboarding, Dashboard, Nutrition)
 └── 🧪 Previews     # Mock data for rapid UI iteration
```

This structure keeps features modular, testable, and easy to scale as new metrics or capabilities are added.

---

## 🛠️ Tech Stack

| Component    | Technology / Framework      |
| ------------ | --------------------------- |
| UI           | SwiftUI                     |
| Database     | SwiftData                   |
| Integrations | HealthKit                   |
| Navigation   | Coordinator Pattern         |
| Feedback     | CoreHaptics / HapticManager |

---

## 🚀 Getting Started

### Prerequisites

* **Xcode 15.0+**
* **iOS 17.0+** (required for SwiftData)
* A **physical device** for testing HealthKit features

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/TrackMyMetric.git
   ```

2. Open `TrackMyMetric.xcodeproj` in Xcode.

3. Ensure **HealthKit** capability is enabled in the project settings.

4. Build and run on a physical device.

---

## 📸 Previews

> **Tip**
> Use the `Preview Content` folder to explore the dashboard and nutrition views with populated mock data—no real HealthKit profile required.

* 📊 Dashboard
* 🍎 Nutrition Log
* 👋 Onboarding
* ✨ Ring Progress
* 🥗 Daily Macros
* ⚡ Quick Setup

---

📁 Project Structure
```
TrackMyMetric/
├── App/
│   ├── TrackMyMetricApp.swift
│   │   └── Application entry point
│   │       • SwiftUI App lifecycle
│   │       • SwiftData model container setup
│   └── MainCoordinatorView.swift
│       └── Root navigation & feature coordination
│
├── Core/
│   ├── Theme/
│   │   └── AppTheme.swift
│   │       └── Centralized colors, fonts, gradients & UI constants
│   │
│   └── Extensions/
│       └── Date+Ext.swift
│           └── Calendar & date helpers for HealthKit queries
│
├── Data/
│   ├── Models/
│   │   ├── DailyActivity.swift
│   │   │   └── SwiftData @Model for activity metrics
│   │   └── Meal.swift
│   │       └── SwiftData @Model for nutrition logging
│   │
│   ├── Repositories/
│   │   ├── ActivityRepository.swift
│   │   │   └── Sync layer: HealthKit ↔ Local cache
│   │   └── NutritionRepository.swift
│   │       └── Local CRUD operations for meals
│   │
│   └── Services/
│       ├── HealthKitManager.swift
│       │   └── HealthKit permissions, queries & data normalization
│       └── HapticManager.swift
│           └── Centralized haptic / taptic feedback handling
│
├── Features/
│   ├── Onboarding/
│   │   ├── Views/
│   │   │   └── OnboardingView.swift
│   │   └── ViewModels/
│   │       └── OnboardingViewModel.swift
│   │
│   ├── Dashboard/
│   │   ├── Views/
│   │   │   ├── DashboardView.swift
│   │   │   └── Components/
│   │   │       ├── ActivityRing.swift
│   │   │       └── WeeklyChartView.swift
│   │   └── ViewModels/
│   │       └── DashboardViewModel.swift
│   │
│   └── Nutrition/
│       ├── Views/
│       │   ├── NutritionLogView.swift
│       │   └── AddMealModal.swift
│       └── ViewModels/
│           └── NutritionViewModel.swift
│
└── Preview Content/
    └── Mock data & assets for SwiftUI previews
```

---

## 🤝 Contributing

Contributions are welcome! 🎉
Please open an issue or submit a pull request if you have ideas for:

* New health metrics
* UI/UX enhancements
* Performance or architectural improvements

---

## 🎥 App Demo

1. https://github.com/TheNiks/TrackMyMetric/blob/480821dcac4b9f28f0ac144bfe889bc9acc73424/assets/Walkthrough.mp4
2. https://github.com/TheNiks/TrackMyMetric/blob/4bc0767e8c1dc8497ad1929d049f3bf6a532c28b/assets/WaitingForData.mov
3. https://github.com/TheNiks/TrackMyMetric/blob/0a0828d11955362e0a36bb65d720f9a9eb67f927/assets/HealthAccess.mov

---

## 📄 License

This project is licensed under the **MIT License**.

## License

GoHub is free for personal, educational, and non-commercial use.

Commercial or business use requires explicit permission from the author.
See the LICENSE file for details.
