//
//  MockFirestoreCreateUserService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 01/07/2025.
//

import Foundation

class MockFirestoreCreateUserService: FirestoreCreateUserProtocol {
    
    var createUserWithUniqueUsernameCalled = false
    var capturedUser: User?
    var capturedUsername: String?
    var shouldThrowError: Error?
    
    func createUserWithUniqueUsername(user: User, username: String) async throws {
        createUserWithUniqueUsernameCalled = true
        capturedUser = user
        capturedUsername = username
        
        if let error = shouldThrowError {
            throw error
        }
    }
}
