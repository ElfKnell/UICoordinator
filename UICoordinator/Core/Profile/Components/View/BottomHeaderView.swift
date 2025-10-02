//
//  BottomHeaderView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/03/2024.
//

import SwiftUI

struct BottomHeaderView: View {
    let title: String
    let counts: String
    let imageName: String
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Text(counts)
                    .font(.body)
                    .fontWeight(.bold)
                
                Image(systemName: imageName)
                
            }
            
            Text(title)
                .font(.subheadline)
                .foregroundStyle(Color.accentColor)
        }
        .padding(.horizontal)
    }
}

#Preview {
    BottomHeaderView(title: "Following", counts: "5", imageName: "heart.fill")
}
