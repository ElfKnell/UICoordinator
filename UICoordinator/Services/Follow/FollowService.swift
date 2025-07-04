//
//  FollowService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/04/2024.
//

import Firebase
import FirebaseFirestoreSwift

class FollowService: FollowServiceProtocol {
    
    private let nameCollection = "Follow"
    let serviceCreate: FirestoreGeneralCreateServiseProtocol
    let servaceDelete: FirestoreGeneralDeleteProtocol
    
    init(serviceCreate: FirestoreGeneralCreateServiseProtocol = FirestoreGeneralServiceCreate(), servaceDelete: FirestoreGeneralDeleteProtocol = FirestoreGeneralDeleteService(
        db: FirestoreAdapter())) {
        self.serviceCreate = serviceCreate
        self.servaceDelete = servaceDelete
    }
    
    func uploadeFollow(_ follow: Follow) async {
        
        do {
            guard let followData = try? Firestore.Encoder()
                .encode(follow) else { throw FollowError.encodingFailed }
            
            try await self.serviceCreate.addDocument(from: nameCollection, data: followData)
        } catch {
            print("ERROR CREATE FOLLOW: \(error.localizedDescription)")
        }
    }
    
    func deleteFollow(followId: String) async {
        
        do {
            
            try await self.servaceDelete.deleteDocument(from: nameCollection, documentId: followId)
            
        } catch {
            print("ERROR DELETE FOLLOW: \(error.localizedDescription)")
        }
    }
}
