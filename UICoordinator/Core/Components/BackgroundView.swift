//
//  BackgroundView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/02/2024.
//

import SwiftUI

struct BackgroundView: View {
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .foregroundStyle(
                .linearGradient(
                    colors: [.blue, .red],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
            )
            .rotationEffect(.degrees(137))
            .scaleEffect(1.3)
            .opacity(0.7)
            .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView()
}
