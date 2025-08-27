# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

FitApp is a native iOS fitness tracking application built with SwiftUI, similar to Strava. It provides workout tracking, weight monitoring, meal planning, and health data integration through HealthKit.

## Development Commands

### Build and Run
```bash
# Open the Xcode project
open FitApp.xcodeproj

# Build and run through Xcode (Cmd+R)
# No command-line build tools - this is a native iOS project
```

### Testing
- **Unit Tests**: Not yet implemented
- **UI Tests**: Not yet implemented  
- **Device Testing**: Required for HealthKit functionality (simulator doesn't support HealthKit)
- **Recommended Test Device**: iPhone 15 Pro (iOS 16.0+)

### Project Requirements
- **Xcode**: 15.0+
- **iOS Deployment Target**: 16.0+
- **macOS**: Required for iOS development
- **Apple Developer Account**: Needed for HealthKit entitlements and device testing

## Architecture Overview

### Core Architecture Pattern
- **UI Framework**: SwiftUI with MVVM pattern
- **Data Persistence**: Core Data stack
- **Health Integration**: HealthKit service layer
- **Navigation**: Tab-based architecture with 5 main sections

### Key Architectural Components

#### Data Layer
- **PersistenceController**: Manages Core Data stack (`FitApp/Core/Data/CoreData/PersistenceController.swift:33`)
- **Core Data Models**: Auto-generated entities with manual class extensions in `FitApp/Core/Data/Models/`
- **Data Model**: `FitAppDataModel.xcdatamodeld` contains 7 entities (User, Workout, Exercise, ExerciseSet, WeightEntry, Meal, Food)

#### Service Layer  
- **HealthKitService**: Handles all Apple Health integration (`FitApp/Core/Services/HealthKitService.swift:4`)
- Supports reading/writing weight, workout, and activity data
- Async/await pattern for HealthKit operations

#### Feature Organization
```
Features/
├── Dashboard/     # Home overview screen
├── Workouts/      # Exercise tracking and history  
├── Weight/        # Weight tracking with charts
├── Meals/         # Nutrition and meal planning
└── Profile/       # User settings and preferences
```

### Core Data Entities Schema
- **User**: Profile information, goals, preferences
- **Workout**: Exercise sessions with duration and notes  
- **Exercise**: Individual movements with category classification
- **ExerciseSet**: Reps, weight, rest time for each set
- **WeightEntry**: Daily weight records with date/notes
- **Meal**: Nutrition tracking by meal type
- **Food**: Nutrition database with macros and calories

## Key Development Patterns

### State Management
- Uses SwiftUI's native state management (`@State`, `@ObservableObject`)
- Core Data context injected via environment: `.environment(\.managedObjectContext, persistenceController.container.viewContext)`
- HealthKit service uses `@Published` properties for reactive updates

### Error Handling
- Custom HealthKit error types with localized descriptions
- Core Data errors handled with `fatalError` in development (needs improvement)
- Async error propagation through throwing functions

### Navigation Structure
- Tab-based root navigation (`ContentView.swift:7`)
- Feature-based view organization
- Consistent SF Symbols for tab icons

## Current Development Status

### ✅ Completed (MVP Foundation)
- Project structure and Core Data models
- Basic UI shells for all main features  
- HealthKit service foundation
- Tab navigation and build system

### 🔄 Next Priority (from NEXT_STEPS.md)
1. **User Authentication & Onboarding** - Apple Sign-In integration
2. **Dashboard Implementation** - Stats overview and quick actions
3. **Weight Tracking Enhancement** - Full CRUD operations with charts

### ⚠️ Technical Debt  
- No error handling for Core Data operations
- Missing loading states and data validation
- No unit tests or UI tests implemented
- Need proper state management pattern for complex data flows

## Important Configuration Files

### HealthKit Integration
- **Entitlements**: `FitApp.entitlements` - HealthKit permissions
- **Privacy Descriptions**: `Info.plist:21-24` - Required usage descriptions
- **Bundle ID**: `com.yourcompany.fitapp` (needs customization for deployment)

### Core Data Stack
- **Data Model**: `FitAppDataModel.xcdatamodeld`
- **Persistence Controller**: Singleton pattern with preview support
- **Context Injection**: Environment-based dependency injection

## Development Workflow

### Setup for New Developers
1. Clone repository and open `FitApp.xcodeproj`
2. Configure code signing in Xcode project settings
3. Update Bundle Identifier for your Apple Developer account
4. Test on physical device (HealthKit requires real hardware)

### Code Style Conventions
- SwiftUI declarative syntax throughout
- Feature-based file organization
- Consistent use of SF Symbols for icons
- Native iOS design patterns and components

### Testing Requirements  
- **HealthKit Testing**: Must use physical iOS device
- **Core Data Testing**: Can use iOS Simulator
- **UI Testing**: Simulator adequate for basic UI flows
- **Build Verification**: Project builds without external dependencies

## Onboarding System

### ✅ Modern 13-Screen Onboarding Flow (COMPLETED)
A comprehensive CalAI-style onboarding system has been implemented with:

#### Core Screens (Fully Implemented)
1. **Welcome Screen** - Modern intro with "Get Started" button
2. **Gender Selection** - Male/Female/Other with validation
3. **Activity Level** - Sedentary to Super Active workout frequency  
4. **Goal Selection** - Lose/Gain/Maintain Weight or Build Muscle

#### Extended Screens (Placeholder Implementation)
5. **Weight & Height** - Imperial/Metric picker (ready for enhancement)
6. **Date of Birth** - Age-based personalization
7. **Referral Source** - Marketing attribution tracking
8. **Desired Weight** - Goal weight selection with smart validation
9. **Weight Loss Speed** - Emoji slider 🐌🐰🐆 with recommendations
10. **Obstacles Selection** - Multi-select challenges with checkmarks
11. **Diet Type** - Eating style preferences (Keto, Mediterranean, etc.)
12. **Plan Generation** - Animated progress ring with realistic steps
13. **Apple Health** - Integration option with skip functionality

### Consolidated Architecture
**All onboarding code is consolidated in `ContentView.swift` for guaranteed Xcode compatibility:**

```swift
// ContentView.swift contains:
├── OnboardingData class           # Complete data model with @Published properties
├── OnboardingCoordinator struct   # 13-screen navigation coordinator
├── All enum definitions          # Gender, WorkoutFrequency, GoalType, etc.
├── Individual screen views       # OnboardingWelcomeView, OnboardingGenderView, etc.
└── Supporting components         # Progress bar, selection buttons, etc.
```

### Key Implementation Features
- ✅ **Single-File Architecture** - All code in ContentView.swift (no separate files needed)
- ✅ **Type-Safe Enums** - Gender, WorkoutFrequency, GoalType, WeightLossSpeed, etc.
- ✅ **Reactive Data Model** - OnboardingData with @Published properties
- ✅ **Progress Tracking** - Visual "Step X of 13" progress throughout flow
- ✅ **Core Data Integration** - Saves complete user profile upon completion
- ✅ **HealthKit Integration** - Optional Apple Health connection
- ✅ **Modern UI/UX** - Dark theme, animations, validation, disabled states

### Onboarding Flow Logic
```swift
// Automatic onboarding detection in ContentView:
if hasCompletedOnboarding {
    // Show main app TabView
} else {
    // Show OnboardingCoordinator
}

// Completion triggers:
NotificationCenter.default.post(name: .onboardingCompleted, object: nil)
```

### Data Persistence
The onboarding automatically:
- ✅ **Creates User Entity** - Saves all demographic and preference data
- ✅ **Initial Weight Entry** - Creates first WeightEntry record
- ✅ **HealthKit Request** - Requests permissions if user opts in
- ✅ **Seamless Transition** - Switches to main app interface

### Build Status
- ✅ **Compilation Success** - All Swift compiler errors resolved
- ✅ **Runtime Ready** - App builds and runs in iOS Simulator
- ✅ **Type Safety** - All data models and enums properly defined
- ✅ **Navigation Working** - Forward/back flow with state management

### Next Enhancement Opportunities
The foundation is complete. To enhance individual screens:
1. **Weight/Height Picker** - Add full Imperial/Metric UI components
2. **Desired Weight Logic** - Implement weight difference calculations  
3. **Speed Slider** - Add interactive drag gesture for animal emoji slider
4. **Obstacles Multi-Select** - Implement checkbox selection UI
5. **Plan Generation Animation** - Add step-by-step progress updates

## External Dependencies

**None** - Project uses only native iOS frameworks:
- SwiftUI (UI framework)
- Core Data (persistence)
- HealthKit (health integration)  
- Foundation (system services)

This minimal dependency approach ensures reliability and reduces maintenance overhead.