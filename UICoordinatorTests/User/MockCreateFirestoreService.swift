//
//  MockCreateFirestoreService.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 21/04/2025.
//

import Testing

class MockCreateFirestoreService: FirestoreCreateUserProtocol {

    var receivedData: [String: Any]?
    var receivedId: String?
    var didCallSetData = false

    func setUserData(id: String, data: [String : Any]) async throws {
        receivedId = id
        receivedData = data
        didCallSetData = true
    }

}

class MockFirebaseAuthProvider : FirebaseAuthProviderProtocol {
    
    var mockUser: FirebaseUserProtocol = MockFirebaseUser(uid: "135", email: "test@gtest.com")
    
    func signIn(email: String, password: String) async throws -> any FirebaseUserProtocol {
        return mockUser
    }
    
}
