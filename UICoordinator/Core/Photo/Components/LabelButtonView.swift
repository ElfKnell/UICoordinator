//
//  LabelButtonView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 10/03/2024.
//

import SwiftUI

struct LabelButtonView: View {
    let imageName: String
    let label: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
            
            Text(label)
        }
        .font(.headline)
        .padding()
        .frame(height: 40)
        .background(Color.blue)
        .foregroundColor(.white)
        .modifier(CornerRadiusModifier())
    }
}

#Preview {
    LabelButtonView(imageName: "", label: "")
}
