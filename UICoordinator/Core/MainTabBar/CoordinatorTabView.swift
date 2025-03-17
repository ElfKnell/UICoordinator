//
//  CoordinatorTabBar.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/02/2024.
//

import SwiftUI

struct CoordinatorTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            LocationView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "map.fill" : "map")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                }
                .onAppear { selectedTab = 0 }
                .tag(0)
            
            FeedView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "list.bullet.rectangle.fill" : "list.bullet.rectangle")
                        .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                }
                .onAppear { selectedTab = 1 }
                .tag(1)
            
            ExploreView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .onAppear { selectedTab = 2 }
                .tag(2)
            
            ActivityView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "mappin.and.ellipse.circle.fill" : "mappin.and.ellipse.circle")
                        .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                }
                .onAppear { selectedTab = 3 }
                .tag(3)
            
            SideSelectionTabBarView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "person.fill" : "person")
                        .environment(\.symbolVariants, selectedTab == 4 ? .fill : .none)
                }
                .onAppear { selectedTab = 4 }
                .tag(4)
        }
        .tint(.primary)
    }
}

#Preview {
    CoordinatorTabView()
}
