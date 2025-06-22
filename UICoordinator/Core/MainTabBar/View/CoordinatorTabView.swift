//
//  CoordinatorTabBar.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/02/2024.
//

import MapKit
import SwiftUI

struct CoordinatorTabView: View {
    
    @State private var mainSelectedTab = 0
    
    @StateObject var viewModel: CoordinatorViewModel
    
    init(viewModelBilder: @escaping () -> CoordinatorViewModel = {
        CoordinatorViewModel()
    }) {
        _viewModel = StateObject(wrappedValue: viewModelBilder())
    }
    
    var body: some View {
        
        TabView(selection: $mainSelectedTab) {
            
            SideSelectionTabBarView(mainSelectedTab: $mainSelectedTab, selectedTabIndex: 0)
                .tabItem {
                    Image(systemName: mainSelectedTab == 0 ? "map.fill" : "map")
                        .environment(\.symbolVariants, mainSelectedTab == 0 ? .fill : .none)
                }
                .onAppear { mainSelectedTab = 0 }
                .tag(0)
            
            FeedView()
                .tabItem {
                    Image(systemName: mainSelectedTab == 1 ? "list.bullet.rectangle.fill" : "list.bullet.rectangle")
                        .environment(\.symbolVariants, mainSelectedTab == 1 ? .fill : .none)
                }
                .onAppear { mainSelectedTab = 1 }
                .tag(1)
            
            MainUsersView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .onAppear { mainSelectedTab = 2 }
                .tag(2)
            
            ActivityView()
                .tabItem {
                    Image(systemName: mainSelectedTab == 3 ? "mappin.and.ellipse.circle.fill" : "mappin.and.ellipse.circle")
                        .environment(\.symbolVariants, mainSelectedTab == 3 ? .fill : .none)
                }
                .onAppear { mainSelectedTab = 3 }
                .tag(3)
            
            SideSelectionTabBarView(mainSelectedTab: $mainSelectedTab, selectedTabIndex: 1)
                .tabItem {
                    Image(systemName: mainSelectedTab == 4 ? "person.fill" : "person")
                        .environment(\.symbolVariants, mainSelectedTab == 4 ? .fill : .none)
                }
                .onAppear { mainSelectedTab = 4 }
                .tag(4)
        }
        .tint(.primary)
        .task {
            await viewModel.start()
        }
        .alert("Location Services", isPresented: $viewModel.isLocationServicesEnabled) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

#Preview {
    CoordinatorTabView()
}
