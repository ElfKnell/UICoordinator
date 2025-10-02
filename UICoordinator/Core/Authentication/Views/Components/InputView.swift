//
//  ImputView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/02/2024.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .textFieldStyle(.plain)
                .font(.title3)
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(.plain)
                    .font(.title3)
                    .frame(maxWidth: 400)
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(.plain)
                    .font(.title3)
                    .frame(maxWidth: 400)
            }
            
            Rectangle()
                .frame(maxWidth: 415, maxHeight: 1)
        }
        .padding(.horizontal)
        .padding(.vertical, sizeClass == .compact ? 5 : 16)
    }
}

#Preview {
    InputView(text: .constant(""), title: "email", placeholder: "name@example.com")
}
