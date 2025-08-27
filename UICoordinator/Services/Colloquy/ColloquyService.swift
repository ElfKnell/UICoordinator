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
    
    func uploadeColloquy(_ colloquy: Colloquy) async {
        
        do {
            guard let colloquyData = try? Firestore.Encoder()
                .encode(colloquy) else { return }
            
            try await Firestore.firestore()
                .collection("colloquies")
                .addDocument(data: colloquyData)
        } catch {
            print("ERROR \(error.localizedDescription)")
        }
    }
    
    func markForDelete(_ colloquyId: String) async {
        
        do {
                
            try await Firestore.firestore()
                .collection("colloquies")
                .document(colloquyId)
                .updateData(["isDelete": true])
            
        } catch {
            print("ERROR Mark for Delete colloquy \(error.localizedDescription)")
        }
    }
    
    func unmarkForDelete(_ colloquyId: String) async {
        
        do {
            
            try await Firestore.firestore()
                .collection("colloquies")
                .document(colloquyId)
                .updateData(["isDelete": false])
            
        } catch {
            print("ERROR Mark for Delete colloquy \(error.localizedDescription)")
        }
    }
    
    func deleteColloquy(_ colloquy: Colloquy) async {
        
        let collectionName = "colloquies"
        
        do {
            if colloquy.repliesCount ?? 0 > 0 {
                let replies = try await repliesFetchingService.getRepliesByColloquy(colloquyId: colloquy.id)
                
                for reply in replies {
                    try await serviceDetete.deleteDocument(from: collectionName, documentId: reply.id)
                    await deleteLikes.likesDelete(objectId: reply.id, collectionName: .likes)
                }
            }
            
            await deleteLikes.likesDelete(objectId: colloquy.id, collectionName: .likes)
            try await serviceDetete.deleteDocument(from: collectionName, documentId: colloquy.id)
            
        } catch {
            print("ERROR Delete colloquy \(error.localizedDescription)")
        }
    }
}
