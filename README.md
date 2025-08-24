# FitApp - iOS Fitness Tracking App

A native iOS fitness app built with SwiftUI that helps users track workouts, monitor weight loss, and plan meals. Designed with a clean, iOS-native interface similar to Strava.

## ✨ Features

### MVP Features
- **User Profile & Authentication**: Create and manage user profiles with fitness goals
- **Workout Tracking**: Track workouts with exercise library, sets, reps, and timer
- **Weight Tracking**: Monitor weight progress with charts and visualization
- **Meal Planning**: Log meals and track nutrition with calorie counting
- **Dashboard**: Overview of daily activity, progress, and quick actions
- **HealthKit Integration**: Sync data with Apple Health

### Technical Features
- Native iOS SwiftUI interface
- Core Data for local storage
- HealthKit integration for health data
- Charts framework for data visualization
- MVVM architecture
- iOS 16.0+ support

## 🏗️ Project Structure

```
FitApp/
├── App/
│   ├── FitAppApp.swift          # Main app entry point
│   └── ContentView.swift        # Root view with tab navigation
├── Core/
│   ├── Data/CoreData/           # Core Data stack and models
│   └── Services/                # HealthKit and other services
├── Features/
│   ├── Dashboard/               # Home screen and overview
│   ├── Workouts/               # Workout tracking and history
│   ├── Weight/                 # Weight tracking and charts
│   ├── Meals/                  # Meal planning and nutrition
│   └── Profile/                # User profile and settings
└── Resources/
    ├── Info.plist             # App configuration
    └── FitApp.entitlements    # HealthKit permissions
```

## 🚀 Getting Started

### Prerequisites
- macOS with Xcode 15+
- iOS Developer account (for HealthKit)
- iPhone for testing (recommended)

### Setup Instructions

1. **Open the Project**
   ```bash
   cd /Users/marcosdymond/fitapp
   open FitApp.xcodeproj
   ```

2. **Configure Signing**
   - Select the FitApp target in Xcode
   - Go to "Signing & Capabilities"
   - Set your Development Team
   - Update Bundle Identifier if needed

3. **HealthKit Setup**
   - The app includes HealthKit entitlements
   - Privacy usage descriptions are configured in Info.plist
   - Test on a physical device (HealthKit doesn't work in simulator)

4. **Build and Run**
   - Select your target device
   - Press `Cmd + R` to build and run

### First Launch
1. Create your user profile through the Profile tab
2. Grant HealthKit permissions when prompted
3. Start tracking your first workout!

## 📱 App Screens

### Dashboard
- Daily overview of workouts, weight, and nutrition
- Quick action buttons for common tasks
- Progress highlights

### Workouts
- Exercise library with common movements
- Live workout tracking with timer
- Workout history and statistics

### Weight Tracking
- Weight entry with date selection
- Progress charts (1W, 1M, 3M, 1Y views)
- BMI tracking and goal progress

### Meals
- Meal logging by type (breakfast, lunch, dinner, snacks)
- Food database for nutrition lookup
- Daily calorie and nutrition tracking

### Profile
- User information and goals
- Health data settings
- App preferences

## 🔧 Development

### Architecture
- **MVVM Pattern**: Views, ViewModels, and Models separation
- **Core Data**: Local data persistence
- **SwiftUI**: Declarative UI framework
- **HealthKit**: Health data integration

### Key Components
- `PersistenceController`: Core Data stack management
- `HealthKitService`: HealthKit integration and permissions
- Feature-based view organization
- Reusable UI components

### Data Models
- **User**: Profile and preferences
- **Workout**: Exercise sessions
- **Exercise**: Individual movements with sets
- **WeightEntry**: Weight tracking records
- **Meal**: Nutrition tracking
- **Food**: Nutrition database

## 🎯 MVP Development Status

### ✅ Completed
- [x] Project setup and structure
- [x] Core Data models and stack
- [x] Basic UI for all main features
- [x] Tab navigation structure
- [x] HealthKit service foundation

### 🔄 In Progress
- Dashboard functionality
- Workout tracking logic
- Weight charts implementation
- Meal logging system
- Profile management

### 📋 Pending
- Authentication system
- Advanced HealthKit integration
- Data export functionality
- Performance optimization
- Testing suite

## 🚀 Future Enhancements

### Post-MVP Features
- Social features and friend challenges
- Advanced analytics and insights
- Workout programs and templates
- Barcode scanning for food
- Apple Watch companion app
- Cloud sync across devices
- Nutrition coaching
- Equipment integration

### Technical Improvements
- Unit and UI test coverage
- Performance monitoring
- Accessibility improvements
- Internationalization
- Advanced error handling

## 📄 License

This project is a private development project. All rights reserved.

## 🤝 Contributing

This is currently a solo project. If you'd like to contribute or have suggestions, please reach out.

---

**Note**: This app requires physical iOS device testing for HealthKit functionality. The simulator does not support HealthKit features.
