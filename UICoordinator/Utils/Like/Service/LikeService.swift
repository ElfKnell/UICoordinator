//
//  LikeService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 01/06/2024.
//

import Foundation
import Firebase

class LikeService: LikeServiceProtocol {
    
    private let serviceCreate: FirestoreLikeCreateServiseProtocol
    private let serviceDetete: FirestoreGeneralDeleteProtocol
    
    init(serviceCreate: FirestoreLikeCreateServiseProtocol,
         serviceDetete: FirestoreGeneralDeleteProtocol) {
        
        self.serviceCreate = serviceCreate
        self.serviceDetete = serviceDetete
        
    }
    
    func uploadLike(_ like: Like, collectionName: CollectionNameForLike) async throws {
        
        let likeDate = try Firestore
            .Encoder()
            .encode(like)
        
        try await serviceCreate.addDocument(collectionName: collectionName,
                                            data: likeDate)
        
    }
    
    func deleteLike(likeId: String, collectionName: CollectionNameForLike) async throws {
        
        try await serviceDetete
            .deleteDocument(from: collectionName.value,
                                               documentId: likeId)
        
    }
}
