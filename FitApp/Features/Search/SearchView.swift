import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var searchCategory: SearchCategory = .all
    
    enum SearchCategory: String, CaseIterable {
        case all = "All"
        case foods = "Foods"
        case exercises = "Exercises"
        case recipes = "Recipes"
        
        var icon: String {
            switch self {
            case .all: return "magnifyingglass"
            case .foods: return "fork.knife"
            case .exercises: return "dumbbell.fill"
            case .recipes: return "book.fill"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search foods, exercises, recipes...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding()
                
                // Category Picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(SearchCategory.allCases, id: \.self) { category in
                            Button(action: {
                                searchCategory = category
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: category.icon)
                                        .font(.caption)
                                    Text(category.rawValue)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(searchCategory == category ? Color.blue : Color(.systemGray6))
                                .foregroundColor(searchCategory == category ? .white : .primary)
                                .cornerRadius(16)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
                
                // Search Results
                if searchText.isEmpty {
                    // Recent Searches or Trending
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary.opacity(0.5))
                        
                        VStack(spacing: 8) {
                            Text("Search for anything")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("Find foods, exercises, and recipes to add to your plan")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()
                    }
                    .padding()
                } else {
                    // Search Results List
                    List {
                        ForEach(mockSearchResults.filter { result in
                            searchCategory == .all || result.category.lowercased() == searchCategory.rawValue.lowercased()
                        }, id: \.id) { result in
                            SearchResultRow(result: result)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // Mock search results for demonstration
    private var mockSearchResults: [SearchResult] {
        let foodResults = [
            SearchResult(id: "1", title: "Chicken Breast", subtitle: "165 cal per 100g", category: "Foods", icon: "leaf.fill"),
            SearchResult(id: "2", title: "Brown Rice", subtitle: "111 cal per 100g", category: "Foods", icon: "square.fill"),
            SearchResult(id: "3", title: "Salmon", subtitle: "208 cal per 100g", category: "Foods", icon: "drop.fill")
        ]
        
        let exerciseResults = [
            SearchResult(id: "4", title: "Push-ups", subtitle: "Upper body strength", category: "Exercises", icon: "figure.strengthtraining.traditional"),
            SearchResult(id: "5", title: "Squats", subtitle: "Lower body strength", category: "Exercises", icon: "figure.strengthtraining.traditional"),
            SearchResult(id: "6", title: "Running", subtitle: "Cardio exercise", category: "Exercises", icon: "figure.run")
        ]
        
        let recipeResults = [
            SearchResult(id: "7", title: "Protein Smoothie", subtitle: "Quick post-workout meal", category: "Recipes", icon: "cup.and.saucer.fill"),
            SearchResult(id: "8", title: "Quinoa Bowl", subtitle: "Healthy lunch option", category: "Recipes", icon: "bowl.fill")
        ]
        
        return (foodResults + exerciseResults + recipeResults).filter { result in
            result.title.localizedCaseInsensitiveContains(searchText) ||
            result.subtitle.localizedCaseInsensitiveContains(searchText)
        }
    }
}

struct SearchResult {
    let id: String
    let title: String
    let subtitle: String
    let category: String
    let icon: String
}

struct SearchResultRow: View {
    let result: SearchResult
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: result.icon)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(result.title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(result.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    SearchView()
}
