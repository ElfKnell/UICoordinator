//
//  MockFirestoreUserRepository.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 23/04/2025.
//

import Testing
import Foundation

class MockFirestoreUserRepository: FirestoreUserRepositoryProtocol {

    var allUsers: [User] = []
    var userIdsToReturn: [String: User] = [:]
    var shouldThrowError = false

    func fetchAllUsers(excluding currentUserId: String) async throws -> [User] {
        if shouldThrowError { throw NSError(domain: "MockError", code: 1) }
        return allUsers.filter { $0.id != currentUserId }
    }
    
    func fetchUsersByIds(_ ids: [String]) async throws -> [User] {
        if shouldThrowError { throw NSError(domain: "MockError", code: 2) }
        return ids.compactMap { userIdsToReturn[$0] }
    }

}
