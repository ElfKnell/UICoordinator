//
//  SightView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/03/2024.
//

import SwiftUI

struct SightView: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.blue.opacity(0.3))
                .frame(width: 30, height: 30)
            
            Circle()
                .foregroundColor(.white.opacity(0.5))
                .frame(width: 20, height: 20)
            
            Circle()
                .foregroundColor(.red.opacity(0.7))
                .frame(width: 10, height: 10)
        }
    }
}

#Preview {
    SightView()
}
