//
//  CircularProfileImageView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/02/2024.
//

import SwiftUI

struct CircularProfileImageView: View {
    var body: some View {
        
        Image("appstore")
            .resizable()
            .scaledToFill()
            .frame(width: 40, height: 40)
            .clipShape(Circle())
    }
}

#Preview {
    CircularProfileImageView()
}
