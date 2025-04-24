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
    
    func fetchUsers(withId currentUserId: String) async -> [User] {
        
        do {
            
            return try await repository.fetchAllUsers(excluding: currentUserId)
            
        } catch {
            print("ERROR FETCH USERS: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchUsersByIds(at ids: [String]) async -> [User] {
        
        do {
            
            return try await repository.fetchUsersByIds(ids)
            
        } catch {
            
            print("ERROR FETCH USERS at ids: \(error.localizedDescription)")
            return []
        }
    }
}
