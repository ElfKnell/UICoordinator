//
//  BodySideMenu.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/03/2024.
//

import SwiftUI

struct SideMenuRowView: View {
    @Binding var selected: OptionModel?
    let option: OptionModel
    
    private var isSecected: Bool {
        option == selected
    }
    
    var body: some View {
        HStack {
            Image(systemName: option.systemImageName)
                .imageScale(.small)
            
            Text(option.title)
                .font(.subheadline)
            
            Spacer()
        }
        .padding(.leading)
        .frame(height: 44)
        .background(isSecected ? .blue.opacity(0.3) : .clear)
        .modifier(CornerRadiusModifier())
    }
}

#Preview {
    SideMenuRowView(selected: .constant(.about), option: .about)
}
