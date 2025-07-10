//
//  UserServiceUpdateTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 09/07/2025.
//

import XCTest

final class UserServiceUpdateTests: XCTestCase {
    
    var sut: UserServiceUpdate!
    var mockFirestore: MockFirestore!
    var mockImageUploader: MockImageUploader!
    var logger: SpyLogger!
    
    let testUserID = "testUser123"
    let testEmail = "testU@test.com"
    let testFullname = "Test User"
    let testUsername = "testser"
    
    lazy var testUser: User = User(id: testUserID,
                                   fullname: testFullname,
                                   username: testUsername,
                                   email: testEmail,
                                   isDelete: false)

    override func setUp() {
        super.setUp()
        mockFirestore = MockFirestore()
        mockImageUploader = MockImageUploader()
        logger = SpyLogger()
        sut = UserServiceUpdate(firestore: mockFirestore, imageUpload: mockImageUploader, logger: logger)
    }

    override func tearDown() {
        sut = nil
        mockFirestore = nil
        mockImageUploader = nil
        super.tearDown()
    }

    func test_updateUserProfile_noImage_noUsernameChange() async throws {
        
        let dataToUpdate: [String: Any] = ["bio": "New bio"]

        try await sut.updateUserProfile(user: testUser, image: nil, dataUser: dataToUpdate)

        XCTAssertEqual(mockFirestore.capturedCollectionUpdates[testUser.id]?["bio"] as? String, "New bio")
        XCTAssertNil(mockFirestore.capturedCollectionUpdates[testUser.id]?["profileImageURL"])
        XCTAssertNil(mockFirestore.lastExecutedTransaction)
    }
    
    func test_updateUserProfile_withImage_noUsernameChange() async throws {
        
        let image = UIImage(systemName: "photo")!
        let dataToUpdate: [String: Any] = ["bio": "New bio"]
        let expectedImageURL = "http://example.com/new_image.jpg"
        mockImageUploader.uploadImageResult = .success(expectedImageURL)
        
        try await sut.updateUserProfile(user: testUser, image: image, dataUser: dataToUpdate)
        
        XCTAssertEqual(mockImageUploader.uploadedImage, image)
        XCTAssertEqual(mockImageUploader.uploadedUser, testUser)
        XCTAssertEqual(mockFirestore.capturedCollectionUpdates[testUser.id]?["bio"] as? String, "New bio")
        XCTAssertEqual(mockFirestore.capturedCollectionUpdates[testUser.id]?["profileImageURL"] as? String, expectedImageURL)
        XCTAssertNil(mockFirestore.lastExecutedTransaction)
    }
    
    func test_updateUserProfile_withImageUpload_fails() async {
        
        let image = UIImage(systemName: "photo")!
        let dataToUpdate: [String: Any] = ["bio": "New bio"]
        let expectedError = NSError(domain: "ImageUploadError", code: 100, userInfo: nil)
        mockImageUploader.uploadImageResult = .failure(expectedError)
        
        do {
            try await sut.updateUserProfile(user: testUser, image: image, dataUser: dataToUpdate)
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertEqual((error as NSError).domain, expectedError.domain)
            XCTAssertEqual((error as NSError).code, expectedError.code)
            XCTAssertNotNil(mockImageUploader.uploadedImage)
            XCTAssertNotNil(mockImageUploader.uploadedUser)
            XCTAssertNil(mockFirestore.capturedCollectionUpdates[testUser.id])
        }
    }
    
    func test_updateUserProfile_usernameChange_available() async throws {
        
        let newUsername = "newUsername"
        let dataToUpdate: [String: Any] = ["username": newUsername, "bio": "New bio"]

        mockFirestore.configureNextTransaction = { transaction in
            transaction.configureGetDocument(path: newUsername.lowercased(), exists: false)
        }
        
        try await sut.updateUserProfile(user: testUser, image: nil, dataUser: dataToUpdate)

        XCTAssertNotNil(mockFirestore.lastExecutedTransaction)
        let transaction = mockFirestore.lastExecutedTransaction!

        let userDocFullPath = testUserID
        XCTAssertEqual(transaction.capturedUpdateData[userDocFullPath]?["username"] as? String, newUsername)
        XCTAssertEqual(transaction.capturedUpdateData[userDocFullPath]?["bio"] as? String, "New bio")

        let uniqueEntryPath = newUsername.lowercased()
        XCTAssertNotNil(transaction.capturedSetDataDictionary[uniqueEntryPath])
        let uniqueEntry = transaction.capturedSetDataCodable[uniqueEntryPath] as? UniqueUsernameEntry
        XCTAssertEqual(uniqueEntry?.userId, testUser.id)

        XCTAssertTrue(transaction.capturedDeleteDocument.contains(testUsername.lowercased()))
    }
    
    func test_updateUserProfile_usernameChange_taken() async {
        
        let newUsername = "takenusername"
        let dataToUpdate: [String: Any] = ["username": newUsername]

        mockFirestore.configureNextTransaction = { transaction in
            transaction.configureGetDocument(path: newUsername.lowercased(), exists: true)
        }
        
        do {
            try await sut.updateUserProfile(user: testUser, image: nil, dataUser: dataToUpdate)
            XCTFail("Expected an error to be thrown")
        } catch let error as NSError {
            XCTAssertNotNil(mockFirestore.lastExecutedTransaction)
            XCTAssertEqual(error.domain, "AuthError")
            XCTAssertEqual(error.code, 409)
            XCTAssertEqual(error.localizedDescription, "Username was taken during registration. Please try again.")
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func test_updateUserProfile_usernameChange_transactionFails() async {
        
        let newUsername = "newUsername"
        let dataToUpdate: [String: Any] = ["username": newUsername]
        let expectedError = NSError(domain: "TransactionError", code: 500, userInfo: nil)

        mockFirestore.configureNextTransaction = { transaction in
            transaction.getDocumentShouldThrow = expectedError
        }
        
        do {
            try await sut.updateUserProfile(user: testUser, image: nil, dataUser: dataToUpdate)
            XCTFail("Expected an error to be thrown")
        } catch let error as NSError {
            XCTAssertNotNil(mockFirestore.lastExecutedTransaction)
            XCTAssertEqual(error.domain, expectedError.domain)
            XCTAssertEqual(error.code, expectedError.code)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func test_deleteUser_success() async {
        
        let userId = "user123"
        await sut.deleteUser(userId: userId)
        XCTAssertEqual(mockFirestore.capturedCollectionUpdates[userId]?["isDelete"] as? Bool, true)
    }
    
    func test_deleteUser_nilUserId() async throws {
        
        await sut.deleteUser(userId: nil)

        XCTAssertTrue(logger.messages.contains { $0.contains("Current user not found") })
    }
}
