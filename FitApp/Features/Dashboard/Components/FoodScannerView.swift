import SwiftUI
import AVFoundation

struct FoodScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingImagePicker = false
    @State private var showingManualEntry = false
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
                
                // Camera View
                ZStack {
                    // Camera preview placeholder (in real app, would be actual camera feed)
                    CameraPreviewPlaceholder()
                    
                    // Scanning Overlay
                    VStack {
                        Spacer()
                        
                        // Square scan frame
                        ZStack {
                            Rectangle()
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: 280, height: 280)
                            
                            // Corner indicators
                            VStack {
                                HStack {
                                    ScannerCorner(corners: [.topLeading])
                                    Spacer()
                                    ScannerCorner(corners: [.topTrailing])
                                }
                                Spacer()
                                HStack {
                                    ScannerCorner(corners: [.bottomLeading])
                                    Spacer()
                                    ScannerCorner(corners: [.bottomTrailing])
                                }
                            }
                            .frame(width: 280, height: 280)
                            
                            // Scanning animation
                            if isScanning {
                                Rectangle()
                                    .fill(Color.white.opacity(0.3))
                                    .frame(width: 280, height: 4)
                                    .offset(y: -140)
                                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isScanning)
                            }
                        }
                        
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
                                
                                Text("Make sure the food is well lit and centered")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
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
                .frame(maxHeight: .infinity)
                
                // Bottom Action Bar
                VStack(spacing: 0) {
                    if !scanResult.isEmpty {
                        // Scan results
                        VStack(spacing: 16) {
                            Text("Found: \(scanResult)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            HStack(spacing: 12) {
                                Button("Try Again") {
                                    scanResult = ""
                                    isScanning = false
                                }
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(24)
                                
                                Button("Use This") {
                                    // Handle scan result
                                    dismiss()
                                }
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(Color.white)
                                .cornerRadius(24)
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.8))
                    } else {
                        // Action buttons
                        HStack(spacing: 0) {
                            // Gallery button
                            Button(action: {
                                showingImagePicker = true
                            }) {
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
                                .contentShape(Rectangle())
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
                                .contentShape(Rectangle())
                            }
                            .disabled(isScanning)
                            
                            // Manual entry button
                            Button(action: {
                                showingManualEntry = true
                            }) {
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
                                .contentShape(Rectangle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $capturedImage)
        }
        .sheet(isPresented: $showingManualEntry) {
            ManualFoodEntryView()
        }
        .statusBarStyle(.lightContent)
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

struct ScannerCorner: View {
    let corners: UIRectCorner
    
    var body: some View {
        Rectangle()
            .stroke(Color.white, lineWidth: 3)
            .frame(width: 20, height: 20)
            .clipShape(RoundedCorner(radius: 0, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct CameraPreviewPlaceholder: View {
    @State private var animateGradient = false
    
    var body: some View {
        ZStack {
            // Animated background to simulate camera feed
            LinearGradient(
                colors: [
                    Color.gray.opacity(0.3),
                    Color.gray.opacity(0.1),
                    Color.gray.opacity(0.3)
                ],
                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                endPoint: animateGradient ? .bottomTrailing : .topLeading
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
            
            // Camera placeholder content
            VStack {
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 60))
                    .foregroundColor(.white.opacity(0.3))
                
                Text("Camera Preview")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.top, 8)
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }
    }
}

struct ManualFoodEntryView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Manual Food Entry")
                    .font(.title2)
                    .padding()
                
                Text("Search and select food items manually")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .navigationTitle("Add Food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    FoodScannerView()
}