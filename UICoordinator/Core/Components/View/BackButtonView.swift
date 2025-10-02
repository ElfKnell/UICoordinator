//
//  BackButtonView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 10/03/2024.
//

import SwiftUI

struct BackButtonView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        Button {
            dismiss()
        } label: {
            Image(systemName: "arrow.left.circle")
                .background(Circle().fill(Color.white))
                .shadow(radius: 3)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    BackButtonView()
}
