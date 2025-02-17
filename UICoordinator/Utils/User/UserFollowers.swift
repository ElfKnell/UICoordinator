//
//  UserFollowers.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/04/2024.
//

import Foundation

class UserFollowers: ObservableObject {
    @Published var followers = [Follow]()
    @Published var userFollowing = [Follow]()
    @Published var userFollowers = [Follow]()
    
    init() {
        Task {
            try await fetchFollowers()
        }
    }
    
    @MainActor
    func fetchFollowers() async throws {
        guard let currentUserId = UserService.shared.currentUser?.id else { return }
        self.followers = try await FollowService.fitchFollow(uid: currentUserId, follow: "follower")
    }
    
    @MainActor
    func checkFollow(uid: String) -> Bool {
        
        for follower in self.followers {
            if follower.following == uid {
                return true
            }
        }
        return false
    }
    
    @MainActor
    func fetchUserFollowers(uid: String) async throws {
        self.userFollowers = try await FollowService.fitchFollow(uid: uid, follow: "following")
    }
    
    @MainActor
    func fetchUserFollowing(uid: String) async throws {
        self.userFollowing = try await FollowService.fitchFollow(uid: uid, follow: "follower")
    }
    
    @MainActor
    func fetchUserFollows(uid: String) async throws {
        try await fetchUserFollowers(uid: uid)
        try await fetchUserFollowing(uid: uid)
    }
}
