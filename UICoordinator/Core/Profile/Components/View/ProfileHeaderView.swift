//
//  ProfileHeaderView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/02/2024.
//

import SwiftUI

struct ProfileHeaderView: View {
    
    let user: User
    @EnvironmentObject var userFollow: UserFollowers
    @StateObject var userLikes = UserLikeCount()
    @StateObject var followToUser = FollowsToUsers()
    
    var body: some View {
        VStack(spacing: 16) {
            
            VStack {
                
                CircularProfileImageView(user: user, size: .large)
                
                Group {
                    Text(user.fullname)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    if let bio = user.bio {
                        Text(bio)
                            .font(.footnote)
                    }
                }
                
                Divider()
                
                HStack(spacing: 16) {
                    
                    if userFollow.userFollowing.count == followToUser.followingUsers.count &&
                        userFollow.userFollowers.count == followToUser.followerUsers.count {
                        
                        NavigationLink {
                            ExploreView(users: followToUser.followingUsers)
                        } label: {
                            BottomHeaderView(title: "Following",
                                             counts: "\(userFollow.userFollowing.count)",
                                             imageName: "person.3.fill")
                        }
                    
                        NavigationLink {
                            ExploreView(users: followToUser.followerUsers)
                        } label: {
                            BottomHeaderView(title: "Followers",
                                             counts: "\(userFollow.userFollowers.count)",
                                             imageName: "person.crop.circle.fill.badge.checkmark")
                        }
                    }
                    
                    NavigationLink {
                        ExploreView(users: userLikes.usersLike)
                    } label: {
                        BottomHeaderView(title: "Likes",
                                         counts: "\(userLikes.countLikes)",
                                         imageName: "heart.fill")
                    }
                }
            }
        }
        .onAppear {
            Task {
                try await userLikes.fetchLikes(userId: user.id)
                
                try await followToUser.fetchFollowsToUsers(usersFollowing: userFollow.userFollowing, usersFollower: userFollow.userFollowers)
            }
        }
    }
}

#Preview {
    ProfileHeaderView(user: DeveloperPreview.user)
}
