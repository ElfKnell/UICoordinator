//
//  FirestoreAddDocumentWithIDProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 22/08/2025.
//

import Foundation

protocol FirestoreAddDocumentWithIDProtocol {
    
    func setDocument(
        from collection: String,
        data: [String: Any],
        routeID: String
    ) async throws
    
}
