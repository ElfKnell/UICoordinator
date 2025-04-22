//
//  ContentView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 17/02/2024.
//

import SwiftUI

struct UICoordinatorRootView: View {
    
    @EnvironmentObject var viewModel: AuthService
    @EnvironmentObject var userFollow: UserFollowers
    @State private var isLoading = false
    
    var body: some View {
        
        Group {
            if isLoading {
                LoadingView(width: 300, height: 300)
            } else {
                
                if viewModel.userSession != nil {
                    CoordinatorTabView()
                        .onAppear {
                            Task {
                                
                                await userFollow.setFollowersCurrentUser(userId: viewModel.userSession?.uid)
                                
                            }
                        }
                } else {
                    LoginView()
                }
            }
        }
        .onAppear {
            Task {
                isLoading = true
                await viewModel.checkUserSession()
                isLoading = false
            }
        }
    }
}

#Preview {
    UICoordinatorRootView()
}
