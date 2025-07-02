//
//  MocksCurrentUserTestsData.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 19/04/2025.
//

import Foundation
import Firebase
import Testing

//final class MockDocumentSnapshot: DocumentSnapshotProtocol {
//    
//    var documentID: String
//    
//    var exists: Bool
//    
//    func data() -> [String : Any]? {
//        
//    }
//    
//    private let user: User
//
//    init(user: User) {
//        self.user = user
//    }
//
//    func decodeData<T>(as type: T.Type) throws -> T where T : Decodable {
//        guard let decoded = user as? T else {
//            throw NSError(domain: "DecodeError", code: -1)
//        }
//        return decoded
//    }
//}

final class MockFirestoreService: FirestoreServiceProtocol {
    
    var shouldThrowError = false
    var mockUser: User?

    func getUserDocument(uid: String) async throws -> DocumentSnapshotProtocol {
        if shouldThrowError {
            throw UserError.userNotFound
        }

        return UserMockDocumentSnapshot(documentID: mockUser?.id ?? "none", exists: true)
    }
}

