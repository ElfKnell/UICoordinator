//
//  TransactionAdapter.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 28/06/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class TransactionAdapter: TransactionProtocol {
    
    private let transaction: FirebaseFirestore.Transaction
    private let firestoreInstance: FirebaseFirestore.Firestore
    
    init(transaction: FirebaseFirestore.Transaction,
         firestoreInstance: FirebaseFirestore.Firestore) {
        self.transaction = transaction
        self.firestoreInstance = firestoreInstance
    }
    
    func getDocument(_ documentRef: DocumentReference) throws -> DocumentSnapshotProtocol {
        let realSnapshot = try transaction.getDocument(documentRef)
        return DocumentSnapshotAdapter(snapshot: realSnapshot)
    }
    
    func setData<T>(from value: T, forDocument document: DocumentReference) throws where T : Encodable {
        try transaction.setData(from: value, forDocument: document)
    }
    
    func setData(_ data: [String : Any], forDocument document: DocumentReference) throws {
        transaction.setData(data, forDocument: document)
    }
    
    func updateData(_ fields: [AnyHashable : Any], forDocument document: DocumentReference) throws {
        transaction.updateData(fields, forDocument: document)
    }
    
    func deleteDocument(_ documentRef: DocumentReference) throws {
        transaction.deleteDocument(documentRef)
    }
    
    func collection(_ collectionPath: String) -> CollectionReference {
        firestoreInstance.collection(collectionPath)
    }

}
