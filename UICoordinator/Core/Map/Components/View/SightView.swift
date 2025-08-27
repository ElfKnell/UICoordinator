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
                .frame(width: 19, height: 19)
            
            Circle()
                .foregroundColor(.white.opacity(0.5))
                .frame(width: 13, height: 13)
            
            Circle()
                .foregroundColor(.red.opacity(0.7))
                .frame(width: 7, height: 7)
        }
    }
}

#Preview {
    SightView()
}
