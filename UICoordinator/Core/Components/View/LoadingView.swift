//
//  LoadingView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/03/2024.
//

import SwiftUI

struct LoadingView: View {
    
    @State var isLoading = true
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
            
        Circle()
            .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, dash: [4, 20]))
            .frame(width: width, height: height, alignment: .center)
            .foregroundStyle(.yellow)
            .onAppear() {
                    withAnimation(Animation.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                        isLoading.toggle()
                    }
                }
            .rotationEffect(Angle(degrees: isLoading ? 0 : 360))
            
        Text("Loading...")
            .foregroundStyle(.yellow)
        
    }
}

#Preview {
    LoadingView(width: 130, height: 130)
}
