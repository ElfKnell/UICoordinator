//
//  FirestoreFollowServiceCreate.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/04/2025.
//

import Foundation
import Firebase

class FirestoreGeneralServiceCreate: FirestoreGeneralCreateServiseProtocol {
    
    let db = Firestore.firestore()
    
    func addDocument(from collection: String, data: [String : Any]) async throws {
        try await db
            .collection(collection)
            .addDocument(data: data)
    }
    
}
