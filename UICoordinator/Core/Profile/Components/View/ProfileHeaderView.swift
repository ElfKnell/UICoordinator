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
                    
                    if user.id == CurrentUserService.sharedCurrent.currentUser?.id {
                        NavigationLink {
                            ExploreView(users: followToUser.followerUsers)
                        } label: {
                            BottomHeaderView(title: "Following",
                                             counts: "\(userFollow.countFollowing)",
                                             imageName: "person.3.fill")
                        }
                        
                        NavigationLink {
                            ExploreView(users: followToUser.followingUsers)
                        } label: {
                            BottomHeaderView(title: "Followers",
                                             counts: "\(userFollow.countFollowers)",
                                             imageName: "person.crop.circle.fill.badge.checkmark")
                        }
                    } else {
                        
                        BottomHeaderView(title: "Following",
                                         counts: "\(userFollow.countFollowing)",
                                         imageName: "person.3.fill")
                        
                        BottomHeaderView(title: "Followers",
                                         counts: "\(userFollow.countFollowers)",
                                         imageName: "person.crop.circle.fill.badge.checkmark")
                    }
                    
                    if user.id == CurrentUserService.sharedCurrent.currentUser?.id {
                        
                        NavigationLink {
                            ExploreView(users: userLikes.usersLike)
                        } label: {
                            BottomHeaderView(title: "Likes",
                                             counts: "\(userLikes.countLikes)",
                                             imageName: "heart.fill")
                        }
                        
                    } else {
                        
                        BottomHeaderView(title: "Likes",
                                         counts: "\(userLikes.countLikes)",
                                         imageName: "heart.fill")
                    }
                }
            }
        }
        .onAppear {
            Task {
                await userLikes.fetchLikes(userId: user.id)
                
                await followToUser.fetchFollowsToUsers(usersFollowing: userFollow.getFollowingsCurrentUserId())
            }
        }
    }
}

#Preview {
    ProfileHeaderView(user: DeveloperPreview.user)
}
