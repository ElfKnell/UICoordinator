//
//  SubscribeOrUnsubscribe.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/04/2025.
//

import Firebase
import SwiftData
import FirebaseCrashlytics

class SubscribeOrUnsubscribe: SubscribeOrUnsubscribeProtocol {
    
    private let followService: FollowServiceProtocol
    
    init(followServise: FollowServiceProtocol) {
        self.followService = followServise
    }
    
    func subscribed(with user: User, currentUserId: String?) async {
        
        guard let currentUserId = currentUserId else {
            Crashlytics.crashlytics().log("User ID is nil in loadFollowersCurrentUser")
            return
        }
        
        let follow = Follow(follower: currentUserId, following: user.id, updateTime: Timestamp())
        
        do {
            
            try await followService.uploadeFollow(follow)
            
        } catch {
            Crashlytics.crashlytics().record(error: error)
            Crashlytics.crashlytics().setCustomValue(currentUserId, forKey: "userId")
            Crashlytics.crashlytics().log("Failed to subscribe for user \(user.username)")
        }
    }
    
    func unsubcribed(with user: User, followersCurrentUsers: [Follow]) async {
        
        do {
            
            for follower in followersCurrentUsers {
                if follower.following == user.id {
                    try await followService.deleteFollow(followId: follower.id)
                    return
                }
            }
            
        } catch {
            Crashlytics.crashlytics().record(error: error)
            Crashlytics.crashlytics().setCustomValue(user.id, forKey: "userId")
            Crashlytics.crashlytics().log("Failed to unsubscribe for user \(user.username)")
        }
    }
}
