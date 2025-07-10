//
//  FirestoreAdapter.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 28/06/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreAdapter: FirestoreProtocol {
    
    private let firestore: FirebaseFirestore.Firestore
    
    init(firestore: FirebaseFirestore.Firestore = .firestore()) {
        self.firestore = firestore
    }
    
    func collection(_ collectionPath: String) -> CollectionReferenceProtocol {
        return CollectionReferenceAdapter(collection: firestore.collection(collectionPath))
    }
    
    func runTransaction(_ updateBlock: @escaping (any TransactionProtocol, NSErrorPointer) -> Any?) async throws {
        
        _ = try await firestore.runTransaction{ (realTransaction, errorPointer) -> Any? in
            let adapterTransaction = TransactionAdapter(transaction: realTransaction, firestoreInstance: self.firestore)
            return updateBlock(adapterTransaction, errorPointer)
        }
    }
}
