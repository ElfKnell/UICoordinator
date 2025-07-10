//
//  MockCollectionReferenceWrapper.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 09/07/2025.
//

import Foundation
import Firebase
import FirebaseFirestore

class MockCollectionReferenceWrapper {
    
    private let path: String
    private let onDocumentUpdate: (String, [AnyHashable: Any]) -> Void
    
    init(path: String, onDocumentUpdate: @escaping (String, [AnyHashable : Any]) -> Void) {
        self.path = path
        self.onDocumentUpdate = onDocumentUpdate
    }
    
    func document(_ documentPath: String) -> DocumentReferenceProtocol {
        return MockDocumentReference(documentID: documentPath, onUpdate: onDocumentUpdate)
    }
}
