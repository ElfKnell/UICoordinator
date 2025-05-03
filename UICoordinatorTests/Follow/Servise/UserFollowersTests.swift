//
//  UserFollowersTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 25/04/2025.
//

import XCTest

@MainActor
final class UserFollowersTests: XCTestCase {

    var mockFetchingService: MockFetchingService!
    var mockCheckedFollowing: MockCheckedLocalUsersByFollowing!
    var sut: UserFollowers!

    override func setUp() {
        super.setUp()
        mockFetchingService = MockFetchingService()
        mockCheckedFollowing = MockCheckedLocalUsersByFollowing()

        sut = UserFollowers(fetchingService: mockFetchingService,
                            checkedFollowing: mockCheckedFollowing)

    }

    func test_isFollowingCurrentUser_returnsCorrectValue() async {
        
        let follow = Follow(follower: "userA", following: "userB", updateTime: .init())
        mockFetchingService.followsToReturn = [follow]

        await sut.loadFollowersCurrentUser(userId: "userA")

        XCTAssertTrue(sut.isFollowingCurrentUser(uid: "userB"))
        XCTAssertFalse(sut.isFollowingCurrentUser(uid: "userC"))
    }
    
    func test_updateFollowCounts_setsCorrectValues() async {

        mockFetchingService.followCountToReturn = 5

        sut.updateFollowCounts(for: "userX")

        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.countFollowers, 5)
        XCTAssertEqual(sut.countFollowing, 5)
    }
    
    func test_clearAllLocalUsers_calledWhenNoFollowers() async {

        mockFetchingService.followsToReturn = []

        await sut.loadFollowersCurrentUser(userId: "userX")

        XCTAssertTrue(mockCheckedFollowing.cleared)
    }
}
