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
        
        ScrollView(showsIndicators: false) {
            
            VStack(spacing: 20) {
                
                ProfileHeaderView(user: user)
                
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
                        .frame(width: 352, height: 32)
                        .background(.black)
                        .cornerRadius(8)
                }
                
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

#Preview {
    ProfileView(user: DeveloperPreview.user)
}
