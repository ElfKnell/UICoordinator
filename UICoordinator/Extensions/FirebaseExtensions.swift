//
//  FirebaseExtensions.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 18/04/2025.
//

import Foundation
import Firebase
import FirebaseFirestore

//extension Firestore: FirestoreProtocol {
//   
//    func runTransaction(_ updateBlock: @escaping (any TransactionProtocol, NSErrorPointer) -> Any?) async throws {
//        
//    }
//    
//    func collection(_ path: String) -> FirestoreCollectionProtocol {
//        return self.collection(path) as CollectionReference
//    }
//}
//
//extension CollectionReference: FirestoreCollectionProtocol {
//    func document(_ id: String) -> FirestoreDocumentProtocol {
//        return FirestoreDocumentWrapper(ref: self.document(id))
//    }
//}

extension DocumentSnapshot: DocumentSnapshotProtocol {
    func decodeData<T: Decodable>(as type: T.Type) throws -> T {
        try self.data(as: type)
    }
}

extension FirebaseAuth.User: FirebaseUserProtocol {}
