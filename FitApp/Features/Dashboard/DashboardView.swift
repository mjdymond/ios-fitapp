import SwiftUI
import CoreData

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Workout.date, ascending: false)],
        predicate: NSPredicate(format: "date >= %@", Calendar.current.startOfDay(for: Date()) as CVarArg),
        animation: .default)
    private var todaysWorkouts: FetchedResults<Workout>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WeightEntry.date, ascending: false)],
        predicate: NSPredicate(format: "date >= %@", Calendar.current.startOfDay(for: Date()) as CVarArg),
        animation: .default)
    private var todaysWeight: FetchedResults<WeightEntry>
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Good morning!")
                                .font(.title2)
                                .fontWeight(.medium)
                            Text("Ready for today's workout?")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "bell")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Quick Stats
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        DashboardCard(
                            title: "Today's Workouts",
                            value: "\(todaysWorkouts.count)",
                            icon: "dumbbell.fill",
                            color: .blue
                        )
                        
                        DashboardCard(
                            title: "Current Weight",
                            value: todaysWeight.first?.weight.formatted() ?? "—",
                            icon: "scalemass.fill",
                            color: .green
                        )
                    }
                    .padding(.horizontal)
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Quick Actions")
                                .font(.headline)
                            Spacer()
                        }
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            QuickActionButton(
                                title: "Start Workout",
                                icon: "play.fill",
                                color: .blue
                            ) {
                                // Navigate to workout
                            }
                            
                            QuickActionButton(
                                title: "Log Weight",
                                icon: "plus.circle.fill",
                                color: .green
                            ) {
                                // Navigate to weight entry
                            }
                            
                            QuickActionButton(
                                title: "Log Meal",
                                icon: "fork.knife",
                                color: .orange
                            ) {
                                // Navigate to meal entry
                            }
                            
                            QuickActionButton(
                                title: "View Progress",
                                icon: "chart.line.uptrend.xyaxis",
                                color: .purple
                            ) {
                                // Navigate to progress
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 100)
                }
                .padding(.top)
            }
            .navigationTitle("FitApp")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct DashboardCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                Spacer()
            }
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DashboardView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
