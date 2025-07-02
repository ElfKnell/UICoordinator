//
//  TransactionProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 28/06/2025.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol TransactionProtocol {
    
    func getDocument(_ documentRef: DocumentReference) throws -> DocumentSnapshotProtocol
    
    func setData<T: Encodable>(from value: T, forDocument document: DocumentReference) throws
    
    func setData(_ data: [String: Any], forDocument document: DocumentReference) throws
    
    func updateData(_ fields: [AnyHashable: Any], forDocument document: DocumentReference) throws
    
    func deleteDocument(_ documentRef: DocumentReference) throws
    
    func collection(_ collectionPath: String) -> CollectionReference
}
