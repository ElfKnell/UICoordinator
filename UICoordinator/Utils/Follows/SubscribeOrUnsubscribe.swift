//
//  SubscribeOrUnsubscribe.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/04/2025.
//

import Firebase
import SwiftData

class SubscribeOrUnsubscribe: SubscribeOrUnsubscribeProtool {
    
    func subscribed(with user: User) async {
        
        do {
            
            guard let currentUserId = UserService.shared.currentUser?.id else { return }
            let follow = Follow(follower: currentUserId, following: user.id, updateTime: Timestamp())
            
            try await FollowService.uploadeFollow(follow)
            
        } catch {
            print("ERROR FOLLOE: \(error.localizedDescription)")
        }
        
    }
    
    func unsubcribed(with user: User, followersCurrentUsers: [Follow]) async {
        
        do {
            
            for follower in followersCurrentUsers {
                if follower.following == user.id {
                    try await FollowService.deleteFollow(followId: follower.id)
                    return
                }
            }
        } catch {
            print("ERROR DELETE FOLLOW: \(error.localizedDescription)")
        }
    }
    
    
}
