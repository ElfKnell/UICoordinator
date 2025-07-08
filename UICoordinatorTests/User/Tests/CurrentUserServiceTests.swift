//
//  CurrentUserServiceTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 07/07/2025.
//

import XCTest
import FirebaseFirestore
import FirebaseFirestoreSwift

final class CurrentUserServiceTests: XCTestCase {

    var mockFirestoreService: MockFirestoreService!
    var sut: CurrentUserService!
    
    let testUserID = "1userId123"
    let testUserEmail = "test@example.com"
    let testFullname = "User Test"
    let testUsername = "testname"
    
    var exampleUserData: [String: Any] {
        return [
            "id": testUserID,
            "fullname": testFullname,
            "username": testUsername,
            "email": testUserEmail,
            "isDelete": false
        ]
    }

    var updatedExampleUserData: [String: Any] {
        return [
            "id": testUserID,
            "fullname": "Updated Name",
            "username": "updateduser",
            "email": "updated@example.com",
            "isDelete": false
        ]
    }
    
    override func setUp() {
        super.setUp()
        mockFirestoreService = MockFirestoreService()
        sut = CurrentUserService(firestoreService: mockFirestoreService)
    }
    
    override func tearDown() {
        sut = nil
        mockFirestoreService = nil
        super.tearDown()
    }
    
    func test_fetchCurrentUser_success() async throws {
        
        let mockSnapshot = MockDocumentSnapshot(documentID: testUserID, exists: true, data: exampleUserData)
        mockFirestoreService.getUserDocumentResult = mockSnapshot
        
        try await sut.fetchCurrentUser(userId: testUserID)
        
        // 1. Verify getUserDocument was called with the correct ID
        XCTAssertTrue(mockFirestoreService.getUserDocumentCalled)
        XCTAssertEqual(mockFirestoreService.capturedUserID, testUserID)

        // 2. Verify currentUser property is set correctly
        XCTAssertNotNil(sut.currentUser)
        XCTAssertEqual(sut.currentUser?.id, testUserID)
        XCTAssertEqual(sut.currentUser?.email, testUserEmail)
        XCTAssertEqual(sut.currentUser?.username, testUsername)
    }
    
    func test_fetchCurrentUser_failure_userIdNil() async {
        
        let nilUserID: String? = nil
        
        do {
            try await sut.fetchCurrentUser(userId: nilUserID)
            XCTFail("Expected UserError.userIdNil, but call succeeded.")
        } catch let caughtError as UserError {
            if case .userIdNil = caughtError {
                XCTAssertTrue(true, "Caught expected UserError.userIdNil.")
            } else {
                XCTFail("Caught unexpected UserError type: \(caughtError)")
            }
        } catch {
            XCTFail("Caught unexpected error type: \(error)")
        }
        
        XCTAssertFalse(mockFirestoreService.getUserDocumentCalled)
    }
    
    func test_fetchCurrentUser_failure_firestoreServiceThrows() async {
        let firestoreError = NSError(domain: "FirestoreDomain",
                                     code: 404,
                                     userInfo: [NSLocalizedDescriptionKey: "Document not found."])
        mockFirestoreService.getUserDocumentShouldThrow = firestoreError
        
        do {
            try await sut.fetchCurrentUser(userId: testUserID)
            XCTFail("Expected an error from FirestoreService, but call succeeded.")
        } catch let caughtError as NSError {
            XCTAssertEqual(caughtError.domain, firestoreError.domain)
            XCTAssertEqual(caughtError.code, firestoreError.code)
            XCTAssertEqual(caughtError.localizedDescription, firestoreError.localizedDescription)
        } catch {
            XCTFail("Caught unexpected error type: \(error)")
        }
        
        XCTAssertTrue(mockFirestoreService.getUserDocumentCalled)
        XCTAssertNil(sut.currentUser)
    }
    
    func test_fetchCurrentUser_failure_decodeDataThrows() async {
        
        let mockSnapshot = MockDocumentSnapshot(documentID: testUserID, exists: true, data: ["invalid_key": "value"])
        mockSnapshot.decodeDataShouldThrow = UserError.invalidType
        mockFirestoreService.getUserDocumentResult = mockSnapshot
        
        do {
            try await sut.fetchCurrentUser(userId: testUserID)
            XCTFail("Expected decodeData error, but call succeeded.")
        } catch let caughtError as UserError {
            if case .invalidType = caughtError {
                XCTAssertTrue(true, "Caught expected UserError.invalidType.")
            } else {
                XCTFail("Caught unexpected UserError type: \(caughtError)")
            }
        } catch {
            XCTFail("Caught unexpected error type: \(error)")
        }
        
        XCTAssertTrue(mockFirestoreService.getUserDocumentCalled)
        XCTAssertNil(sut.currentUser)
    }
    
    func test_updateCurrentUser_success() async throws {
        
        sut.currentUser = User(id: testUserID,
                               fullname: "Old Name",
                               username: "olduser",
                               email: "old@example.com",
                               isDelete: false)
       
        let mockUpdatedSnapshot = MockDocumentSnapshot(documentID: testUserID,
                                                       exists: true,
                                                       data: updatedExampleUserData)
        mockFirestoreService.getUserDocumentResult = mockUpdatedSnapshot
        
        try await sut.updateCurrentUser()
        
        // 1. Verify getUserDocument was called with the correct UID
        XCTAssertTrue(mockFirestoreService.getUserDocumentCalled)
        XCTAssertEqual(mockFirestoreService.capturedUserID, testUserID)

        // 2. Verify currentUser property is updated
        XCTAssertNotNil(sut.currentUser)
        XCTAssertEqual(sut.currentUser?.fullname, "Updated Name")
        XCTAssertEqual(sut.currentUser?.username, "updateduser")
        XCTAssertEqual(sut.currentUser?.email, "updated@example.com")
    }
    
    func test_updateCurrentUser_failure_currentUserNil() async {
        
        sut.currentUser = nil
        
        do {
            try await sut.updateCurrentUser()
            XCTFail("Expected UserError.userIdNil, but call succeeded.")
        } catch let caughtError as UserError {
            if case .userIdNil = caughtError {
                XCTAssertTrue(true, "Caught expected UserError.userIdNil.")
            } else {
                XCTFail("Caught unexpected UserError type: \(caughtError)")
            }
        } catch {
            XCTFail("Caught unexpected error type: \(error)")
        }
        
        XCTAssertFalse(mockFirestoreService.getUserDocumentCalled)
    }
    
    func test_updateCurrentUser_failure_firestoreServiceThrows() async {
        
        sut.currentUser = User(id: testUserID,
                               fullname: "Test",
                               username: "test",
                               email: "test",
                               isDelete: false)
        let firestoreError = NSError(domain: "FirestoreDomain",
                                     code: 500,
                                     userInfo: [NSLocalizedDescriptionKey: "Server error."])
        mockFirestoreService.getUserDocumentShouldThrow = firestoreError
        
        do {
            try await sut.updateCurrentUser()
            XCTFail("Expected an error from FirestoreService, but call succeeded.")
        } catch let caughtError as NSError {
            XCTAssertEqual(caughtError.domain, firestoreError.domain)
            XCTAssertEqual(caughtError.code, firestoreError.code)
            XCTAssertEqual(caughtError.localizedDescription, firestoreError.localizedDescription)
        } catch {
            XCTFail("Caught unexpected error type: \(error)")
        }
        
        XCTAssertTrue(mockFirestoreService.getUserDocumentCalled)
        
        XCTAssertEqual(sut.currentUser?.id, testUserID)
        XCTAssertEqual(sut.currentUser?.fullname, "Test")
    }
    
    func test_updateCurrentUser_failure_decodeDataThrows() async {
        
        sut.currentUser = User(id: testUserID,
                               fullname: "Old Name",
                               username: "olduser",
                               email: "old@example.com",
                               isDelete: false)
        
        let mockSnapshot = MockDocumentSnapshot(documentID: testUserID,
                                                exists: true,
                                                data: ["invalid_key": "value"])
        
        mockSnapshot.decodeDataShouldThrow = UserError.invalidType
        mockFirestoreService.getUserDocumentResult = mockSnapshot
        
        do {
            try await sut.updateCurrentUser()
            XCTFail("Expected decodeData error, but call succeeded.")
        } catch let caughtError as UserError {
            if case .invalidType = caughtError {
                XCTAssertTrue(true, "Caught expected UserError.invalidType.")
            } else {
                XCTFail("Caught unexpected UserError type: \(caughtError)")
            }
        } catch {
            XCTFail("Caught unexpected error type: \(error)")
        }
        
        XCTAssertTrue(mockFirestoreService.getUserDocumentCalled)
        
        XCTAssertEqual(sut.currentUser?.id, testUserID)
        XCTAssertEqual(sut.currentUser?.fullname, "Old Name")
    }
}
