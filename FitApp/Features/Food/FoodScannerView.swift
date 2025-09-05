import SwiftUI

// MARK: - Food Scanner View

struct FoodScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingImagePicker = false
    @State private var capturedImage: UIImage?
    @State private var scanResult: String = ""
    @State private var isScanning = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Scan Food")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .padding(.top, 8)
                
                // Camera View Placeholder
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    VStack {
                        Spacer()
                        
                        // Square scan frame
                        Rectangle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 280, height: 280)
                        
                        Spacer()
                    }
                    
                    // Instructions
                    VStack {
                        Spacer()
                        
                        if !isScanning && scanResult.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "viewfinder")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text("Point camera at food")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .padding(.bottom, 200)
                        }
                        
                        if isScanning {
                            VStack(spacing: 8) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1.2)
                                
                                Text("Analyzing food...")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .padding(.bottom, 200)
                        }
                        
                        Spacer()
                    }
                }
                
                // Bottom Action Bar
                HStack(spacing: 0) {
                    // Gallery button
                    Button(action: {}) {
                        VStack(spacing: 8) {
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 24))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("Gallery")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                    }
                    
                    // Scan button
                    Button(action: startScanning) {
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .stroke(Color.white, lineWidth: 4)
                                    .frame(width: 70, height: 70)
                                
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 60, height: 60)
                                
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.black)
                            }
                            
                            Text("Scan Food")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 100)
                    }
                    .disabled(isScanning)
                    
                    // Manual entry button
                    Button(action: {}) {
                        VStack(spacing: 8) {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 24))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("Manual")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
    
    private func startScanning() {
        isScanning = true
        
        // Simulate scanning process
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            isScanning = false
            // Simulate scan result
            let foods = ["Turkey Sandwich", "Grilled Chicken Salad", "Banana", "Greek Yogurt"]
            scanResult = foods.randomElement() ?? "Unknown Food"
        }
    }
}
