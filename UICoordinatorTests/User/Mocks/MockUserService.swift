//
//  MockUserService.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 09/07/2025.
//

import Foundation

class MockUserService: UserServiceProtocol {
    
    var fetchUserResult: Result<User, Error>?
    var capturedUid: String?
    
    init(fetchUserResult: Result<User, Error>? = nil, capturedUid: String? = nil) {
        self.fetchUserResult = fetchUserResult
        self.capturedUid = capturedUid
    }
    
    func fetchUser(withUid uid: String) async throws -> User {
        
        capturedUid = uid
        
        guard let result = fetchUserResult else {
            fatalError("MockUserService.fetchUserResult was not set.")
        }

        switch result {
        case .success(let user):
            return user
        case .failure(let error):
            throw error
        }
    }
}
