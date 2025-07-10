//
//  FirestoreCreateUserServiceTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 29/06/2025.
//

import XCTest
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirestoreCreateUserServiceTests: XCTestCase {

    var mockFirestore: MockFirestore!
    var sut: FirestoreCreateUserService!

    let testUserID = "testUser123"
    let testEmail = "testU@test.co"
    let testFullname = "Test User"
    let testUsername = "testUser"
    
    lazy var testUser: User = User(id: testUserID,
                                   fullname: testFullname,
                                   username: testUsername,
                                   email: testEmail,
                                   isDelete: false)
    lazy var expectedUniqueEntry: UniqueUsernameEntry = UniqueUsernameEntry(userId: testUserID,
                                                                            time: Timestamp())
    
    override func setUp() {
        super.setUp()
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        mockFirestore = MockFirestore()
        
        sut = FirestoreCreateUserService(firestoreInstance: mockFirestore)
        
    }
    
    override func tearDown() {
        sut = nil
        mockFirestore = nil
        super.tearDown()
    }
    
    func test_createUserWithUniqueUsername_success_unique() async throws {
        
        mockFirestore.configureNextTransaction =  { mockTransaction in
            let userMockTransaction = mockTransaction
            let uniqueUsernamePath = "unique_usernames/\(self.testUsername.lowercased())"
            userMockTransaction.configureGetDocument(path: uniqueUsernamePath, exists: false)
        }
        
        try await sut.createUserWithUniqueUsername(user: testUser, username: testUsername)
        
        XCTAssertNotNil(mockFirestore.lastExecutedTransaction, "A transaction should have been run.")
        guard let transaction = mockFirestore.lastExecutedTransaction else { return }
        
        let userDocPath = testUserID
        XCTAssertNotNil(transaction.capturedSetDataCodable[userDocPath],
                        "User document should have been set.")
        XCTAssertEqual(transaction.capturedSetDataCodable[userDocPath] as? User,
                       testUser,
                       "Captured user data should match expected.")
        
        let uniqueUsernamePath = self.testUsername.lowercased()
        XCTAssertNotNil(transaction.capturedSetDataCodable[uniqueUsernamePath],
                        "Unique username entry document should have been set.")
        XCTAssertEqual(transaction.capturedSetDataCodable[uniqueUsernamePath] as? UniqueUsernameEntry,
                       expectedUniqueEntry,
                       "Captured unique username entry should match expected (excluding server timestamp).")
        
        XCTAssertTrue(transaction.capturedUpdateData.isEmpty,
                      "No documents should have been updated.")
        XCTAssertTrue(transaction.capturedDeleteDocument.isEmpty,
                      "No documents should have been deleted.")
        
    }
    
    func test_createUserWithUniqueUsername_failure_usernameAlreadyTaken() async {
        
        mockFirestore.configureNextTransaction =  { mockTransaction in
            let userMockTransaction = mockTransaction
            let uniqueUsernamePath = self.testUsername.lowercased()
            userMockTransaction.configureGetDocument(path: uniqueUsernamePath, exists: true)
        }
        
        do {
            try await sut.createUserWithUniqueUsername(user: testUser, username: testUsername)
            XCTFail("Expected usernameTakenDuringRegistration error, but call succeeded.")
        } catch let error as NSError {
            XCTAssertEqual(error.code, 409, "Error code should indicate conflict.")
            XCTAssertEqual(error.localizedDescription,
                           UserError.usernameTakenDuringRegistration.localizedDescription,
                           "Error message should match username taken message.")
            
            XCTAssertNotNil(mockFirestore.lastExecutedTransaction,
                            "A transaction should have been run.")
            XCTAssertTrue(mockFirestore.lastExecutedTransaction?.capturedSetDataCodable.isEmpty ?? false,
                          "No Codable data should have been set due to username conflict.")
            XCTAssertTrue(mockFirestore.lastExecutedTransaction?.capturedSetDataDictionary.isEmpty ?? false,
                          "No Dictionary data should have been set due to username conflict.")
            
        } catch {
            XCTFail("Caught unexpected error type: \(error)")
        }
    }
    
    func test_createUserWithUniqueUsername_failure_firestoreErrorDuringGetDocument() async {
        
        let expectedFirestoreError = NSError(domain: FirestoreErrorDomain,
                                              code: FirestoreErrorCode.unavailable.rawValue,
                                              userInfo: [NSLocalizedDescriptionKey: "Simulated network unavailable"])
        
        mockFirestore.configureNextTransaction =  { mockTransaction in
            let userMockTransaction = mockTransaction
            let uniqueUsernamePath = self.testUsername.lowercased()
            userMockTransaction.configureGetDocumentError(path: uniqueUsernamePath, error: expectedFirestoreError)
        }
        
        do {
            try await sut.createUserWithUniqueUsername(user: testUser, username: testUsername)
            XCTFail("Expected an error from Firestore, but call succeeded.")
        } catch let error as NSError {
            XCTAssertEqual(error.domain,
                           FirestoreErrorDomain,
                           "Error domain should match Firestore error.")
            XCTAssertEqual(error.code,
                           FirestoreErrorCode.unavailable.rawValue,
                           "Error code should match simulated error.")
        } catch {
            XCTFail("Caught unexpected error type: \(error)")
        }
        
        XCTAssertNotNil(mockFirestore.lastExecutedTransaction,
                        "A transaction should have been run.")
        XCTAssertTrue(mockFirestore.lastExecutedTransaction?.capturedSetDataCodable.isEmpty ?? false,
                      "No data should have been set if getDocument failed.")
    }
    
    func test_createUserWithUniqueUsername_failure_transactionThrowsBeforeBlock() async {
        
        let genericTransactionError = NSError(domain: "TestDomain",
                                              code: 999,
                                              userInfo: [NSLocalizedDescriptionKey: "A generic transaction error occurred."])
        mockFirestore.runTransactionShouldThrow = genericTransactionError
        
        do {
            try await sut.createUserWithUniqueUsername(user: testUser, username: testUsername)
            XCTFail("Expected a generic transaction error, but call succeeded.")
        } catch let error as NSError {
            XCTAssertEqual(error.domain, "TestDomain", "Error domain should match the simulated error.")
            XCTAssertEqual(error.code, 999, "Error code should match the simulated error.")
        } catch {
            XCTFail("Caught unexpected error type: \(error)")
        }
        
        XCTAssertNil(mockFirestore.lastExecutedTransaction,
                     "No transaction block should have been executed if runTransaction itself threw.")
    }
}
