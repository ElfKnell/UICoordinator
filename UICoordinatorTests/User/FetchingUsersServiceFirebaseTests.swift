//
//  FetchingUsersServiceFirebaseTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 23/04/2025.
//

import XCTest

final class FetchingUsersServiceFirebaseTests: XCTestCase {

    func testFetchUsers_excludesCurrentUser() async {
        let mock = MockFirestoreUserRepository()
        mock.allUsers = [
            User(id: "1", fullname: "John", username: "john", email: "john@test.com", isDelete: false),
            User(id: "2", fullname: "Jane", username: "jane", email: "jane@test.com", isDelete: false)
        ]
            
        let service = FetchingUsersServiceFirebase(repository: mock)
        let users = await service.fetchUsers(withId: "1")
            
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.id, "2")
    }

    func testFetchUsersByIds_returnsCorrectUsers() async {
        let mock = MockFirestoreUserRepository()
        mock.userIdsToReturn = [
            "1": User(id: "1", fullname: "Alice", username: "alice", email: "alice@test.com", isDelete: false),
            "2": User(id: "2", fullname: "Bob", username: "bob", email: "bob@test.com", isDelete: false)
        ]
            
        let service = FetchingUsersServiceFirebase(repository: mock)
        let users = await service.fetchUsersByIds(at: ["1", "2", "3"])
            
        XCTAssertEqual(users.count, 2)
        XCTAssertTrue(users.contains(where: { $0.id == "1" }))
        XCTAssertTrue(users.contains(where: { $0.id == "2" }))
    }

    func testFetchUsers_handlesErrorGracefully() async {
        let mock = MockFirestoreUserRepository()
        mock.shouldThrowError = true
            
        let service = FetchingUsersServiceFirebase(repository: mock)
        let users = await service.fetchUsers(withId: "1")
            
        XCTAssertTrue(users.isEmpty)
    }

}
