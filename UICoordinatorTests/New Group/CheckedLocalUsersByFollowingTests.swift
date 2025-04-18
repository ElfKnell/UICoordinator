//
//  CheckedLocalUsersByFollowingTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 17/04/2025.
//

import SwiftData
import XCTest

final class CheckedLocalUsersByFollowingTests: XCTestCase {

    @MainActor
        func test_addLocalUsersByFollowingToStore_addsOnlyNewUsers() async throws {
            // Arrange
            let existingUser = LocalUser(id: "123", fullname: "Existing User", username: "user name", email: "user@test.com")
            let mockLocalUserService = MockLocalUserService()
            mockLocalUserService.existingUsers = [existingUser]

            let mockUserService = MockUserService()
            let mockActor = MockUserDataActor()

            let containerProvider = {
                try ModelContainer(for: LocalUser.self)
            }

            let sut = CheckedLocalUsersByFollowing(
                localUserService: mockLocalUserService,
                userService: mockUserService,
                containerProvider: containerProvider
            )

            sut.setActorForTesting(mockActor)

            // Act
            await sut.addLocalUsersByFollowingToStore(follows: ["123", "456", "789"])

            // Assert
            let saved = mockActor.savedUsers
            XCTAssertEqual(saved.count, 2)
            XCTAssertTrue(saved.contains(where: { $0.id == "456" }))
            XCTAssertTrue(saved.contains(where: { $0.id == "789" }))
            XCTAssertFalse(saved.contains(where: { $0.id == "123" }))
        }
}
