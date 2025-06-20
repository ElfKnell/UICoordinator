//
//  SubscribeOrUnsubscribe.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/04/2025.
//

import Firebase
import SwiftData

class SubscribeOrUnsubscribe: SubscribeOrUnsubscribeProtocol {
    
    private let followServise: FollowServiceProtocol
    
    init(followServise: FollowServiceProtocol) {
        self.followServise = followServise
    }
    
    func subscribed(with user: User, currentUserId: String?) async {
        
        guard let currentUserId = currentUserId else { return }
        let follow = Follow(follower: currentUserId, following: user.id, updateTime: Timestamp())
        
        await followServise.uploadeFollow(follow)
        
    }
    
    func unsubcribed(with user: User, followersCurrentUsers: [Follow]) async {
        
        for follower in followersCurrentUsers {
            if follower.following == user.id {
                await followServise.deleteFollow(followId: follower.id)
                return
            }
        }
    }
}
