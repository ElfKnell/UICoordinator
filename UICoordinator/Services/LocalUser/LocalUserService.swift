//
//  LocalUserService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 15/04/2025.
//

import Foundation
import SwiftData

class LocalUserService {
    
    private var userActor: UserDataActor?
    
    func fetchUsersbyLocalUsers() async throws -> [User] {
        
        var users = [User]()
        guard let currentUser = UserService.shared.currentUser else { return [] }
        users.append(currentUser)
        
        try await ensureActorReady()
        
        let allUsers = try await userActor?.fetchAllUsers()
        
        if let allUsers = allUsers {
            for userLocat in allUsers {
                users.append(userLocat.toFirebaseUser())
            }
        }
        return users
    }
    
    private func ensureActorReady() async throws {
        if userActor == nil {
            let container = try ModelContainer(for: LocalUser.self)
            userActor = UserDataActor(container: container)
        }
    }
}
