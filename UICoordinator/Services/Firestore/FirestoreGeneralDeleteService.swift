//
//  FirestoreGeneralDeleteService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/04/2025.
//

import Foundation
import Firebase

class FirestoreGeneralDeleteService: FirestoreGeneralDeleteProtocol {
    
    private let db: FirestoreProtocol

    init(db: FirestoreProtocol) {
        self.db = db
    }

    func deleteDocument(from collection: String, documentId: String) async throws {
        
        try await db
            .collection(collection)
            .document(documentId)
            .delete()

    }
}
