//
//  PasswordRuleView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 24/07/2025.
//

import SwiftUI

struct PasswordRuleView: View {

    let text: String
    let isValide: Bool
    
    var body: some View {
        
        HStack {
            
            Image(systemName: isValide ? "checkmark.circle" : "circle")
                .foregroundStyle(isValide ? .green : .gray)
            
            Text(text)
                .foregroundStyle(isValide ? .green : .gray)
        }
    }
}

#Preview {
    PasswordRuleView(text: "", isValide: false)
}
