//
//  MockFirestoreFollowService.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 25/04/2025.
//

import Testing

final class MockFirestoreFollowService: FirestoreFollowServiceProtocol {
    
    var mockFollows: [Follow] = []
    var mockFollowCount: Int = 0
    var shouldThrowError = false
    
    func getFollows(uid: String, followField: FieldToFetchingFollow) async throws -> [Follow] {
        if shouldThrowError || uid.isEmpty {
            throw FollowError.invalidInput
        }
        return mockFollows.sorted(by: { $0.updateTime.dateValue() < $1.updateTime.dateValue() })
    }
    
    func getFollowCount(uid: String, followField: FieldToFetchingFollow) async throws -> Int {
        if shouldThrowError || uid.isEmpty {
            throw FollowError.invalidInput
        }
        return mockFollowCount
    }
}
