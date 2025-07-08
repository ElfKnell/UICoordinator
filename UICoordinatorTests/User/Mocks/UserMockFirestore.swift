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

class UserMockFirestore: FirestoreProtocol {
    
    var runTransactionShouldThrow: Error? = nil
    var lastExecutedTransaction: UserMockTransaction? = nil
    
    var configureNextTransaction: ((UserMockTransaction) -> Void)?
    
    init() {
    }
    
    func runTransaction(_ updateBlock: @escaping (any TransactionProtocol, NSErrorPointer) -> Any?) async throws {
        if let error = runTransactionShouldThrow {
            throw error
        }
        
        let currentMockTransaction = UserMockTransaction()
        self.lastExecutedTransaction = currentMockTransaction
        
        configureNextTransaction?(currentMockTransaction)
        
        var nsError: NSError? = nil
        _ = updateBlock(currentMockTransaction, &nsError)
        
        if let error = nsError {
            throw error
        }
    }
    
    func collection(_ collectionPath: String) -> CollectionReference {
        return Firestore.firestore().collection(collectionPath)
    }
}
