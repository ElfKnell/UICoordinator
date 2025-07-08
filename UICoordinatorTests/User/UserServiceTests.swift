//
//  UserServiceTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 23/04/2025.
//

import XCTest

final class UserServiceTests: XCTestCase {

    func testFetchUser_success() async {
        
        let mockUser = User(id: "123", fullname: "Test User", username: "testuser", email: "test@test.com", isDelete: false)
        let mockService = MockFirestoreService()
        //mockService.mockUser = mockUser

        let userService = UserService(firestoreUserDocument: mockService)
        let fetchedUser = await userService.fetchUser(withUid: "123")

        XCTAssertEqual(fetchedUser.id, "123")
        XCTAssertEqual(fetchedUser.username, "testuser")
    }

    func testFetchUser_fallbackOnError() async {
        
        let mockService = MockFirestoreService()
        //mockService.shouldThrowError = true

        let userService = UserService(firestoreUserDocument: mockService)
        let user = await userService.fetchUser(withUid: "fail")

        XCTAssertEqual(user.id, DeveloperPreview.user.id)
    }
}
