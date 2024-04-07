//
//  MarkerView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/03/2024.
//

import SwiftUI

struct MarkerView: View {
    let name: String
    
    var body: some View {
        VStack(spacing: 0) {
            
            Image(systemName: "mappin.and.ellipse.circle.fill")
              .font(.title)
              .foregroundColor(.red)
            
            Image(systemName: "arrowtriangle.down.fill")
              .font(.caption)
              .foregroundColor(.red)
              .offset(x: 0, y: -5)
            
            Text(name)
                .fixedSize()
        }
    }
}

#Preview {
    MarkerView(name: "No name")
}
