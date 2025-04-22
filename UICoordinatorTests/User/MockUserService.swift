//
//  MockUserService.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 18/04/2025.
//

import Testing

final class MockUserService: UserServiceProtocol {
    
    var currentUser: User?
    
    func fetchUser(withUid uid: String) async -> User {
        User(id: uid, fullname: "MockUser \(uid)", username: "MockUser \(uid)", email: "mock@user.com")
    }
}

final class MockCurrentUserService: CurrentUserServiceProtocol {
    
    var currentUser: User?

    init(userId: String) {
        self.currentUser = User(id: "123456", fullname: "Test Name", username: "example", email: "exaple@test.com")
    }
    
    func fetchCurrentUser(userId: String?) async {
        guard let userId = userId else { self.currentUser = nil; return }
        
        self.currentUser = User(id: userId, fullname: "MockUser \(userId)", username: "MockUser \(userId)", email: "mock@user.com")
    }
    
    func updateCurrentUser() async {
        
    }
}
