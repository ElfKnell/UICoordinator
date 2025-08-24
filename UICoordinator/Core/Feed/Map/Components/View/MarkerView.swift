//
//  MarkerView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/03/2024.
//

import SwiftUI

struct MarkerView: View {
    
    let name: String
    
    @Binding var isSelected: Bool
    
    var action: () -> Void
    
    @State private var colorImage: Color = .red
    @State private var colorText: Color = .red
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0.0
    @State private var pulse: Bool = false
    
    var body: some View {
        
        Button {
            
            rotation = 0
            
            withAnimation(.interpolatingSpring(stiffness: 300, damping: 5)) {
                
                scale = 1.7
                rotation = 20
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                
                withAnimation(.spring()) {
                    scale = isSelected ? 1.5 : 1.0
                    rotation = 0
                }
                
            }
            
            action()
            
        } label: {
            
            VStack(spacing: 0) {
                
                ZStack {
                    
                    if isSelected {
                        
                        Circle()
                            .stroke(colorImage.opacity(0.5), lineWidth: 8)
                            .scaleEffect(pulse ? 1.4 : 1.0)
                            .opacity(pulse ? 0.2 : 0.5)
                            .animation(
                                .easeOut(duration: 1)
                                .repeatForever(autoreverses: true),
                                value: pulse
                            )
                            .frame(width: 44, height: 44)
                    }
                    
                    Image(systemName: "mappin")
                        .font(.title)
                        .foregroundStyle(colorImage)
                        .shadow(radius: 4)
                    
                }
                .rotationEffect(.degrees(rotation))
                
                Text(name)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .foregroundStyle(colorText)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(radius: isSelected ? 6 : 0)
                
            }
        }
        .scaleEffect(scale)
        .animation(.spring(response: 0.4, dampingFraction: 0.5), value: scale)
        .onAppear {
            if let loadedColorMarker = Color.loadFromAppStorage("selectedColorMarker") {
                colorImage = Color(red: loadedColorMarker.red, green: loadedColorMarker.green, blue: loadedColorMarker.blue, opacity: loadedColorMarker.alpha)
            }
            
            if let loadedColorText = Color.loadFromAppStorage("selectedColorText") {
                colorText = Color(red: loadedColorText.red, green: loadedColorText.green, blue: loadedColorText.blue, opacity: loadedColorText.alpha)
            }
            
            if isSelected {
                pulse = true
            }
        }
        .onChange(of: isSelected) { _, newValue in
            scale = newValue ? 1.5 : 1.0
            pulse = newValue
        }
        .onDisappear {
            scale = 1.0
            pulse = false
        }
    }
}

#Preview {
    MarkerView(name: "No name", isSelected: .constant(false), action: {})
}
