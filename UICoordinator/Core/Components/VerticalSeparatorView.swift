//
//  VerticalSeparatorView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/03/2025.
//

import SwiftUI

struct VerticalSeparatorView: View {
    var body: some View {
        
        HStack(alignment: .top) {
            
            Text("|")
                .font(.title)
                .padding(.horizontal)
                .opacity(0.5)
            
            Spacer()
        }
    }
}

#Preview {
    VerticalSeparatorView()
}
