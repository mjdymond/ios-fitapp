import SwiftUI
import CoreData

// MARK: - Onboarding Coordinator

struct OnboardingCoordinator: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var onboardingData = OnboardingData()
    @State private var currentStep = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                Group {
                    switch currentStep {
                    case 0:
                        OnboardingWelcomeView { 
                            withAnimation { currentStep = 1 }
                        }
                    case 1:
                        OnboardingGenderView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 2 } 
                        }, onBack: { 
                            withAnimation { currentStep = 0 } 
                        })
                    case 2:
                        OnboardingWorkoutView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 3 } 
                        }, onBack: { 
                            withAnimation { currentStep = 1 } 
                        })
                    case 3:
                        OnboardingGoalView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 4 } 
                        }, onBack: { 
                            withAnimation { currentStep = 2 } 
                        })
                    case 4:
                        OnboardingWeightHeightView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 5 } 
                        }, onBack: { 
                            withAnimation { currentStep = 3 } 
                        })
                    case 5:
                        OnboardingDateOfBirthView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 6 } 
                        }, onBack: { 
                            withAnimation { currentStep = 4 } 
                        })
                    case 6:
                        OnboardingReferralView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 7 } 
                        }, onBack: { 
                            withAnimation { currentStep = 5 } 
                        })
                    case 7:
                        OnboardingDesiredWeightView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 8 } 
                        }, onBack: { 
                            withAnimation { currentStep = 6 } 
                        })
                    case 8:
                        OnboardingWeightLossSpeedView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 9 } 
                        }, onBack: { 
                            withAnimation { currentStep = 7 } 
                        })
                    case 9:
                        OnboardingObstaclesView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 10 } 
                        }, onBack: { 
                            withAnimation { currentStep = 8 } 
                        })
                    case 10:
                        OnboardingDietTypeView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 11 } 
                        }, onBack: { 
                            withAnimation { currentStep = 9 } 
                        })
                    case 11:
                        OnboardingPlanGenerationView(onNext: { 
                            withAnimation { currentStep = 12 } 
                        })
                    case 12:
                        OnboardingAppleHealthView(data: onboardingData, onNext: { 
                            withAnimation { currentStep = 13 } 
                        }, onBack: { 
                            withAnimation { currentStep = 11 } 
                        })
                    case 13:
                        OnboardingCompletionView { 
                            completeOnboarding() 
                        }
                    default:
                        OnboardingWelcomeView { 
                            withAnimation { currentStep = 1 } 
                        }
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            }
        }
        .navigationBarHidden(true)
        .environmentObject(onboardingData)
    }
    
    private func completeOnboarding() {
        print("🎯 Starting onboarding completion...")
        saveOnboardingData()
        print("🎯 Posting onboarding completion notification...")
        NotificationCenter.default.post(name: .onboardingCompleted, object: nil)
        print("🎯 Onboarding completion process finished")
    }
    
    private func saveOnboardingData() {
        let context = viewContext
        
        let user = User(context: context)
        user.id = UUID()
        user.name = "New User"
        user.email = ""
        user.createdAt = Date()
        user.currentWeight = onboardingData.currentWeightInPounds
        user.targetWeight = onboardingData.targetWeight
        user.height = onboardingData.heightInInches
        user.dateOfBirth = onboardingData.dateOfBirth
        
        // Only save to attributes that exist in Core Data model
        if let workoutFrequency = onboardingData.workoutFrequency {
            user.activityLevel = workoutFrequency.rawValue
        }
        
        let weightEntry = WeightEntry(context: context)
        weightEntry.id = UUID()
        weightEntry.weight = onboardingData.currentWeightInPounds
        weightEntry.date = Date()
        weightEntry.notes = "Initial weight from onboarding"
        weightEntry.user = user
        
        do {
            try context.save()
            print("✅ Onboarding data saved successfully!")
        } catch {
            print("❌ Error saving onboarding data: \(error)")
        }
    }
}
