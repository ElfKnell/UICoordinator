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
    private var fetchUsers = FetchingUsersServiceFirebase(repository: FirestoreUserRepository())
    
    @MainActor
    func fetchFollowsToUsers(usersFollowing: [String], curretnUser: User?) async {
        self.followingUsers.removeAll()
        self.followerUsers.removeAll()
        
        self.followingUsers = await fetchUsers.fetchUsersByIds(at: usersFollowing)
        var users = await localUserServise.fetchUsersbyLocalUsers(currentUser: curretnUser)
        
        users.removeAll(where: { $0.id == curretnUser?.id })
        self.followerUsers = users
    }
}
