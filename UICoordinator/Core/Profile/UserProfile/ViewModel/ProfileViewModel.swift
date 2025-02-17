//
//  ProfileViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/04/2024.
//

import Firebase

class ProfileViewModel: ObservableObject {
    
    func follow(user: User) async throws {
        
        guard let currentUserId = UserService.shared.currentUser?.id else { return }
        let follow = Follow(follower: currentUserId, following: user.id, updateTime: Timestamp())
        
        try await FollowService.uploadeFollow(follow)
    }
    
    func unfollow(uId: String, followers: [Follow]) async throws {
        
        for follower in followers {
            if follower.following == uId {
                try await FollowService.deleteFollow(followId: follower.id)
                break
            }
        }
    }
}
