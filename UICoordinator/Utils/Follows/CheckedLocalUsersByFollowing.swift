//
//  CheckedLocalUsersByFollowing.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/04/2025.
//

import Foundation
import SwiftData

class CheckedLocalUsersByFollowing: CheckedLocalUsersByFollowingProtocol {
    
    private var userActor: UserDataActorProtocol?
    private let localUserService: LocalUserServiceProtocol
    private let userService: UserServiceProtocol
    private let containerProvider: () throws -> ModelContainer
    
    init(
            localUserService: LocalUserServiceProtocol,
            userService: UserServiceProtocol,
            containerProvider: @escaping () throws -> ModelContainer
        ) {
            self.localUserService = localUserService
            self.userService = userService
            self.containerProvider = containerProvider
        }
    
    func addLocalUsersByFollowingToStore(follows: [String]) async {
        
        do {
            let users = await localUserService.fetchLocalUsers()
            
            try await ensureActorReady()
            
            for follower in follows {
                if !users.contains(where: { $0.id == follower }) {
                    
                    let user = try await userService.fetchUser(withUid: follower)
                    
                    try await userActor?.save(user: user.toLocalUser())
                }
            }
        } catch {
            print("ERROR checking followers: \(error.localizedDescription)")
        }
    }
    
    func removeUnfollowedLocalUsers(follows: [String]) async {
        do {
            let users = await localUserService.fetchLocalUsers()
            try await ensureActorReady()

            for localUser in users {
                if !follows.contains(localUser.id) {
                    try await userActor?.delete(user: localUser)
                }
            }
        } catch {
            print("ERROR removing unfollowed users: \(error.localizedDescription)")
        }
    }
    
    func clearAllLocalUsers() async {
        do {
            try await ensureActorReady()
            try await userActor?.deleteAllUsers()
        } catch {
            print("ERROR clearing local users: \(error.localizedDescription)")
        }
    }
    
    private func ensureActorReady() async throws {
        if userActor == nil {
            let container = try containerProvider()
            userActor = UserDataActor(container: container)
        }
    }
    
    // MARK: - Testing Utility

    @MainActor
    func setActorForTesting(_ actor: UserDataActorProtocol) {
        self.userActor = actor
    }
}
