//
//  MarkerView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/03/2024.
//

import SwiftUI

struct MarkerView: View {
    let name: String
    
    @State private var colorImage: Color = .red
    @State private var colorText: Color = .red
    
    var body: some View {
        VStack(spacing: 0) {
            
            Image(systemName: "mappin.and.ellipse.circle.fill")
              .font(.title)
              .foregroundColor(colorImage)
            
            Image(systemName: "arrowtriangle.down.fill")
              .font(.caption)
              .foregroundColor(colorImage)
              .offset(x: 0, y: -5)
            
            Text(name)
                .fixedSize()
                .foregroundStyle(colorText)
        }
        .onAppear {
            if let loadedColorMarker = Color.loadFromAppStorage("selectedColorMarker") {
                colorImage = Color(red: loadedColorMarker.red, green: loadedColorMarker.green, blue: loadedColorMarker.blue, opacity: loadedColorMarker.alpha)
            }
            
            if let loadedColorText = Color.loadFromAppStorage("selectedColorText") {
                colorText = Color(red: loadedColorText.red, green: loadedColorText.green, blue: loadedColorText.blue, opacity: loadedColorText.alpha)
            }
        }
    }
}

#Preview {
    MarkerView(name: "No name")
}
