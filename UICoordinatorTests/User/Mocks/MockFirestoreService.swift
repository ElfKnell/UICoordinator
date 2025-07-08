//
//  MockFirestoreService.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 07/07/2025.
//

import Foundation

class MockFirestoreService: FirestoreServiceProtocol {
    
    var getUserDocumentCalled = false
    var capturedUserID: String?
    var getUserDocumentResult: DocumentSnapshotProtocol?
    var getUserDocumentShouldThrow: Error?
    
    func getUserDocument(uid: String) async throws -> any DocumentSnapshotProtocol {
        
        getUserDocumentCalled = true
        capturedUserID = uid
        
        if let error = getUserDocumentShouldThrow {
            throw error
        }
        
        guard let result = getUserDocumentResult else {
            return MockDocumentSnapshot(documentID: uid, exists: false)
        }
        return result
    }
    
    
}
