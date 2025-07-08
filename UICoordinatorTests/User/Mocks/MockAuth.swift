//
//  MockAuth.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 07/07/2025.
//

import Foundation

class MockAuth: AuthProtocol {
    
    var createUserCalled = false
    var capturedEmail: String?
    var capturedPassword: String?
    var createUserResult: AuthDataResultProtocol?
    var createUserShouldThrowError: Error?
    
    func createUser(withEmail email: String, password: String) async throws -> AuthDataResultProtocol? {
        
        createUserCalled = true
        capturedEmail = email
        capturedPassword = password
        
        if let error = createUserShouldThrowError {
            throw error
        }
        
        guard let result = createUserResult else {
            throw NSError(domain: "MockAuthError",
                          code: 0,
                          userInfo: [NSLocalizedDescriptionKey: "Mock createUserResult not set"])
        }
        return result
    }
}
