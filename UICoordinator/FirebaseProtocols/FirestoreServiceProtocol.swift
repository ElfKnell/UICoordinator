//
//  FirestoreServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/04/2025.
//

import Foundation
import Firebase

protocol FirestoreServiceProtocol {
    
    func getUserDocument(uid: String) async throws -> DocumentSnapshotProtocol
    
}
