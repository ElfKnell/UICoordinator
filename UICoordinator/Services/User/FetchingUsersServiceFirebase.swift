//
//  FetchingUsersServiceFirebase.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/04/2025.
//

import Foundation
import Firebase

class FetchingUsersServiceFirebase: FetchingUsersServiceProtocol {
    
    private let repository: FirestoreUserRepositoryProtocol
        
        init(repository: FirestoreUserRepositoryProtocol) {
            self.repository = repository
        }
    
    func fetchUsers(withId currentUserId: String) async throws -> [User] {
        
        return try await repository.fetchAllUsers(excluding: currentUserId)
    }
    
    func fetchUsersByIds(at ids: [String]) async throws -> [User] {
        
        return try await repository.fetchUsersByIds(ids)
        
    }
}
