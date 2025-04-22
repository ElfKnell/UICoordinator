//
//  MockUserFirebase.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 18/04/2025.
//

import Testing
import Firebase

final class MockDocument: FirestoreDocumentProtocol {
    var updatedData: [String: Any] = [:]

    func updateData(_ data: [String: Any]) async throws {
        updatedData = data
    }
}

final class MockCollection: FirestoreCollectionProtocol {
    var mockDocument = MockDocument()
    func document(_ id: String) -> FirestoreDocumentProtocol {
        return mockDocument
    }
}

final class MockFirestore: FirestoreProtocol {
    var mockCollection = MockCollection()
    func collection(_ path: String) -> FirestoreCollectionProtocol {
        return mockCollection
    }
}
