import SwiftUI
import CoreData
import Foundation

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var hasCompletedOnboarding = false
    @State private var forceOnboarding = true  // Force onboarding for testing
    
    var body: some View {
        if hasCompletedOnboarding && !forceOnboarding {
            // Main app interface
            TabView {
                NavigationView {
                    DashboardView()
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Dashboard")
                }
                .tag(1)
                
                WorkoutsView()
                    .tabItem {
                        Image(systemName: "dumbbell.fill")
                        Text("Workouts")
                    }
                    .tag(2)
                
                WeightTrackingView()
                    .tabItem {
                        Image(systemName: "scalemass.fill")
                        Text("Weight")
                    }
                    .tag(2)
                
                MealsView()
                    .tabItem {
                        Image(systemName: "fork.knife")
                        Text("Meals")
                    }
                    .tag(3)
                
                GamificationView(context: viewContext)
                    .tabItem {
                        Image(systemName: "trophy.fill")
                        Text("Achievements")
                    }
                    .tag(4)
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("You")
                    }
                    .tag(5)
            }
            .accentColor(.blue)
            .onAppear {
                print("🏠 Main app appeared (hasCompletedOnboarding = \(hasCompletedOnboarding))")
                checkOnboardingStatus()
            }
        } else {
            // Onboarding Flow
            OnboardingCoordinator()
                .onAppear {
                    print("📝 Onboarding appeared (hasCompletedOnboarding = \(hasCompletedOnboarding))")
                    checkOnboardingStatus()
                }
                .onReceive(NotificationCenter.default.publisher(for: .onboardingCompleted)) { _ in
                    print("📨 Received onboarding completion notification!")
                    DispatchQueue.main.async {
                        print("📱 Setting hasCompletedOnboarding to true and disabling force onboarding")
                        hasCompletedOnboarding = true
                        forceOnboarding = false  // Allow transition to main app
                    }
                }
        }
    }
    
    private func checkOnboardingStatus() {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchLimit = 1
        
        do {
            let users = try viewContext.fetch(request)
            let completed = !users.isEmpty
            print("🔍 Checking onboarding status: found \(users.count) users, completed: \(completed)")
            hasCompletedOnboarding = completed
        } catch {
            print("❌ Error checking onboarding status: \(error)")
            hasCompletedOnboarding = false
        }
        
        // Note: forceOnboarding = true ensures onboarding shows on every rebuild
        // When onboarding completes, forceOnboarding is set to false to allow main app access
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}