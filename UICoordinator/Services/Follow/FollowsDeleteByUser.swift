//
//  FollowsDeleteByUser.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/09/2025.
//

import Foundation
import Firebase

class FollowsDeleteByUser: FollowsDeleteByUserProtocol {
    
    func deleteFollowsByUser(userId: String) async throws {
        
        let db = Firestore.firestore()
        
        let followerSnapshot = try await db.collection("follow")
            .whereField("follower", isEqualTo: userId)
            .getDocuments()
        
        let followingSnapshot = try await db.collection("follow")
            .whereField("following", isEqualTo: userId)
            .getDocuments()
        
        let allDocs = followerSnapshot.documents + followingSnapshot.documents
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
    
    func deleteFollowRelationship(curentUserId: String, userId: String) async throws {
        
        let db = Firestore.firestore()
        
        async let followerSnapshot = try await db.collection("follow")
            .whereField("follower", isEqualTo: userId)
            .whereField("following", isEqualTo: curentUserId)
            .getDocuments()
        
        async let followingSnapshot = try await db.collection("follow")
            .whereField("follower", isEqualTo: curentUserId)
            .whereField("following", isEqualTo: userId)
            .getDocuments()
        
        let allDocs = try await followerSnapshot.documents + followingSnapshot.documents
        
        let batch = db.batch()
        
        for doc in allDocs {
            batch.deleteDocument(doc.reference)
        }
            
        try await batch.commit()
        
    }
}
