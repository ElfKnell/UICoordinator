//
//  UserFollowers.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/04/2024.
//

import Foundation
import Firebase

class UserFollowers: ObservableObject {
    
    @Published var countFollowers = 0
    @Published var countFollowing = 0
    
    private var userCurentFollowingId: [String] = []
    private var userCurentFollowersId: [String] = []
    private var followersCurrentUsers: [Follow] = []
    
    func setFollowersCurrentUser(userId: String?) async {
        
        do {
            
            guard let currentUserId = userId else { return }
            let followers = try await FollowService.fitchFollow(uid: currentUserId, follow: "follower")
            self.userCurentFollowingId = followers.map({ $0.following })
            self.followersCurrentUsers = followers
            await setFollowingCurrentUser(userId: currentUserId)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setFollowingCurrentUser(userId: String) async {
        
        do {
            
            let following = try await FollowService.fitchFollow(uid: userId, follow: "following")
            self.userCurentFollowersId = following.map({ $0.follower })

        } catch {
            print(error.localizedDescription)
        }
    }
    
    func isFollowingCurrentUser(uid: String) -> Bool {
        
        if userCurentFollowingId.contains(uid) {
            return true
        } else {
            return false
        }
    }
    
    func getFollowersCurrentUserId() -> [String] {
        
        return self.userCurentFollowingId
    }
    
    func getFollowersIdsCurrentUserWithCurrentUserId() -> [String] {
        
        guard let curentUserId = UserService.shared.currentUser?.id else { return [] }
        var ids = self.userCurentFollowingId
        ids.append(curentUserId)
        return ids
    }
    
    func getFollowingsCurrentUserId() -> [String] {
        
        return self.userCurentFollowersId
    }
    
    func getFollowersCurrentUser() -> [Follow] {
        
        return self.followersCurrentUsers
    }
    
    func fetchFollowCount(userId: String) {
        
        Task {
            await getFollowersCount(userId: userId)
            await getFollowingCount(userId: userId)
        }
        
    }
    
    @MainActor
    private func getFollowersCount(userId: String) async {
        
        do {
            countFollowers = try await FollowService.fitchFollowCoutn(uid: userId, follow: "following")
        } catch {
            print("Error count followers: \(error.localizedDescription)")
        }
        
    }
    
    @MainActor
    private func getFollowingCount(userId: String) async {
        
        do {
            countFollowing = try await FollowService.fitchFollowCoutn(uid: userId, follow: "follower")
        } catch {
            print("Error count followers: \(error.localizedDescription)")
            countFollowing = 0
        }
        
    }
    
}
