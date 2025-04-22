//
//  CheckedLocalUsersByFollowingTestMocks.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 18/04/2025.
//

import Testing
import Foundation
import SwiftData

final class MockUserDataActor: UserDataActorProtocol {
    private(set) var savedUsers: [LocalUser] = []

    func save(user: LocalUser) async throws {
        savedUsers.append(user)
    }
}

final class MockLocalUserService: LocalUserServiceProtocol {
    var existingUsers: [LocalUser] = []

    func fetchLocalUsers() async -> [LocalUser] {
        existingUsers
    }
}

