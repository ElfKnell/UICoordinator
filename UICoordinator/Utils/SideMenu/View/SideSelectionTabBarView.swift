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
    @Environment(\.horizontalSizeClass) var sizeClass
    var selectedTabIndex: Int
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Group {
                    switch selectedTab {
                    case 0:
                        LocationsView()
                            .onAppear {
                                mainSelectedTab = 0
                            }
                    case 1:
                        CurrentUserProfileView()
                            .onAppear {
                                mainSelectedTab = 4
                            }
                    case 2:
                        Settings()
                    case 3:
                        HelpView()
                    case 4:
                        AboutView()
                    default:
                        LocationsView()
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                
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
