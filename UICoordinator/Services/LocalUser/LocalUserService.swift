//
//  LocalUserService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 15/04/2025.
//

import Foundation
import SwiftData

class LocalUserService: LocalUserServiceProtocol {
    
    private var userActor: UserDataActor?
    
    func fetchLocalUsers() async -> [LocalUser] {
        
        do {
            var users = [LocalUser]()
            
            try await ensureActorReady()
            
            let allUsers = try await userActor?.fetchAllUsers()
            
            if let allUsers = allUsers {
                users = allUsers
            }
            return users
            
        } catch {
            print("ERROR fetch users by localUsers: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchUsersbyLocalUsers(currentUser: User?) async -> [User] {
        
        do {
            var users = [User]()
            guard let currentUser else { return [] }
            users.append(currentUser)
            
            try await ensureActorReady()
            
            let allUsers = try await userActor?.fetchAllUsers()
            
            if let allUsers = allUsers {
                for userLocat in allUsers {
                    users.append(userLocat.toFirebaseUser())
                }
            }
            return users
        } catch {
            print("ERROR fetch users by localUsers: \(error.localizedDescription)")
            return []
        }
    }
    
    private func ensureActorReady() async throws {
        if userActor == nil {
            let container = try ModelContainer(for: LocalUser.self)
            userActor = UserDataActor(container: container)
        }
    }
}
