//
//  MockFetchingFollowService.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 25/04/2025.
//

import Testing
import Foundation

final class MockFetchingFollowService: FirestoreFollowServiceProtocol {
    
    var mockFollows: [Follow] = []
    var mockCount: Int = 0
    var shouldThrowInvalidInput = false
    var shouldThrowGenericError = false

    func getFollows(uid: String, followField: FieldToFetching) async throws -> [Follow] {
        if shouldThrowInvalidInput { throw FollowError.invalidInput }
        if shouldThrowGenericError { throw NSError(domain: "Test", code: 0) }
        return mockFollows
    }

    func getFollowCount(uid: String, followField: FieldToFetching) async throws -> Int {
        if shouldThrowInvalidInput { throw FollowError.invalidInput }
        if shouldThrowGenericError { throw NSError(domain: "Test", code: 1) }
        return mockCount
    }
}
