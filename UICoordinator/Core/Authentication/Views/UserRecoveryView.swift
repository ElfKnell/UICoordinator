//
//  UserRecoveryView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 12/07/2025.
//

import SwiftUI

struct UserRecoveryView: View {
    
    @StateObject var viewModel: UserRecoveryViewModel
    @EnvironmentObject var container: DIContainer
    
    init(viewModelBilder: @escaping () -> UserRecoveryViewModel = { UserRecoveryViewModel(userRecovery: UserRecoveryService(firestore: FirestoreAdapter()))
    }) {
        self._viewModel = StateObject(wrappedValue: viewModelBilder())
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                BackgroundView(backgroundHeight: .large)
                
                VStack {
                    
                    LogoView()
                    
                    VStack {
                        
                        Text("Account Deletion Detected")
                            .font(.title2)
                            .padding(.horizontal)
                        
                        Text("To regain access to the app’s features, please restore your account.")
                            .font(.subheadline)
                            .padding()
                        
                    }
                    
                    .padding()
                    
                    Button {
                        Task {
                            do {
                                viewModel.errorMessage = nil
                                viewModel.isError = false
                                
                                try await viewModel.restore(container.currentUserService.currentUser?.id)
                                try await container.currentUserService.updateCurrentUser()
                            } catch {
                                viewModel.isError = true
                                viewModel.errorMessage = error.localizedDescription
                            }
                            
                            
                        }
                    } label: {
                        
                        ButtonLabelView(title: "Restore", widthButton: 170)
                        
                    }
                    .padding()
                    
                    Button {
                        Task {
                            await container.userFollow.clearLocalUsers()
                            container.authService.signOut()
                        }
                    } label: {
                        
                        ButtonLabelView(title: "Log out", widthButton: 170)
                        
                    }
                    .padding()
                }
                .alert("Error with account", isPresented: $viewModel.isError) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(viewModel.errorMessage ?? "No description")
                }
            }
        }
    }
}

#Preview {
    UserRecoveryView()
}
