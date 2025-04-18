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
    
    var body: some View {
        
        Group {
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
}

#Preview {
    UICoordinatorRootView()
}
