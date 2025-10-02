//
//  UICoordinatorRootView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 17/02/2024.
//

import SwiftUI

struct UICoordinatorRootView: View {
    
    @EnvironmentObject var container: DIContainer
    @State private var isLoading = false
    
    private var appState: AppFlow {
        if isLoading {
            return .loading
        } else if let user = container.currentUserService.currentUser {
            if user.isDelete {
                return .deleteUser
            } else {
                return .loggedIn(user)
            }
        } else {
            return .loggedOut
        }
    }
    
    var body: some View {
        
        Group {
            switch appState {
            case .loading:
                LoadingView(size: 250)
            case .loggedIn(let user):
                CoordinatorTabView()
                    .task {
                        await container.userFollow.loadFollowersCurrentUser(userId: user.id)
                    }
            case .loggedOut:
                LoginView()
            case .deleteUser:
                UserRecoveryView()
            }
        }
        .task {
            isLoading = true
            await container.authService.checkUserSession()
            isLoading = false
        }
        .alert("No Internet Connection", isPresented: $container.networkMonitor.isDisconected) {
            Button("OK", role: .cancel) {}
        } message: {
            HStack {
                Image(systemName: "wifi.exclamationmark")
                    .foregroundStyle(.red)
                Text("Please check your connection and try again.")
            }
        }
    }
}

#Preview {
    UICoordinatorRootView()
}
