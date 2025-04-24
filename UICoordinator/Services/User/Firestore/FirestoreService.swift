//
//  FirestoreService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/04/2025.
//

import Foundation
import Firebase

class FirestoreService: FirestoreServiceProtocol {
    
    func getUserDocument(uid: String) async throws -> DocumentSnapshotProtocol {
        
        let snapshot = try await Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument()
        return snapshot
    }
    
    func deleteUserDocument() async throws {
        
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else { throw UserError.userNotFound }
        
        try await Firestore.firestore()
            .collection("users")
            .document(uid)
            .delete()
        
        try await user?.delete()
    }
    
}
