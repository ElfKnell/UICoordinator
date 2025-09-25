//
//  LoadingView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/03/2024.
//

import SwiftUI

struct LoadingView: View {
    
    @State private var rotation = 0.0
    let size: CGFloat
    
    var body: some View {
            
        VStack(spacing: 16) {
            
            Circle()
                .trim(from: 0, to: 0.8)
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, dash: [4, 20]))
                .frame(width: size, height: size)
                .foregroundStyle(Color.accentColor)
                .rotationEffect(Angle(degrees: rotation))
                .onAppear() {
                    withAnimation(
                        Animation.linear(duration: 1.5)
                            .repeatForever(autoreverses: false)
                    ) {
                        rotation = 360
                    }
                }
            
            Text("Loading...")
                .foregroundStyle(.primary)
                .font(.body)
                .accessibilityLabel("Loading content")
            
        }
        .padding()
        .accessibilityElement(children: .combine)
        
    }
}

#Preview {
    LoadingView(size: 80)
        .preferredColorScheme(.light)
    LoadingView(size: 80)
        .preferredColorScheme(.dark)
}
