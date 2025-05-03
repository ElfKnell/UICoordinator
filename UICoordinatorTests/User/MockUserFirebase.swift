//
//  MockUserFirebase.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 18/04/2025.
//

import Testing
import Firebase

final class MockDocument: FirestoreDocumentProtocol {
    
    func delete() async throws {}
    
    var updatedData: [String: Any]? = nil

    func updateData(_ data: [String: Any]) async throws {
        updatedData = data
    }
}

final class MockCollection: FirestoreCollectionProtocol {
    
    var receivedDocumentId: String?
    let mockDocument = MockDocument()

    func document(_ id: String) -> FirestoreDocumentProtocol {
        receivedDocumentId = id
        return mockDocument
    }
}

final class MockFirestore: FirestoreProtocol {
    
    let mockCollection = MockCollection()
    var receivedCollectionName: String?

    func collection(_ path: String) -> FirestoreCollectionProtocol {
        receivedCollectionName = path
        return mockCollection
    }
}
