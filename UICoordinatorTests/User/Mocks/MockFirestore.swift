//
//  UserMockFirestore.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/06/2025.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class MockFirestore: FirestoreProtocol {
    
    var runTransactionShouldThrow: Error? = nil
    var lastExecutedTransaction: MockTransaction? = nil
    
    var configureNextTransaction: ((MockTransaction) -> Void)?
    var mockCollectionReferences: [String: CollectionReferenceProtocol] = [:]
    var capturedCollectionUpdates: [String: [AnyHashable: Any]] = [:]
    
    init() {
    }
    
    func runTransaction(_ updateBlock: @escaping (any TransactionProtocol, NSErrorPointer) -> Any?) async throws {
        
        if let error = runTransactionShouldThrow {
            throw error
        }
        
        let currentMockTransaction = MockTransaction()
        self.lastExecutedTransaction = currentMockTransaction
        
        configureNextTransaction?(currentMockTransaction)
        
        var nsError: NSError? = nil
        _ = updateBlock(currentMockTransaction, &nsError)
        
        if let error = nsError {
            throw error
        }
    }
    
    func collection(_ collectionPath: String) -> CollectionReferenceProtocol {
        
        if let existingRef = mockCollectionReferences[collectionPath] {
            return existingRef
        }
        let mockCollection = MockCollectionReference(
            path: collectionPath,
            onDocumentUpdate: { docId, fields in
                self.capturedCollectionUpdates[docId] = fields
            }
        )
        mockCollectionReferences[collectionPath] = mockCollection
        return mockCollection
    }
}
