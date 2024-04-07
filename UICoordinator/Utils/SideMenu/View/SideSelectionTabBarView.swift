//
//  SideSelectionTab.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/03/2024.
//

import SwiftUI

struct SideSelectionTabBarView: View {
    @State private var showSideMenu = false
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                TabView(selection: $selectedTab)  {
                    
                    CurrentUserProfileView()
                        .tag(0)
                    
                    Text("Notifications")
                        .tag(1)
                    
                    Text("Settings")
                        .tag(2)
                    
                    Text("Help")
                        .tag(3)
                    
                    AboutView()
                        .tag(4)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                SideMenuView(isShowind: $showSideMenu, selectedTab: $selectedTab)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSideMenu.toggle()
                    } label: {
                        Image(systemName: showSideMenu ? "xmark" : "line.3.horizontal")
                    }
                }
            }
        }
    }
}

#Preview {
    SideSelectionTabBarView()
}
