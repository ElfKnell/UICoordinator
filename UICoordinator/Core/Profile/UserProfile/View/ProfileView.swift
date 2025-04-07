//
//  ProfileView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/02/2024.
//

import SwiftUI

struct ProfileView: View {
    
    let user: User
    @StateObject var viewModel = ProfileViewModel()
    @EnvironmentObject var userFollow: UserFollowers
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 20) {
                    
                    ProfileHeaderView(user: user)
                    
                    HStack {
                        
                        Spacer()
                        
                        Button {
                            Task {
                                if userFollow.checkFollow(uid: user.id) {
                                    try await viewModel.unfollow(uId: user.id, followers: userFollow.followers)
                                } else {
                                    try await viewModel.follow(user: user)
                                }
                                dismiss()
                            }
                        } label: {
                            Text(userFollow.checkFollow(uid: user.id) ? "Unfollow" : "Follow")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, minHeight: 32)
                                .background(.black)
                                .cornerRadius(11)
                        }
                        
                        Spacer()
                        
                        NavigationLink {
                            UserLocationsView(userId: user.id)
                        } label: {
                            Text("Map")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, minHeight: 32)
                                .background(.black)
                                .cornerRadius(11)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .frame(height: 39)
                    .modifier(CornerRadiusModifier())
                    .padding()
                    
                    UserContentListView(user: user)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .onAppear {
                Task {
                    try await userFollow.fetchUserFollows(uid: user.id)
                }
            }
        }
    }
}

#Preview {
    ProfileView(user: DeveloperPreview.user)
}
