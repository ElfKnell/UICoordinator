//
//  MocksCurrentUserTestsData.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 19/04/2025.
//

import Firebase
import Testing

final class MockDocumentSnapshot: DocumentSnapshotProtocol {
    let mockData: [String: Any]
    
    init(mockData: [String: Any]) {
        self.mockData = mockData
    }
    
    func decodeData<T: Decodable>(as type: T.Type) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: mockData)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

// MARK: - Mock Firestore Service

final class MockFirestoreService: FirestoreServiceProtocol {
    var returnedSnapshot: DocumentSnapshotProtocol?

    func getUserDocument(uid: String) async throws -> DocumentSnapshotProtocol {
        guard let snapshot = returnedSnapshot else {
            throw NSError(domain: "MockFirestoreService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No snapshot set"])
        }
        return snapshot
    }
}

