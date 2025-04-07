//
//  CurrentUserFollows.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/03/2025.
//

import Foundation

class FollowsToUsers: ObservableObject {
    @Published var followingUsers = [User]()
    @Published var followerUsers = [User]()
    
    @MainActor
    func fetchFollowsToUsers(usersFollowing: [Follow], usersFollower: [Follow]) async throws {
        do {
            self.followingUsers = []
            self.followerUsers = []
            
            let followings = Set(usersFollowing.map { $0.following })
            
            let followers = Set(usersFollower.map { $0.follower })
            
            for following in followings {
                let user = try await UserService.fetchUser(withUid: following)
                self.followingUsers.append(user)
            }
            
            for follower in followers {
                let user = try await UserService.fetchUser(withUid: follower)
                self.followerUsers.append(user)
            }
        } catch {
            print("ERROR fetch likes: \(error.localizedDescription)")
        }
    }
}
