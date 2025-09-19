//
//  ThreadService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 28/02/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class ColloquyService: ColloquyServiceProtocol {
    
    private let serviceDetete: FirestoreGeneralDeleteProtocol
    private let repliesFetchingService: FetchRepliesProtocol
    private let deleteLikes: LikesDeleteServiceProtocol
    
    init(serviceDetete: FirestoreGeneralDeleteProtocol,
         repliesFetchingService: FetchRepliesProtocol,
         deleteLikes: LikesDeleteServiceProtocol) {
        self.serviceDetete = serviceDetete
        self.repliesFetchingService = repliesFetchingService
        self.deleteLikes = deleteLikes
    }
    
    func uploadeColloquy(_ colloquy: Colloquy) async throws {
        
        guard let colloquyData = try? Firestore.Encoder()
            .encode(colloquy) else { return }
        
        try await Firestore.firestore()
            .collection("colloquies")
            .addDocument(data: colloquyData)
        
    }
    
    func deleteColloquy(_ colloquy: any LikeObject) async throws {
        
        let collectionName = "colloquies"
        
        if colloquy.repliesCount ?? 0 > 0 {
            let replies = try await repliesFetchingService.getRepliesByColloquy(colloquyId: colloquy.id)
            
            for reply in replies {
                try await deleteColloquy(reply)
            }
        }
        
        try await deleteLikes.likesDelete(objectId: colloquy.id, collectionName: .likes)
        try await serviceDetete.deleteDocument(from: collectionName, documentId: colloquy.id)
        
    }
    
}
