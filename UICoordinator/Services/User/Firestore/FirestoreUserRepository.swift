//
//  FirestoreUserRepository.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/04/2025.
//

import Foundation
import Firebase

class FirestoreUserRepository: FirestoreUserRepositoryProtocol {
    
    func fetchAllUsers(excluding currentUserId: String) async throws -> [User] {
        
        let snapshot = try await Firestore.firestore()
            .collection("users")
            .whereField("id", isNotEqualTo: currentUserId)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: User.self) }
    }
    
    func fetchUsersByIds(_ ids: [String]) async throws -> [User] {
        
        guard !ids.isEmpty else { return [] }

        let snapshot = try await Firestore.firestore()
            .collection("users")
            .whereField("id", in: ids)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: User.self) }
    }
    
    
}
