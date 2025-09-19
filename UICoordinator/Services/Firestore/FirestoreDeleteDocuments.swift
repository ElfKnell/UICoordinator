//
//  FirestoreDocumentsCount.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/09/2025.
//

import Foundation
import Firebase

class FirestoreDeleteDocuments: FirestoreDeleteDocumentsProtocol {
    
    func deleteDocumentsWithDependencies(
        collectionName: String,
        userId: String,
        dependencyDeleter: @escaping (_ documentId: String) async throws -> Void
    ) async throws {
        
        let db = Firestore.firestore()
        
        let snapshot = try await db.collection(collectionName)
            .whereField("ownerUid", isEqualTo: userId)
            .getDocuments()
        
        guard !snapshot.documents.isEmpty else {
            return
        }
        
        let chunkedDocs = snapshot.documents.chunked(into: 500)
        
        for chunk in chunkedDocs {
            
            try await withThrowingTaskGroup(of: Void.self) { group in
                for doc in chunk {
                    group.addTask {
                        do {
                            try await dependencyDeleter(doc.reference.documentID)
                        } catch {
                            Crashlytics.crashlytics().record(error: error)
                        }
                    }
                }
                
                try await group.waitForAll()
            }
            
            let batch = db.batch()
            
            for doc in chunk {
                
                batch.deleteDocument(doc.reference)
                
            }
            
            try await batch.commit()
        }
    }
    
    func deleteDocumentsWithDependencies(
        collectionName: String,
        userId: String
    ) async throws {
        try await deleteDocumentsWithDependencies(
            collectionName: collectionName,
            userId: userId,
            dependencyDeleter: { _ in }
        )
    }
}
