//
//  DeleteSpreadService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 13/07/2025.
//

import Foundation
import Firebase

class DeleteSpreadService: DeleteSpreadServiceProtocol {
    
    private let nameCollection = "spread"
    let serviceDelete: FirestoreGeneralDeleteProtocol
    
    init(serviceDelete: FirestoreGeneralDeleteProtocol) {
        self.serviceDelete = serviceDelete
    }
    
    func removeSpreads(_ objectId: String, withType type: SpreadingType) async throws {
        
        let spreads = try await fetchingSpreads(objectId, withType: type)
        
        if !spreads.isEmpty {
            for spread in spreads {
                try await serviceDelete.deleteDocument(from: nameCollection, documentId: spread.id)
            }
        }
    }
    
    private func fetchingSpreads(_ objectId: String, withType type: SpreadingType) async throws -> [Spread] {
        
        let snapshot = try await Firestore.firestore()
            .collection(nameCollection)
            .whereField(type.value, isEqualTo: objectId)
            .getDocuments()
        
        return snapshot.documents.compactMap({ try? $0.data(as: Spread.self)})
    }
}
