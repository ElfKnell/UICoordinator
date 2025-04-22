//
//  CurrentUserProfileView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/02/2024.
//

import SwiftUI

struct CurrentUserProfileView: View {
    
    @EnvironmentObject var userFollow: UserFollowers
    
    @StateObject var viewModel = CurrentUserProfileViewModel()
    @State var currentUser: User
    
    init() {
        if let user = CurrentUserService.sharedCurrent.currentUser {
            _currentUser = .init(wrappedValue: user)
        } else {
            _currentUser = .init(wrappedValue: DeveloperPreview.user)
        }
    }
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            if viewModel.isLoaded {
                LoadingView(width: 300, height: 300)
            } else {
                VStack(spacing: 20) {
                    
                    ProfileHeaderView(user: currentUser)
                    
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
            }
        }
        .onAppear {
            
            userFollow.fetchFollowCount(userId: currentUser.id)
            
        }
        .onChange(of: viewModel.isSaved) {
            
            Task {
                viewModel.isLoaded = true
                currentUser = await viewModel.updateUser()
                viewModel.isLoaded = false
            }
            
        }
        .sheet(isPresented: $viewModel.showEditProfile, content: {
            EditProfileView(user: currentUser, isSaved: $viewModel.isSaved)
        })
    }
}

#Preview {
    CurrentUserProfileView()
}
