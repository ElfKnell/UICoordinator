//
//  CheckedLocalUsersByFollowingTestMocks.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 18/04/2025.
//

import Testing
import Foundation
import SwiftData

final class MockLocalUserService: LocalUserServiceProtocol {
    var localUsers: [LocalUser] = []
    func fetchLocalUsers() async -> [LocalUser] {
        return localUsers
    }
}

final class MockUserDataActor: UserDataActorProtocol {
    var savedUsers: [LocalUser] = []
    var deletedUsers: [LocalUser] = []
    var didCallDeleteAll = false

    func save(user: LocalUser) async throws {
        savedUsers.append(user)
    }

    func delete(user: LocalUser) async throws {
        deletedUsers.append(user)
    }

    func deleteAllUsers() async throws {
        didCallDeleteAll = true
    }
}

