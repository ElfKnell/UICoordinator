//
//  CurrentUserProfileView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/02/2024.
//

import SwiftUI

struct CurrentUserProfileView: View {
    
    @EnvironmentObject var container: DIContainer
    @StateObject var viewModel = CurrentUserProfileViewModel()
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView(showsIndicators: false) {
                if viewModel.isLoaded {
                    LoadingView(size: 300)
                } else {
                    if let currentUser = container.currentUserService.currentUser {
                        VStack(spacing: 20) {
                            
                            ProfileHeaderFactory.make(user: currentUser)
                            
                            Button {
                                viewModel.showEditProfile.toggle()
                            } label: {
                                Text("Edit profile")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black)
                                    .frame(width: 352, height: 32)
                                    .background(.white)
                                    .modifier(CornerRadiusModifier())
                            }
                            
                            UserContentListView(user: currentUser)
                        }
                    } else {
                        Text("User not found")
                            .font(.title)
                    }
                }
            }
            .task {
                
                if let user = container.currentUserService.currentUser {
                    container.userFollow.updateFollowCounts(for: user.id)
                }
                
                await container.authService.checkUserSession()
                await container.blockService
                    .fetchBlockers(container
                        .currentUserService.currentUser)
                
            }
            .onChange(of: viewModel.isSaved) {
                
                Task {
                    viewModel.isLoaded = true
                    try await container.currentUserService.updateCurrentUser()
                    viewModel.isLoaded = false
                }
                
            }
            .sheet(isPresented: $viewModel.showEditProfile) {
                if let currentUser = container.currentUserService.currentUser {
                    EditProfileView(user: currentUser, isSaved: $viewModel.isSaved)
                }
            }
        }
    }
}

#Preview {
    CurrentUserProfileView()
}
