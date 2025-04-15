//
//  BackgroundView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/02/2024.
//

import SwiftUI

struct BackgroundView: View {
    
    private var backgroundHeight: CGFloat {
        return UIScreen.main.bounds.height * 1.3
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .foregroundStyle(.linearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
            .rotationEffect(.degrees(137))
            .frame(height: backgroundHeight)
            .ignoresSafeArea()
    }
}
