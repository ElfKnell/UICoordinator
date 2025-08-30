//
//  UserFollowers.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/04/2024.
//

import Observation
import Foundation
import SwiftData
import FirebaseCrashlytics

@Observable
@MainActor
class UserFollowers: UserFollowersProtocol {
    
    var countFollowers: Int = 0
    var countFollowing: Int = 0
    
    var followingIdsForCurrentUser: [String] = []
    
    var followersIdsForCurrentUser: [String] = []
    var followersCurrentUsers: [Follow] = []
    
    private let checkedFollowing: CheckedLocalUsersByFollowingProtocol
    private let fetchingService: FetchingFollowAndFollowCountProtocol
    
    init(fetchingService: FetchingFollowAndFollowCountProtocol,
         checkedFollowing: CheckedLocalUsersByFollowingProtocol) {
        
        self.fetchingService = fetchingService
        self.checkedFollowing = checkedFollowing
    }
    
    func loadFollowersCurrentUser(userId: String?) async {
        
        guard let currentUserId = userId else {
            Crashlytics.crashlytics().log("User ID is nil in loadFollowersCurrentUser")
            return
        }
        
        do {
            
            let followers = try await fetchingService.fetchFollow(uid: currentUserId, byField: .followerField)
            
            if followers.isEmpty {
                
                self.followersCurrentUsers = []
                self.followingIdsForCurrentUser = []
                await clearLocalUsers()
                
            } else {
                
                self.followersCurrentUsers = followers
                self.followingIdsForCurrentUser = followers.map({ $0.following })
                
                try await checkedFollowing
                    .addLocalUsersByFollowingToStore(follows: self.followingIdsForCurrentUser)
                try await checkedFollowing
                    .removeUnfollowedLocalUsers(follows: self.followingIdsForCurrentUser)
                
            }
            try await loadFollowingCurrentUser(userId: currentUserId)
            
        } catch {
            
            Crashlytics.crashlytics().record(error: error)
            Crashlytics.crashlytics().setCustomValue(currentUserId, forKey: "userId")
            Crashlytics.crashlytics().log("Failed to load followers for user \(currentUserId)")
        }
    }
    
    func clearLocalUsers() async {
        
        do {
            
            try await checkedFollowing.clearAllLocalUsers()
            
        } catch {
            Crashlytics.crashlytics().record(error: error)
            Crashlytics.crashlytics().setCustomValue("clearLocalUsers", forKey: "clear")
            Crashlytics.crashlytics().log("Failed clear Local Users")
        }
    }
    
    private func loadFollowingCurrentUser(userId: String) async throws {
        
        let following = try await fetchingService.fetchFollow(uid: userId, byField: .followingField)
        self.followersIdsForCurrentUser = following.map({ $0.follower })
    }
    
    func isFollowingCurrentUser(uid: String) -> Bool {
        
        return followingIdsForCurrentUser.contains(uid)
    }
    
    func updateFollowCounts(for userId: String) {
        
        Task {
            
            do {
                
                async let followersCount = await fetchingService.fetchFollowCount(uid: userId, byField: .followerField)
                async let followingCount = await fetchingService.fetchFollowCount(uid: userId, byField: .followingField)
                
                try await self.countFollowers = followersCount
                try await self.countFollowing = followingCount
                
            } catch {
                Crashlytics.crashlytics().record(error: error)
                Crashlytics.crashlytics().log("Failed to update follow counts for userId: \(userId)")
            }
        }
        
    }
}
