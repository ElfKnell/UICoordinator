//
//  BlocksDeleteService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 17/09/2025.
//

import Foundation
import Firebase

class BlocksDeleteService: BlocksDeleteServiceProtocol {
    
    func deleteBlocksByUser(userId: String) async throws {
        
        let db = Firestore.firestore()
        
        let blockerSnapshot = try await db.collection("block")
            .whereField("blocker", isEqualTo: userId)
            .getDocuments()
        
        let blockedSnapshot = try await db.collection("block")
            .whereField("blocked", isEqualTo: userId)
            .getDocuments()
        
        let allDocs = blockerSnapshot.documents + blockedSnapshot.documents
        guard !allDocs.isEmpty else { return }
        
        let chunkedDocs = allDocs.chunked(into: 500)
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            for chunk in chunkedDocs {
                group.addTask {
                    let batch = db.batch()
                    for doc in chunk {
                        batch.deleteDocument(doc.reference)
                    }
                    try await batch.commit()
                }
            }
            try await group.waitForAll()
        }
    }
    
}
