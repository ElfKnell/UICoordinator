//
//  UserServiceTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 23/04/2025.
//

import XCTest

final class UserServiceTests: XCTestCase {

    var mockFirestoreService: MockFirestoreService!
    var sut: UserService!
    
    let testUserID = "test_user_id_123"
    let testUserEmail = "test@example.com"
    let testUsername = "testuser"
    let testFullname = "Test User"
    
    var exampleUserData: [String: Any] {
        return [
            "id": testUserID,
            "fullname": testFullname,
            "username": testUsername,
            "email": testUserEmail,
            "isDelete": false
        ]
    }
    
    override func setUp() {
        super.setUp()
        mockFirestoreService = MockFirestoreService()
        sut = UserService(firestoreUserDocument: mockFirestoreService)
    }
    
    override func tearDown() {
        sut = nil
        mockFirestoreService = nil
        super.tearDown()
    }
    
    func testFetchUser_success() async throws {
        
        let mockSnapshot = MockDocumentSnapshot(documentID: testUserID, exists: true, data: exampleUserData)
        mockFirestoreService.getUserDocumentResult = mockSnapshot
        
        let fetchedUser = try await sut.fetchUser(withUid: testUserID)
        
        // 1. Verify getUserDocument was called with the correct UID
        XCTAssertTrue(mockFirestoreService.getUserDocumentCalled)
        XCTAssertEqual(mockFirestoreService.capturedUserID, testUserID)

        // 2. Verify the returned User object is correct
        XCTAssertEqual(fetchedUser.id, testUserID)
        XCTAssertEqual(fetchedUser.email, testUserEmail)
        XCTAssertEqual(fetchedUser.username, testUsername)
        XCTAssertEqual(fetchedUser.fullname, testFullname)
    }

    func test_fetchUser_failure_firestoreThrowsError() async {
        
        let firestoreError = NSError(domain: "FirestoreDomain",
                                     code: 1,
                                     userInfo: [NSLocalizedDescriptionKey: "Network unavailable"])
        mockFirestoreService.getUserDocumentShouldThrow = firestoreError
        
        do {
            _ = try await sut.fetchUser(withUid: testUserID)
            XCTFail("Expected UserError.userNotFound, but call succeeded.")
        } catch let caughtError as UserError {
            if case .userNotFound = caughtError {
                XCTAssertTrue(true, "Caught expected UserError.userNotFound.")
            } else {
                XCTFail("Caught unexpected UserError type: \(caughtError)")
            }
        } catch {
            XCTFail("Caught unexpected error type: \(error)")
        }
        XCTAssertTrue(mockFirestoreService.getUserDocumentCalled)
    }
    
    func test_fetchUser_failure_documentDoesNotExist() async {
        
        let mockSnapshot = MockDocumentSnapshot(documentID: testUserID, exists: false, data: nil)
        mockFirestoreService.getUserDocumentResult = mockSnapshot
        
        do {
            _ = try await sut.fetchUser(withUid: testUserID)
            XCTFail("Expected UserError.userNotFound, but call succeeded.")
        } catch let caughtError as UserError {
            if case .userNotFound = caughtError {
                XCTAssertTrue(true, "Caught expected UserError.userNotFound.")
            } else {
                XCTFail("Caught unexpected UserError type: \(caughtError)")
            }
        } catch {
            XCTFail("Caught unexpected error type: \(error)")
        }
        XCTAssertTrue(mockFirestoreService.getUserDocumentCalled)
    }
    
    func test_fetchUser_failure_decodeDataThrowsError() async {
        
        let mockSnapshot = MockDocumentSnapshot(documentID: testUserID,
                                                exists: true,
                                                data: ["id": "wrong_type", "fullname": 123])
        mockSnapshot.decodeDataShouldThrow = UserError.invalidType
        mockFirestoreService.getUserDocumentResult = mockSnapshot
        
        do {
            _ = try await sut.fetchUser(withUid: testUserID)
            XCTFail("Expected UserError.userNotFound, but call succeeded.")
        } catch let caughtError as UserError {
            if case .userNotFound = caughtError {
                XCTAssertTrue(true, "Caught expected UserError.userNotFound.")
            } else {
                XCTFail("Caught unexpected UserError type: \(caughtError)")
            }
        } catch {
            XCTFail("Caught unexpected error type: \(error)")
        }
        XCTAssertTrue(mockFirestoreService.getUserDocumentCalled)
    }
}
