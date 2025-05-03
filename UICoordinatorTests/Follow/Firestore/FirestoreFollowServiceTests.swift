//
//  FirestoreFollowServiceTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 25/04/2025.
//

import XCTest
import Firebase

final class FirestoreFollowServiceTests: XCTestCase {

    var mockService: MockFirestoreFollowService!
        
    override func setUp() {
        super.setUp()
        mockService = MockFirestoreFollowService()
    }
        
    override func tearDown() {
        mockService = nil
        super.tearDown()
    }
    
    func test_getFollows_returnsSortedFollows() async throws {

        let follow1 = Follow(followId: "1", follower: "1324", following: "following_1", updateTime: .init(date: Date(timeIntervalSince1970: 1)))
        let follow2 = Follow(followId: "2", follower: "2233", following: "following_1", updateTime: .init(date: Date(timeIntervalSince1970: 2)))
        mockService.mockFollows = [follow2, follow1]

        let result = try await mockService.getFollows(uid: "following_1", followField: .followerField)

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.followId, "1")
    }
    
    func test_getFollowCount_returnsCorrectCount() async throws {

        mockService.mockFollowCount = 5

        let count = try await mockService.getFollowCount(uid: "following_1", followField: .followingField)

        XCTAssertEqual(count, 5)
    }
    
    func test_getFollows_throwsOnEmptyInput() async {

        do {
            _ = try await mockService.getFollows(uid: "", followField: .followerField)
            XCTFail("Expected error was not thrown")
        } catch let error as FollowError {
            XCTAssertEqual(error, .invalidInput)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
        
    func test_getFollowCount_throwsOnEmptyInput() async {

        do {
            _ = try await mockService.getFollowCount(uid: "", followField: .followingField)
            XCTFail("Expected error was not thrown")
        } catch let error as FollowError {
            XCTAssertEqual(error, .invalidInput)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}

