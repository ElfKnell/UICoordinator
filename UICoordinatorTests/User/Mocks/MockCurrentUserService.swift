//
//  MockCurrentUserService.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 07/07/2025.
//

import Foundation

class MockCurrentUserService: CurrentUserServiceProtocol {
    
    var currentUser: User?
    var fetchCurrentUserCalled = false
    var capturedFetchUserID: String?
    var fetchCurrentUserShouldThrow: Error?
    var updateCurrentUserCalled = false
    var updateCurrentUserShouldThrow: Error?
    
    func fetchCurrentUser(userId: String?) async throws {
        fetchCurrentUserCalled = true
        capturedFetchUserID = userId
        if let error = fetchCurrentUserShouldThrow {
            throw error
        }
    }
    
    func updateCurrentUser() async throws {
        fetchCurrentUserCalled = true
        if let error = updateCurrentUserShouldThrow {
            throw error
        }
    }
    
    
}
