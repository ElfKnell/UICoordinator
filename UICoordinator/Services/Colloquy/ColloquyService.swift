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
    
    init(serviceDetete: FirestoreGeneralDeleteProtocol,
         repliesFetchingService: FetchRepliesProtocol) {
        self.serviceDetete = serviceDetete
        self.repliesFetchingService = repliesFetchingService
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
        
        do {
            if colloquy.repliesCount ?? 0 > 0 {
                let replies = try await repliesFetchingService.getRepliesByColloquy(colloquyId: colloquy.id)
                
                for reply in replies {
                    try await serviceDetete.deleteDocument(from: "colloquies", documentId: reply.id)
                }
            }
            
            try await serviceDetete.deleteDocument(from: "colloquies", documentId: colloquy.id)
            
        } catch {
            print("ERROR Delete colloquy \(error.localizedDescription)")
        }
    }
}
