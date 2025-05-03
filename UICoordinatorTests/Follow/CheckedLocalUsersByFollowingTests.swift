//
//  CheckedLocalUsersByFollowingTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 18/04/2025.
//

import SwiftData
import XCTest

final class CheckedLocalUsersByFollowingTests: XCTestCase {
    
    private var mockLocalUserService: MockLocalUserService!
    private var mockUserService: MockUserService!
    private var mockUserDataActor: MockUserDataActor!
    private var sut: CheckedLocalUsersByFollowing!
    
    @MainActor
    override func setUp() {
        super.setUp()
            
        mockLocalUserService = MockLocalUserService()
        mockUserService = MockUserService()
        mockUserDataActor = MockUserDataActor()
            
        sut = CheckedLocalUsersByFollowing(
            localUserService: mockLocalUserService,
            userService: mockUserService,
            containerProvider: { throw NSError(domain: "Test", code: 0) }
        )
        sut.setActorForTesting(mockUserDataActor)
    }

    func test_addLocalUsersByFollowingToStore_savesMissingUsers() async {

        mockLocalUserService.localUsers = [
            LocalUser(id: "user_1", fullname: "User One", username: "OneU", email: "user@user.one")
        ]
        let follows = ["user_1", "user_2", "user_3"]

        await sut.addLocalUsersByFollowingToStore(follows: follows)

        XCTAssertEqual(mockUserDataActor.savedUsers.count, 2)
        XCTAssertTrue(mockUserDataActor.savedUsers.contains { $0.id == "user_2" })
        XCTAssertTrue(mockUserDataActor.savedUsers.contains { $0.id == "user_3" })
    }
    
    func test_removeUnfollowedLocalUsers_deletesMissingFollows() async {

        mockLocalUserService.localUsers = [
            LocalUser(id: "user_1", fullname: "User One", username: "OneU", email: "user@user.one"),
            LocalUser(id: "user_2", fullname: "User Second", username: "SecondU", email: "user2@user.one")
        ]

        await sut.removeUnfollowedLocalUsers(follows: ["user_1"])

        XCTAssertEqual(mockUserDataActor.deletedUsers.count, 1)
        XCTAssertEqual(mockUserDataActor.deletedUsers.first?.id, "user_2")
    }
    
    func test_clearAllLocalUsers_callsDeleteAllUsers() async {

        await sut.clearAllLocalUsers()

        XCTAssertTrue(mockUserDataActor.didCallDeleteAll)
    }

}
