//
//  MockCollectionReference.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 09/07/2025.
//

import Foundation

class MockCollectionReference: CollectionReferenceProtocol {
    
    private let path: String
    private let onDocumentUpdate: (String, [AnyHashable: Any]) -> Void
    
    init(path: String, onDocumentUpdate: @escaping (String, [AnyHashable : Any]) -> Void) {
        self.path = path
        self.onDocumentUpdate = onDocumentUpdate
    }
    
    func document(_ documentPath: String) -> any DocumentReferenceProtocol {
        
        return MockDocumentReference(documentID: documentPath, onUpdate: onDocumentUpdate)
    }
}
