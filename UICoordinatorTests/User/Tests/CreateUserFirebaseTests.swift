//
//  CreateUserFirebaseTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 01/07/2025.
//

import XCTest

final class CreateUserFirebaseTests: XCTestCase {

    var mockFirestoreService: MockFirestoreCreateUserService!
    var sut: CreateUserFirebase!
    
    let testUserID = "1userId"
    let testEmail = "test@user.com"
    let testFullname = "User Test"
    let testUsername = "testname"
    
    lazy var expectedUser: User = User(id: testUserID, fullname: testFullname, username: testUsername, email: testEmail, isDelete: false)
    
    override func setUp() {
        super.setUp()
        mockFirestoreService = MockFirestoreCreateUserService()
        sut = CreateUserFirebase(firestoreService: mockFirestoreService)
    }
    
    override func tearDown() {
        sut = nil
        mockFirestoreService = nil
        super.tearDown()
    }
    
    func test_uploadUserData_success_delegatesToFirestoreService() async throws {
        
        try await sut.uploadUserData(id: testUserID, withEmail: testEmail, fullname: testFullname, username: testUsername)
        
        XCTAssertTrue(mockFirestoreService.createUserWithUniqueUsernameCalled, "createUserWithUniqueUsername should have been called.")
        
        XCTAssertEqual(mockFirestoreService.capturedUser, expectedUser,
                       "Captured user object should match the expected user.")
        XCTAssertEqual(mockFirestoreService.capturedUsername, testUsername,
                       "Captured username should match the expected username.")
    }
    
    func test_uploadUserData_failure_propagatesErrorFromFirestoreService() async {
        
        let mockError = NSError(domain: "MockErrorDomain",
                                code: 100,
                                userInfo: [NSLocalizedDescriptionKey: "Simulated Firestore service error"])
        
        mockFirestoreService.shouldThrowError = mockError
        
        do {
            try await sut.uploadUserData(id: testUserID, withEmail: testEmail, fullname: testFullname, username: testUsername)
            XCTFail("uploadUserData should have thrown an error.")
        } catch let caughtError as NSError {
            XCTAssertEqual(caughtError.domain,
                           mockError.domain,
                           "Propagated error domain should match mock error.")
            XCTAssertEqual(caughtError.code,
                           mockError.code,
                           "Propagated error code should match mock error.")
            XCTAssertEqual(caughtError.localizedDescription,
                           mockError.localizedDescription,
                           "Propagated error description should match mock error.")
        } catch {
            XCTFail("Caught an unexpected error type: \(error)")
        }
        
        XCTAssertTrue(mockFirestoreService.createUserWithUniqueUsernameCalled,
                      "createUserWithUniqueUsername should have been called even on error.")
    }
}
