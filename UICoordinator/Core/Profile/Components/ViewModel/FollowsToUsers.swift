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
    
    private var localUserServise = LocalUserService()
    
    @MainActor
    func fetchFollowsToUsers(usersFollowing: [String]) async {
        self.followingUsers.removeAll()
        self.followerUsers.removeAll()
        
        self.followingUsers = await UserService.fetchUsersByIds(at: usersFollowing)
        var users = await localUserServise.fetchUsersbyLocalUsers()
        
        users.removeAll(where: { $0.id == CurrentUserService.sharedCurrent.currentUser?.id })
        self.followerUsers = users
    }
}
