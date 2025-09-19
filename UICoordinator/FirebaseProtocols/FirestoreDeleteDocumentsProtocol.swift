//
//  FirestoreDocumentsCountProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/09/2025.
//

import Foundation

protocol FirestoreDeleteDocumentsProtocol {
    
    func deleteDocumentsWithDependencies(
        collectionName: String,
        userId: String,
        dependencyDeleter: @escaping (_ documentId: String) async throws -> Void
    ) async throws
    
    func deleteDocumentsWithDependencies(
        collectionName: String,
        userId: String
    ) async throws
    
}
