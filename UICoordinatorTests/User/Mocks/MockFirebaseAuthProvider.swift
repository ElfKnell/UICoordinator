//
//  MockFirebaseAuthProvider.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 07/07/2025.
//

import Foundation

class MockFirebaseAuthProvider: FirebaseAuthProviderProtocol {
    
    var signInCalled = false
    var capturedSignInEmail: String?
    var capturedSignInPassword: String?
    var signInResult: FirebaseUserProtocol?
    var signInShouldThrow: Error?
    
    func signIn(email: String, password: String) async throws -> FirebaseUserProtocol {
        
        signInCalled = true
        capturedSignInEmail = email
        capturedSignInPassword = password
        if let error = signInShouldThrow {
            throw error
        }
        
        guard let result = signInResult else {
            throw UserError.generalError("Mock sign-in result not set")
        }
        return result
    }
}
