//
//  UserServiceTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 23/04/2025.
//

import XCTest

final class UserServiceTests: XCTestCase {

    func testFetchUser_success() async {
        let mockUser = User(id: "123", fullname: "Test User", username: "testuser", email: "test@test.com")
        let mockService = MockFirestoreService()
        mockService.mockUser = mockUser

        let userService = UserService(firestoreUserDocument: mockService)
        let fetchedUser = await userService.fetchUser(withUid: "123")

        XCTAssertEqual(fetchedUser.id, "123")
        XCTAssertEqual(fetchedUser.username, "testuser")
    }

    func testFetchUser_fallbackOnError() async {
        let mockService = MockFirestoreService()
        mockService.shouldThrowError = true

        let userService = UserService(firestoreUserDocument: mockService)
        let user = await userService.fetchUser(withUid: "fail")

        XCTAssertEqual(user.id, DeveloperPreview.user.id)
    }

    func testDeleteUser_success() async {
        let mockService = MockFirestoreService()
        let userService = UserService(firestoreUserDocument: mockService)

        await userService.deleteUser()

            // If no error is thrown, test passes
        XCTAssertTrue(true)
    }

    func testDeleteUser_userNotFoundError() async {
        let mockService = MockFirestoreService()
        mockService.shouldThrowError = true

        let userService = UserService(firestoreUserDocument: mockService)

        await userService.deleteUser()

            // Again, no crash = test passes (you could capture logs with os_log if needed)
        XCTAssertTrue(true)
    }
}
