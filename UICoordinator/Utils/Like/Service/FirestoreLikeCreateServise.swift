//
//  FirestoreLikeCreateServise.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 04/05/2025.
//

import Foundation
import Firebase

class FirestoreLikeCreateServise: FirestoreLikeCreateServiseProtocol {
    
    let db = Firestore.firestore()
    
    func addDocument(collectionName: CollectionNameForLike, data: [String : Any]) async throws {
        
        try await db
            .collection(collectionName.value)
            .addDocument(data: data)
        
    }
     
}
