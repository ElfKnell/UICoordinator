//
//  FirestoreFollowServiceCreate.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/04/2025.
//

import Foundation
import Firebase

class FirestoreFollowServiceCreate: FirestoreFolloweCreateServiseProtocol {
    
    let db = Firestore.firestore()
    
    func addDocument(data: [String : Any]) async throws {
        try await db
            .collection("Follow")
            .addDocument(data: data)
    }
    
}
