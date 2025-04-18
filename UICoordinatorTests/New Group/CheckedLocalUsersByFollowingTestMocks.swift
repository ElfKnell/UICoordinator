//
//  CheckedLocalUsersByFollowingTestMocks.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 17/04/2025.
//

import Foundation
import SwiftData
import Testing



    // MARK: - Mock Actor

final class MockUserDataActor: UserDataActorProtocol {
    private(set) var savedUsers: [LocalUser] = []

    func save(user: LocalUser) async throws {
        savedUsers.append(user)
    }
}

    // MARK: - Mock Services

final class MockLocalUserService: LocalUserServiceProtocol {
    var existingUsers: [LocalUser] = []

    func fetchLocalUsers() async -> [LocalUser] {
        existingUsers
    }
}

final class MockUserService: UserServiceProtocol {
    func fetchUser(withUid uid: String) async -> User {
        User(id: uid, fullname: "MockUser \(uid)", username: "MockUser \(uid)", email: "mock@user.com")
    }
}

