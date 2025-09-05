import SwiftUI

// MARK: - Plan Summary View

struct PlanSummaryView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 16) {
                    Text("Congratulations your custom plan is ready!")
                        .font(.system(size: 28, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("You should lose: Lose 12 lbs by December 26")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 20)
                
                // Daily Recommendation Cards
                VStack(spacing: 16) {
                    Text("Daily Recommendations")
                        .font(.system(size: 20, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        RecommendationCard(title: "Calories", value: "2000", unit: "cal", icon: "flame.fill", color: .orange)
                        RecommendationCard(title: "Carbs", value: "250", unit: "g", icon: "square.fill", color: .yellow)
                        RecommendationCard(title: "Protein", value: "150", unit: "g", icon: "leaf.fill", color: .red)
                        RecommendationCard(title: "Fats", value: "67", unit: "g", icon: "drop.fill", color: .purple)
                    }
                    .padding(.horizontal)
                }
                
                Spacer(minLength: 100)
            }
            .padding(.vertical)
        }
        .navigationTitle("Your Plan")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct RecommendationCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "pencil")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
            }
            
            VStack(spacing: 4) {
                HStack(alignment: .bottom, spacing: 2) {
                    Text(value)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(unit)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(.bottom, 4)
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}
