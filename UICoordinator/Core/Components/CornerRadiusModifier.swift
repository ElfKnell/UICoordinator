//
//  CornerRadiusModifier.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 09/03/2024.
//

import SwiftUI

struct CornerRadiusModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: 30.0))
            .overlay {
                RoundedRectangle(cornerRadius: 30.0)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            }
    }
}
