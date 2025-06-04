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
    
    var body: some View {
        
        Group {
            if isLoading {
                LoadingView(width: 300, height: 300)
            } else if let user = container.currentUserService.currentUser {
                CoordinatorTabView()
                    .task {
                        await container.userFollow.loadFollowersCurrentUser(userId: user.id)
                    }
            } else {
                LoginView()
            }
        }
        .task {
            isLoading = true
            await container.authService.checkUserSession()
            isLoading = false
        }
        .alert("No Internet Connection", isPresented: $container.networkMonitor.isConnected) {
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
