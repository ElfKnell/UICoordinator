//
//  FetchLikesServiceTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 03/05/2025.
//

import Firebase
import XCTest

final class FetchLikesServiceTests: XCTestCase {
    
    var sut: FetchLikesService!
    var mockRepocitory: MockFirestoreLikeRepository!
    
    override func setUp() {
        super.setUp()
        mockRepocitory = MockFirestoreLikeRepository()
        sut = FetchLikesService(likeRepository: mockRepocitory)
    }

    func testGetLikeByColloquyAndUser_Success() async {
        
        let result = await sut.getLikeByColloquyAndUser(collectionName: .likes, colloquyId: "testColloquy", userId: "user123")
        
        XCTAssertEqual(result, "mock_like_id")
    }

    func testGetLikeByColloquyAndUser_Error() async {
        
        mockRepocitory.shouldThrowGenericError = true
        let servise = FetchLikesService(likeRepository: mockRepocitory)
        
        let result = await sut.getLikeByColloquyAndUser(collectionName: .likes, colloquyId: "testColloquy", userId: "user123")
        
        XCTAssertNil(result)
    }
    
    func testGetLikes_Success() async {
        
        let result = await sut.getLikes(collectionName: .activityLikes, byField: .userIdField, userId: "user123")
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.likeId, "like11")
    }
    
    func testGetLikes_Error() async {
        mockRepocitory.shouldThrowGenericError = true
        let servise = FetchLikesService(likeRepository: mockRepocitory)
        
        let result = await sut.getLikes(collectionName: .likes, byField: .userIdField, userId: "user123")
        
        XCTAssertTrue(result.isEmpty)
    }
}
