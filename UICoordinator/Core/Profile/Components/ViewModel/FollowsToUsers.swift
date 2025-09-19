//
//  CurrentUserFollows.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/03/2025.
//

import Foundation
import FirebaseCrashlytics

class FollowsToUsers: ObservableObject {
    
    @Published var followingUsers = [User]()
    @Published var followerUsers = [User]()
    
    private var localUserServise: LocalUserServiceProtocol
    private var fetchUsers: FetchingUsersServiceProtocol
    
    init(localUserServise: LocalUserServiceProtocol, fetchUsers: FetchingUsersServiceProtocol) {
        
        self.localUserServise = localUserServise
        self.fetchUsers = fetchUsers
    }
    
    @MainActor
    func fetchFollowsToUsers(usersFollowing: [String], currentUser: User?) async {
        
        do {
            
            self.followingUsers.removeAll()
            self.followerUsers.removeAll()
            
            self.followingUsers = try await fetchUsers.fetchUsersByIds(at: usersFollowing)
            
            var users = try await localUserServise.fetchUsersbyLocalUsers(currentUser: currentUser)
            users.removeAll(where: { $0.id == currentUser?.id })
            self.followerUsers = users
            
        } catch {
            
            Crashlytics.crashlytics()
                .setCustomValue(currentUser?.id ?? "nil", forKey: "current_user_id")
            Crashlytics.crashlytics().record(error: error)
        }

    }
}
