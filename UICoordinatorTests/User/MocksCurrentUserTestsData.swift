//
//  MocksCurrentUserTestsData.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 19/04/2025.
//

import Foundation
import Firebase
import Testing

final class MockDocumentSnapshot: DocumentSnapshotProtocol {
    private let user: User

    init(user: User) {
        self.user = user
    }

    func decodeData<T>(as type: T.Type) throws -> T where T : Decodable {
        guard let decoded = user as? T else {
            throw NSError(domain: "DecodeError", code: -1)
        }
        return decoded
    }
}

// MARK: - Mock Firestore Service

final class MockFirestoreService: FirestoreServiceProtocol {
    
    var shouldThrowError = false
    var mockUser: User?
    
    func deleteUserDocument() async throws {
        
        if shouldThrowError {
            throw UserError.userNotFound
        }
    }
    
    

    func getUserDocument(uid: String) async throws -> DocumentSnapshotProtocol {
            if shouldThrowError {
                throw UserError.userNotFound
            }

            return MockDocumentSnapshot(user: mockUser ?? DeveloperPreview.user)
        }
}

