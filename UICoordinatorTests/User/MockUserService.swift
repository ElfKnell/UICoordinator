//
//  MockUserService.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 18/04/2025.
//

import Testing
import Foundation

struct MockFirebaseUser: FirebaseUserProtocol {
    var uid: String
    var email: String?
}

final class MockUserService: UserServiceProtocol {
    
    var currentUser: User?
    
    func fetchUser(withUid uid: String) async -> User {
        User(id: uid, fullname: "MockUser \(uid)", username: "MockUser \(uid)", email: "mock@user.com", isDelete: false)
    }

}

final class MockCurrentUserService: CurrentUserServiceProtocol {
    
    var currentUser: User?
    
    private(set) var fetchCalledWithUserId: String?
    
    func fetchCurrentUser(userId: String?) async {
        
        self.fetchCalledWithUserId = userId
        
        guard let userId = userId else { self.currentUser = nil; return }
        
        self.currentUser = User(id: userId, fullname: "MockUser \(userId)", username: "MockUser \(userId)", email: "mock@user.com", isDelete: false)
    }
    
    func updateCurrentUser() async {}
}

final class MockCreateUserService: CreateUserProtocol {
    var uploaded = false

    func uploadUserData(id: String, withEmail email: String, fullname: String, username: String) async {
        uploaded = true
    }
}
