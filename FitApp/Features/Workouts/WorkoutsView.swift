import SwiftUI
import CoreData

struct WorkoutsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Workout.date, ascending: false)],
        animation: .default)
    private var workouts: FetchedResults<Workout>
    
    @State private var showingNewWorkout = false
    
    var body: some View {
        NavigationView {
            List {
                if workouts.isEmpty {
                    EmptyStateView(
                        icon: "dumbbell",
                        title: "No Workouts Yet",
                        subtitle: "Start your fitness journey by creating your first workout"
                    )
                    .listRowSeparator(.hidden)
                } else {
                    ForEach(workouts) { workout in
                        WorkoutRowView(workout: workout)
                    }
                    .onDelete(perform: deleteWorkouts)
                }
            }
            .navigationTitle("Workouts")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewWorkout = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewWorkout) {
                NewWorkoutView()
            }
        }
    }
    
    private func deleteWorkouts(offsets: IndexSet) {
        withAnimation {
            offsets.map { workouts[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Handle error appropriately
                print("Failed to delete workout: \(error)")
            }
        }
    }
}

struct WorkoutRowView: View {
    let workout: Workout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(workout.name ?? "Untitled Workout")
                    .font(.headline)
                Spacer()
                Text(formatDate(workout.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Label("\(workout.exercises?.count ?? 0) exercises", systemImage: "list.bullet")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if workout.duration > 0 {
                    Label(formatDuration(workout.duration), systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        return "\(minutes) min"
    }
}

struct NewWorkoutView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var workoutName = ""
    @State private var selectedExercises: [String] = []
    
    let exerciseLibrary = [
        "Push-ups", "Pull-ups", "Squats", "Deadlifts", "Bench Press",
        "Shoulder Press", "Bicep Curls", "Tricep Dips", "Lunges", "Planks"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Workout Details") {
                    TextField("Workout Name", text: $workoutName)
                }
                
                Section("Select Exercises") {
                    ForEach(exerciseLibrary, id: \.self) { exercise in
                        HStack {
                            Text(exercise)
                            Spacer()
                            if selectedExercises.contains(exercise) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            toggleExercise(exercise)
                        }
                    }
                }
            }
            .navigationTitle("New Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveWorkout()
                    }
                    .disabled(workoutName.isEmpty || selectedExercises.isEmpty)
                }
            }
        }
    }
    
    private func toggleExercise(_ exercise: String) {
        if selectedExercises.contains(exercise) {
            selectedExercises.removeAll { $0 == exercise }
        } else {
            selectedExercises.append(exercise)
        }
    }
    
    private func saveWorkout() {
        let newWorkout = Workout(context: viewContext)
        newWorkout.id = UUID()
        newWorkout.name = workoutName
        newWorkout.date = Date()
        newWorkout.duration = 0
        
        // Create exercises
        for exerciseName in selectedExercises {
            let exercise = Exercise(context: viewContext)
            exercise.id = UUID()
            exercise.name = exerciseName
            exercise.category = "General" // You could categorize these better
            exercise.workout = newWorkout
        }
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Failed to save workout: \(error)")
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text(title)
                .font(.title2)
                .fontWeight(.medium)
            
            Text(subtitle)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    WorkoutsView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
