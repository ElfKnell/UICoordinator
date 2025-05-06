//
//  MockFetchingService.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 25/04/2025.
//

import Testing

final class MockFetchingService: FetchingFollowAndFollowCountProtocol {
    
    var followsToReturn: [Follow] = []
    var followCountToReturn: Int = 0
    
    func fetchFollow(uid: String, byField: FieldToFetchingFollow) async -> [Follow] {
        return followsToReturn
    }
    
    func fetchFollowCount(uid: String, byField: FieldToFetchingFollow) async -> Int {
        return followCountToReturn
    }
}

final class MockCheckedLocalUsersByFollowing: CheckedLocalUsersByFollowingProtocol {
    
    var cleared = false
    var addedUsers: [String] = []
    var removedUsers: [String] = []

    func addLocalUsersByFollowingToStore(follows: [String]) async {
        addedUsers = follows
    }

    func removeUnfollowedLocalUsers(follows: [String]) async {
        removedUsers = follows
    }

    func clearAllLocalUsers() async {
        cleared = true
    }
}
