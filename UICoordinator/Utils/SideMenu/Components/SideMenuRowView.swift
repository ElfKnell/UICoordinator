//
//  BodySideMenu.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/03/2024.
//

import SwiftUI

struct SideMenuRowView: View {
    
    
    var body: some View {
        HStack {
            Image(systemName: "bell")
                .imageScale(.small)
            
            Text("Notifications")
                .font(.subheadline)
            
            Spacer()
        }
        .padding(.leading)
        .frame(height: 44)
    }
}

#Preview {
    SideMenuRowView()
}
