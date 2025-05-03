//
//  UserFollowers.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/04/2024.
//

import Observation
import Foundation
import SwiftData

@Observable
@MainActor
class UserFollowers: UserFollowersProtocol {
    
    var countFollowers: Int = 0
    var countFollowing: Int = 0
    
    var followingIdsForCurrentUser: [String] = []
    
    private var followersIdsForCurrentUser: [String] = []
    var followersCurrentUsers: [Follow] = []
    
    private let checkedFollowing: CheckedLocalUsersByFollowingProtocol
    private let fetchingService: FetchingFollowAndFollowCountProtocol
    
    init(fetchingService: FetchingFollowAndFollowCountProtocol,
         checkedFollowing: CheckedLocalUsersByFollowingProtocol) {
        
        self.fetchingService = fetchingService
        self.checkedFollowing = checkedFollowing
    }
    
    func loadFollowersCurrentUser(userId: String?) async {
        
        guard let currentUserId = userId else { return }
        let followers = await fetchingService.fetchFollow(uid: currentUserId, byField: .followerField)
        
        if followers.isEmpty {
            self.followersCurrentUsers = []
            self.followingIdsForCurrentUser = []
            await clearLocalUsers()
        } else {
            self.followersCurrentUsers = followers
            self.followingIdsForCurrentUser = followers.map({ $0.following })
            await loadFollowingCurrentUser(userId: currentUserId)
            await checkedFollowing.addLocalUsersByFollowingToStore(follows: self.followingIdsForCurrentUser)
            await checkedFollowing.removeUnfollowedLocalUsers(follows: self.followingIdsForCurrentUser)
        }
    }
    
    func clearLocalUsers() async {
        await checkedFollowing.clearAllLocalUsers()
    }
    
    private func loadFollowingCurrentUser(userId: String) async {
        
        let following = await fetchingService.fetchFollow(uid: userId, byField: .followingField)
        self.followersIdsForCurrentUser = following.map({ $0.follower })
    }
    
    func isFollowingCurrentUser(uid: String) -> Bool {
        
        return followingIdsForCurrentUser.contains(uid)
    }
    
    func updateFollowCounts(for userId: String) {
        
        Task {
            async let followersCount = await fetchingService.fetchFollowCount(uid: userId, byField: .followerField)
            async let followingCount = await fetchingService.fetchFollowCount(uid: userId, byField: .followingField)
                    
                    // Wait for both async tasks to finish
            await self.countFollowers = followersCount
            await self.countFollowing = followingCount
        }
    }
}
