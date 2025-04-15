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
    func fetchFollowsToUsers(usersFollowing: [String], usersFollower: [String]) async {
        self.followingUsers.removeAll()
        self.followerUsers.removeAll()
        
        self.followingUsers = await UserService.fetchUsersByIds(at: usersFollowing)
        self.followerUsers = await UserService.fetchUsersByIds(at: usersFollower)
    }
}
