//
//  ProfileHeaderView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/02/2024.
//

import SwiftUI

struct ProfileHeaderView: View {
    
    let user: User
    @EnvironmentObject var container: DIContainer
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
                    
                    if user.id == container.currentUserService.currentUser?.id {
                        NavigationLink {
                            ExploreView(users: followToUser.followerUsers)
                        } label: {
                            BottomHeaderView(title: "Following",
                                             counts: "\(container.userFollow.countFollowers)",
                                             imageName: "person.3.fill")
                        }
                        
                        NavigationLink {
                            ExploreView(users: followToUser.followingUsers)
                        } label: {
                            BottomHeaderView(title: "Followers",
                                             counts: "\(container.userFollow.countFollowing)",
                                             imageName: "person.crop.circle.fill.badge.checkmark")
                        }
                    } else {
                        
                        BottomHeaderView(title: "Following",
                                         counts: "\(container.userFollow.countFollowers)",
                                         imageName: "person.3.fill")
                        
                        BottomHeaderView(title: "Followers",
                                         counts: "\(container.userFollow.countFollowing)",
                                         imageName: "person.crop.circle.fill.badge.checkmark")
                    }
                    
                    if user.id == container.currentUserService.currentUser?.id {
                        
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
        .task {
            
            await userLikes.fetchLikes(userId: user.id)
            
            await followToUser.fetchFollowsToUsers(usersFollowing: container.userFollow.followingIdsForCurrentUser, curretnUser: container.currentUserService.currentUser)
        }
    }
}

#Preview {
    ProfileHeaderView(user: DeveloperPreview.user)
}
