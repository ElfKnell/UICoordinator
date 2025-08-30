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
    @Published var isError = false
    @Published var errorMessage: String? = nil
    
    private var localUserServise: LocalUserServiceProtocol
    private var fetchUsers: FetchingUsersServiceProtocol
    
    init(localUserServise: LocalUserServiceProtocol, fetchUsers: FetchingUsersServiceProtocol) {
        
        self.localUserServise = localUserServise
        self.fetchUsers = fetchUsers
    }
    
    @MainActor
    func fetchFollowsToUsers(usersFollowing: [String], curretnUser: User?) async {
        
        isError = false
        errorMessage = nil
        
        do {
            
            self.followingUsers.removeAll()
            self.followerUsers.removeAll()
            
            self.followingUsers = try await fetchUsers.fetchUsersByIds(at: usersFollowing)
            
            var users = try await localUserServise.fetchUsersbyLocalUsers(currentUser: curretnUser)
            users.removeAll(where: { $0.id == curretnUser?.id })
            self.followerUsers = users
            
        } catch {
            isError = true
            errorMessage = error.localizedDescription
            Crashlytics.crashlytics().record(error: error)
        }

    }
}
