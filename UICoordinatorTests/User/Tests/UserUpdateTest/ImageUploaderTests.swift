//
//  ImageUploaderTests.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 08/07/2025.
//

import XCTest

final class ImageUploaderTests: XCTestCase {
    
    var sut: ImageUploader!
    var mockStorage: MockStorage!
    var mockUser: User!
    
    let testUserID = "test_user_id_123"
    let testUserEmail = "test@example.com"
    let testUsername = "testuser"
    let testFullname = "Test User"
    let testUserURL = "https://fakeurl.com/old_image.jpg"

    override func setUp() {
        super.setUp()
        mockStorage = MockStorage()
        mockStorage.mockReference.reset()
        sut = ImageUploader(storage: mockStorage)
        mockUser = User(id: testUserID,
                        fullname: testFullname,
                        username: testUsername,
                        email: testUserEmail,
                        profileImageURL: testUserURL,
                        isDelete: false)
    }

    override func tearDown() {
        sut = nil
        mockStorage = nil
        mockUser = nil
        super.tearDown()
    }

    func test_uploadImage_success() async throws {
        
        let image = UIImage(systemName: "star")!
        let expectedURL = URL(string: "https://fakeurl.com/new_image.jpg")!
        mockStorage.mockReference.downloadURLToReturn = expectedURL

        let urlString = try await sut.uploadeImage(image, currentUser: mockUser)

        XCTAssertEqual(urlString, expectedURL.absoluteString)
        XCTAssertNotNil(mockStorage.mockReference.deletedPath, "The old image should have been deleted")
    }
    
    func test_uploadImage_uploadFails() async {
        
        let image = UIImage(systemName: "star")!
        mockStorage.mockReference.shouldThrowErrorOnPutData = true
        
        do {
            _ = try await sut.uploadeImage(image, currentUser: mockUser)
            XCTFail("Should have thrown UserError.imageUploadError")
        } catch _ as UserError {
            XCTAssertTrue(true, "Correct error type was thrown")
        } catch {
            XCTFail("An unexpected error was thrown: \(error)")
        }
    }
    
    func test_deleteImage_success() async throws {
        
        XCTAssertNotNil(mockUser.profileImageURL)
        try await sut.deleteImage(currentUser: mockUser)
        XCTAssertNotNil(mockStorage.mockReference.deletedPath)
        
    }
    
    func test_deleteImage_noURL() async throws {
        
        mockUser.profileImageURL = nil
        try await sut.deleteImage(currentUser: mockUser)
        XCTAssertNil(mockStorage.mockReference.deletedPath,
                     "Delete should not be called when there is no URL")
    }
    
    func test_deleteImage_fails() async {
        
        mockStorage.mockReference.shouldThrowErrorOnDelete = true
        
        do {
            try await sut.deleteImage(currentUser: mockUser)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(true, "Error was correctly thrown on deletion failure")
        }
    }
}
