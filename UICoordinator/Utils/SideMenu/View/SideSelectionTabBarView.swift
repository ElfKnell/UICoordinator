//
//  SideSelectionTab.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/03/2024.
//

import SwiftUI

struct SideSelectionTabBarView: View {
    
    @Binding var mainSelectedTab: Int
    @State private var showSideMenu = false
    @State private var selectedTab = 0
    var selectedTabIndex: Int
    
    var body: some View {
        NavigationStack {
            ZStack {
                TabView(selection: $selectedTab)  {
                    
                    LocationsView()
                        .onAppear { mainSelectedTab = 0 }
                        .tag(0)
                    
                    CurrentUserProfileView()
                        .onAppear { mainSelectedTab = 4 }
                        .tag(1)
                    
                    Text("Notifications")
                        .tag(2)
                    
                    Settings()
                        .tag(3)
                    
                    Text("Help")
                        .tag(4)
                    
                    AboutView()
                        .tag(5)
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
            .onAppear {
                selectedTab = selectedTabIndex
            }
        }
    }
}

#Preview {
    SideSelectionTabBarView(mainSelectedTab: .constant(0), selectedTabIndex: 0)
}
