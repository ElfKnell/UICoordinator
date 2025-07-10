//
//  FirestoreProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 18/04/2025.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol FirestoreProtocol {
    
    func collection(_ collectionPath: String) -> CollectionReferenceProtocol
    
    func runTransaction(_ updateBlock: @escaping (TransactionProtocol, NSErrorPointer) -> Any?) async throws
}
