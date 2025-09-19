//
//  BlockService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 17/09/2025.
//

import Firebase
import FirebaseFirestoreSwift

class BlockService: BlockServiceProtocol {
    
    private let nameCollection = "block"
    let serviceCreate: FirestoreGeneralCreateServiseProtocol
    
    init(serviceCreate: FirestoreGeneralCreateServiseProtocol) {
        self.serviceCreate = serviceCreate
    }
    
    func uploadeBlock(curentUserIs: String, userId: String) async throws {
        
        let block = Block(blocker: curentUserIs, blocked: userId, updateTime: Timestamp())
        
        guard let blockData = try? Firestore.Encoder()
            .encode(block) else {
            throw BlockError.encodingFailed
        }
        
        try await self.serviceCreate
            .addDocument(from: nameCollection, data: blockData)

    }
    
    func deleteBlock(curentUserIs: String, userId: String) async throws {
        
        let db = Firestore.firestore()
        
        let snapshot = try await db.collection(nameCollection)
            .whereField("blocker", isEqualTo: curentUserIs)
            .whereField("blocked", isEqualTo: userId)
            .getDocuments()

        guard let document = snapshot.documents.first else { return }
            
        try await document.reference.delete()
        
    }
    
}
