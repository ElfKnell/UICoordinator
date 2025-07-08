//
//  MockCreateUserService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/07/2025.
//

import Foundation

class MockCreateUserService: CreateUserProtocol {
    
    var uploadUserDataCalled = false
    var capturedUserID: String?
    var capturedEmail: String?
    var capturedFullname: String?
    var capturedUsername: String?
    var shouldThrowError: Error?
    
    func uploadUserData(id: String,
                        withEmail email: String,
                        fullname: String,
                        username: String) async throws {
        
        uploadUserDataCalled = true
        capturedUserID = id
        capturedEmail = email
        capturedFullname = fullname
        capturedUsername = username
        
        if let error = shouldThrowError {
            throw error
        }
    }
}
