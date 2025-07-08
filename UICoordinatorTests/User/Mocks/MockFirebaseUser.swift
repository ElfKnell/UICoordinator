//
//  MockFirebaseUser.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/07/2025.
//

import Foundation

class MockFirebaseUser: FirebaseUserProtocol {
    
    var _uid: String
    var _email: String?
    var deleteCalled = false
    var shouldDeleteThrowError: Error?
    var idTokenForcingRefreshCalled = false
    var idTokenForcingRefreshResult: String?
    var idTokenForcingRefreshShouldThrow: Error?
    
    init(uid: String, email: String?) {
        self._uid = uid
        self._email = email
    }
    
    var uid: String {
        return _uid
    }
    
    var email: String? {
        return _email
    }
    
    func delete() async throws {
        deleteCalled = true
        if let error = shouldDeleteThrowError {
            throw error
        }
    }
    
    func idTokenForcingRefresh(_ forceRefresh: Bool) async throws -> String {
        idTokenForcingRefreshCalled = true
        if let error = idTokenForcingRefreshShouldThrow {
            throw error
        }
        return idTokenForcingRefreshResult ?? "mock_id_token"
    }
}
