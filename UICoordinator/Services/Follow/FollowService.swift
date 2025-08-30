//
//  FollowService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/04/2024.
//

import Firebase
import FirebaseFirestoreSwift

class FollowService: FollowServiceProtocol {
    
    private let nameCollection = "follow"
    let serviceCreate: FirestoreGeneralCreateServiseProtocol
    let servaceDelete: FirestoreGeneralDeleteProtocol
    
    init(serviceCreate: FirestoreGeneralCreateServiseProtocol = FirestoreGeneralServiceCreate(), servaceDelete: FirestoreGeneralDeleteProtocol = FirestoreGeneralDeleteService(
        db: FirestoreAdapter())) {
        self.serviceCreate = serviceCreate
        self.servaceDelete = servaceDelete
    }
    
    func uploadeFollow(_ follow: Follow) async throws {
        
        guard let followData = try? Firestore.Encoder()
            .encode(follow) else { throw FollowError.encodingFailed }
        
        try await self.serviceCreate.addDocument(from: nameCollection, data: followData)

    }
    
    func deleteFollow(followId: String) async throws {
        
        try await self.servaceDelete.deleteDocument(from: nameCollection, documentId: followId)
        
    }
}
