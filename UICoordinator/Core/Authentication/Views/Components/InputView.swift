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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .textFieldStyle(.plain)
                .font(.system(size: 20, design: .serif))
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(.plain)
                    .font(.system(size: 20, design: .serif))
                    .frame(width: 300)
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(.plain)
                    .font(.system(size: 20, design: .serif))
                    .frame(width: 300)
            }
            
            Rectangle()
                .frame(width: 335, height: 1)
        }
        
    }
}

#Preview {
    InputView(text: .constant(""), title: "email", placeholder: "name@example.com")
}
