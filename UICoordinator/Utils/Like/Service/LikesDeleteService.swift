//
//  LikesDeleteService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/06/2025.
//

import Foundation
import Firebase
import FirebaseCrashlytics

class LikesDeleteService: LikesDeleteServiceProtocol {
    
    func likesDelete(objectId: String, collectionName: CollectionNameForLike) async throws {
        
        let db = Firestore.firestore()
        
        let snapshot = try await db
            .collection(collectionName.value)
            .whereField("colloquyId", isEqualTo: objectId)
            .getDocuments()
        
        guard !snapshot.documents.isEmpty else {
            return
        }
        
        let chunkedDocs = snapshot.documents.chunked(into: 500)
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            for chunk in chunkedDocs {
                
                group.addTask {
                    
                    let batch = db.batch()
                    
                    for doc in chunk {
                        batch.deleteDocument(doc.reference)
                    }
                    
                    do {
                        try await batch.commit()
                    } catch {
                        Crashlytics.crashlytics().record(error: error)
                    }
                }
            }
            try await group.waitForAll()
        }
    }
}
