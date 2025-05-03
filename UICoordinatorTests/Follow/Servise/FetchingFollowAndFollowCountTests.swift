//
//  FetchingFollowAndFollowCountTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 25/04/2025.
//

import XCTest

final class FetchingFollowAndFollowCountTests: XCTestCase {

    var sut: FetchingFollowAndFollowCount!
    var mockService: MockFetchingFollowService!

    override func setUp() {
        super.setUp()
        mockService = MockFetchingFollowService()
        sut = FetchingFollowAndFollowCount(firestoreService: mockService)
    }

    func test_fetchFollow_returnsExpectedFollows() async throws {
        
        let mockFollows = [
            Follow(followId: "1", follower: "user1", following: "user2", updateTime: .init(date: Date())),
            Follow(followId: "2", follower: "user1", following: "user3", updateTime: .init(date: Date())),
            Follow(followId: "3", follower: "user1", following: "user4", updateTime: .init(date: Date()))
        ]
        mockService.mockFollows = mockFollows

        let result = await sut.fetchFollow(uid: "user1", byField: .followerField)

        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result.first?.followId, "1")
    }
    
    func test_fetchFollow_throwsInvalidInput_returnsEmptyArray() async {

        mockService.shouldThrowInvalidInput = true

        let result = await sut.fetchFollow(uid: "", byField: .followerField)

        XCTAssertTrue(result.isEmpty)
    }
    
    func test_fetchFollowCount_returnsExpectedCount() async throws {
        
        mockService.mockCount = 15

        let count = await sut.fetchFollowCount(uid: "user1", byField: .followerField)

        XCTAssertEqual(count, 15)
    }

    func test_fetchFollowCount_throwsError_returnsZero() async {
        
        mockService.shouldThrowGenericError = true

        let count = await sut.fetchFollowCount(uid: "user1", byField: .followingField)

        XCTAssertEqual(count, 0)
    }
}
