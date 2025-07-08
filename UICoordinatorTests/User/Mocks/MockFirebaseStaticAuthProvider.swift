//
//  MockFirebaseStaticAuthProvider.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 07/07/2025.
//

import Foundation

class MockFirebaseStaticAuthProvider: FirebaseStaticAuthProviderProtocol {
    
    var currentUserResult: FirebaseUserProtocol?
    var signOutCalled = false
    var signOutShouldThrow: Error?
    
    var currentUser: FirebaseUserProtocol? {
        return currentUserResult
    }
    
    func signOut() throws {
        signOutCalled = true
        if let error = signOutShouldThrow {
            throw error
        }
    }
}
