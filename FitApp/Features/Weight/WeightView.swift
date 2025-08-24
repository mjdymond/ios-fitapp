import SwiftUI
import CoreData

struct WeightView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WeightEntry.date, ascending: true)],
        animation: .default)
    private var weightEntries: FetchedResults<WeightEntry>
    
    @State private var showingNewEntry = false
    @State private var selectedTimeRange = TimeRange.month
    
    enum TimeRange: String, CaseIterable {
        case week = "1W"
        case month = "1M"
        case threeMonths = "3M"
        case year = "1Y"
        
        var days: Int {
            switch self {
            case .week: return 7
            case .month: return 30
            case .threeMonths: return 90
            case .year: return 365
            }
        }
    }
    
    var filteredEntries: [WeightEntry] {
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -selectedTimeRange.days, to: Date()) ?? Date()
        return weightEntries.filter { entry in
            entry.date ?? Date() >= cutoffDate
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Current Weight Card
                    if let latestEntry = weightEntries.last {
                        CurrentWeightCard(weightEntry: latestEntry)
                            .padding(.horizontal)
                    }
                    
                    // Chart Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Weight Progress")
                                .font(.headline)
                            
                            Spacer()
                            
                            Picker("Time Range", selection: $selectedTimeRange) {
                                ForEach(TimeRange.allCases, id: \.self) { range in
                                    Text(range.rawValue).tag(range)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 200)
                        }
                        
                        if filteredEntries.isEmpty {
                            EmptyChartView()
                        } else {
                            WeightChart(entries: filteredEntries)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Recent Entries
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Recent Entries")
                                .font(.headline)
                            Spacer()
                            Button("See All") {
                                // Navigate to full history
                            }
                            .font(.caption)
                        }
                        
                        if weightEntries.isEmpty {
                            EmptyStateView(
                                icon: "scalemass",
                                title: "No Weight Entries",
                                subtitle: "Start tracking your weight to see progress over time"
                            )
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(Array(weightEntries.suffix(5).reversed()), id: \.self) { entry in
                                    WeightEntryRow(entry: entry)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 100)
                }
                .padding(.top)
            }
            .navigationTitle("Weight")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewEntry = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewEntry) {
                NewWeightEntryView()
            }
        }
    }
}

struct CurrentWeightCard: View {
    let weightEntry: WeightEntry
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Current Weight")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("\(weightEntry.weight, specifier: "%.1f") lbs")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                Image(systemName: "scalemass.fill")
                    .font(.title)
                    .foregroundColor(.blue)
            }
            
            if let date = weightEntry.date {
                HStack {
                    Text("Last updated: \(formatDate(date))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct WeightChart: View {
    let entries: [WeightEntry]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
                
                if entries.isEmpty {
                    Text("No data available")
                        .foregroundColor(.secondary)
                } else {
                    // Simple line chart using Path
                    Path { path in
                        let width = geometry.size.width - 40
                        let height = geometry.size.height - 40
                        
                        guard let minWeight = entries.map(\.weight).min(),
                              let maxWeight = entries.map(\.weight).max(),
                              maxWeight > minWeight else { return }
                        
                        let weightRange = maxWeight - minWeight
                        
                        for (index, entry) in entries.enumerated() {
                            let x = 20 + (CGFloat(index) / CGFloat(entries.count - 1)) * width
                            let y = 20 + (1 - (entry.weight - minWeight) / weightRange) * height
                            
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(Color.blue, lineWidth: 2)
                    
                    // Data points
                    ForEach(Array(entries.enumerated()), id: \.offset) { index, entry in
                        let width = geometry.size.width - 40
                        let height = geometry.size.height - 40
                        
                        if let minWeight = entries.map(\.weight).min(),
                           let maxWeight = entries.map(\.weight).max(),
                           maxWeight > minWeight {
                            let weightRange = maxWeight - minWeight
                            let x = 20 + (CGFloat(index) / CGFloat(entries.count - 1)) * width
                            let y = 20 + (1 - (entry.weight - minWeight) / weightRange) * height
                            
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 6, height: 6)
                                .position(x: x, y: y)
                        }
                    }
                }
            }
        }
        .frame(height: 200)
    }
}

struct EmptyChartView: View {
    var body: some View {
        Rectangle()
            .fill(Color(.systemGray6))
            .frame(height: 200)
            .cornerRadius(8)
            .overlay(
                Text("No data available")
                    .foregroundColor(.secondary)
            )
    }
}

struct WeightEntryRow: View {
    let entry: WeightEntry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(entry.weight, specifier: "%.1f") lbs")
                    .font(.headline)
                
                if let date = entry.date {
                    Text(formatDate(date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if let notes = entry.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct NewWeightEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var weight = ""
    @State private var notes = ""
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Weight Entry") {
                    HStack {
                        Text("Weight")
                        Spacer()
                        TextField("Enter weight", text: $weight)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("lbs")
                            .foregroundColor(.secondary)
                    }
                    
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                }
                
                Section("Notes (Optional)") {
                    TextField("Add notes about your progress...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Add Weight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveWeightEntry()
                    }
                    .disabled(weight.isEmpty)
                }
            }
        }
    }
    
    private func saveWeightEntry() {
        guard let weightValue = Double(weight) else { return }
        
        let newEntry = WeightEntry(context: viewContext)
        newEntry.id = UUID()
        newEntry.weight = weightValue
        newEntry.date = selectedDate
        newEntry.notes = notes.isEmpty ? nil : notes
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Failed to save weight entry: \(error)")
        }
    }
}

#Preview {
    WeightView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
