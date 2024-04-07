//
//  SideSelectionTab.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/03/2024.
//

import SwiftUI

struct SideSelectionTabBarView: View {
    @Binding var selection: Int
    
    var body: some View {
        TabView(selection: $selection)  {
            
            
            Text("Notifications")
                .tag(0)
            
            Text("Help")
                .tag(1)
            
            Text("About")
                .tag(3)
        }
    }
}

#Preview {
    SideSelectionTabBarView(selection: .constant(0))
}
